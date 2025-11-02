import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import Stripe from 'stripe';
import { PaymentConstants } from './constants/payment-constants';

const stripe = new Stripe(functions.config().stripe.secret_key, {
  apiVersion: '2024-04-10',
});

/**
 * Stripe payment processing for system purchases
 * Handles payment intent creation with Stripe Connect
 */

interface CreateSystemPaymentIntentData {
  creatorId: string;
  systemId: string;
  systemName: string;
  price: number; // System price in dollars
}

interface SystemPaymentIntentResponse {
  clientSecret: string;
  purchaseId: string;
  totalAmount: number;
  platformFee: number;
}

/**
 * Create payment intent for system purchase
 * Uses Stripe Connect to split payment between platform and creator
 */
export const createSystemPurchasePaymentIntent = functions.https.onCall(
  async (data: CreateSystemPaymentIntentData, context): Promise<SystemPaymentIntentResponse> => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const buyerId = context.auth.uid;
    const { creatorId, systemId, systemName, price } = data;

    // Validation
    if (!creatorId || !systemId || !systemName || !price) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing required fields');
    }

    if (price <= 0) {
      throw new functions.https.HttpsError('invalid-argument', 'Price must be greater than 0');
    }

    if (buyerId === creatorId) {
      throw new functions.https.HttpsError('invalid-argument', 'Cannot purchase your own system');
    }

    try {
      console.log(`💳 [System Payment] Creating payment intent for system ${systemId}`);

      // Get creator's Stripe account
      const creatorIntegrationDoc = await admin.firestore()
        .collection('creator_integrations')
        .doc(creatorId)
        .get();

      if (!creatorIntegrationDoc.exists || !creatorIntegrationDoc.data()?.stripe?.accountId) {
        throw new functions.https.HttpsError('failed-precondition', 'Creator has not connected Stripe account');
      }

      const stripeAccountId = creatorIntegrationDoc.data()!.stripe.accountId;

      // Verify account is active
      const account = await stripe.accounts.retrieve(stripeAccountId);
      if (!account.charges_enabled) {
        throw new functions.https.HttpsError('failed-precondition', 'Creator account not verified for payments');
      }

      // Calculate fees
      const subtotalCents = Math.round(price * 100);
      const platformFeeCents = Math.round(subtotalCents * PaymentConstants.SYSTEM_PLATFORM_FEE_PERCENT);
      const buyerTotalCents = subtotalCents + platformFeeCents;
      const creatorPayoutCents = subtotalCents;

      console.log(`💰 [System Payment] Price: $${price}, Platform Fee: $${platformFeeCents / 100}, Total: $${buyerTotalCents / 100}`);

      // Create payment intent with Stripe Connect
      const paymentIntent = await stripe.paymentIntents.create({
        amount: buyerTotalCents, // Buyer pays: price + 6%
        currency: 'usd',
        automatic_payment_methods: { enabled: true },
        application_fee_amount: platformFeeCents, // Platform's 6% (instant)
        transfer_data: {
          destination: stripeAccountId, // Creator receives price (instant transfer)
        },
        metadata: {
          creatorId,
          buyerId,
          systemId,
          systemName,
          platform: 'systems_app',
          purchaseType: 'system',
          platformFee: (platformFeeCents / 100).toFixed(2),
          creatorPayout: (creatorPayoutCents / 100).toFixed(2),
        },
      });

      console.log(`✅ [System Payment] Payment intent created: ${paymentIntent.id}`);

      // Create purchase record in Firestore
      const purchaseRef = await admin.firestore().collection('system_purchases').add({
        buyerId,
        creatorId,
        systemId,
        systemName,
        price: price,
        platformFee: platformFeeCents / 100,
        totalAmount: buyerTotalCents / 100,
        creatorPayout: creatorPayoutCents / 100,
        platformFeePercent: PaymentConstants.SYSTEM_PLATFORM_FEE_PERCENT,
        stripeAccountId,
        paymentIntentId: paymentIntent.id,
        status: 'pending_payment',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`📝 [System Payment] Purchase record created: ${purchaseRef.id}`);

      return {
        clientSecret: paymentIntent.client_secret!,
        purchaseId: purchaseRef.id,
        totalAmount: buyerTotalCents / 100,
        platformFee: platformFeeCents / 100,
      };

    } catch (error: any) {
      console.error('❌ [System Payment] Error creating payment intent:', error);

      // Provide user-friendly error messages
      let userMessage = 'Failed to create payment. Please try again.';
      if (error.type === 'StripeInvalidRequestError') {
        userMessage = 'Invalid payment request. Please contact support.';
      } else if (error.code === 'failed-precondition') {
        userMessage = error.message;
      }

      throw new functions.https.HttpsError('internal', userMessage);
    }
  }
);

/**
 * Get payment status for a system purchase
 */
export const getSystemPaymentStatus = functions.https.onCall(
  async (data: { purchaseId: string }, context): Promise<{ status: string; paymentStatus?: string }> => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { purchaseId } = data;

    try {
      const purchaseDoc = await admin.firestore()
        .collection('system_purchases')
        .doc(purchaseId)
        .get();

      if (!purchaseDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Purchase not found');
      }

      const purchaseData = purchaseDoc.data()!;

      // Verify user owns this purchase
      if (purchaseData.buyerId !== context.auth.uid && purchaseData.creatorId !== context.auth.uid) {
        throw new functions.https.HttpsError('permission-denied', 'Not authorized to view this purchase');
      }

      // Check payment intent status if still pending
      if (purchaseData.status === 'pending_payment') {
        const paymentIntent = await stripe.paymentIntents.retrieve(purchaseData.paymentIntentId);

        if (paymentIntent.status === 'succeeded') {
          // Update purchase status
          await admin.firestore()
            .collection('system_purchases')
            .doc(purchaseId)
            .update({
              status: 'completed',
              paidAt: admin.firestore.FieldValue.serverTimestamp(),
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

          // Grant buyer access to system
          await admin.firestore()
            .collection('system_access')
            .doc(purchaseData.buyerId)
            .collection('purchased_systems')
            .doc(purchaseData.systemId)
            .set({
              purchaseId,
              creatorId: purchaseData.creatorId,
              systemName: purchaseData.systemName,
              purchasedAt: admin.firestore.FieldValue.serverTimestamp(),
              canApplyToBets: true,
            });

          return { status: 'completed', paymentStatus: paymentIntent.status };
        }

        return { status: purchaseData.status, paymentStatus: paymentIntent.status };
      }

      return { status: purchaseData.status };

    } catch (error: any) {
      console.error('❌ [System Payment] Error getting payment status:', error);
      throw new functions.https.HttpsError('internal', error.message);
    }
  }
);

/**
 * Cancel/refund a system purchase
 * Only allowed within 24 hours of purchase
 */
export const cancelSystemPurchase = functions.https.onCall(
  async (data: { purchaseId: string }, context): Promise<{ success: boolean }> => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { purchaseId } = data;

    try {
      const purchaseDoc = await admin.firestore()
        .collection('system_purchases')
        .doc(purchaseId)
        .get();

      if (!purchaseDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Purchase not found');
      }

      const purchaseData = purchaseDoc.data()!;

      // Verify user owns this purchase
      if (purchaseData.buyerId !== context.auth.uid) {
        throw new functions.https.HttpsError('permission-denied', 'Only the buyer can cancel');
      }

      // Check if purchase can be refunded (within 24 hours)
      const paidAt = purchaseData.paidAt?.toDate();
      if (!paidAt) {
        throw new functions.https.HttpsError('failed-precondition', 'Purchase not completed');
      }

      const hoursSincePurchase = (Date.now() - paidAt.getTime()) / (1000 * 60 * 60);
      if (hoursSincePurchase > 24) {
        throw new functions.https.HttpsError('failed-precondition', 'Refund period expired (24 hours)');
      }

      // Refund payment
      const paymentIntent = await stripe.paymentIntents.retrieve(purchaseData.paymentIntentId);

      if (paymentIntent.charges.data.length > 0) {
        await stripe.refunds.create({
          charge: paymentIntent.charges.data[0].id,
        });
      }

      // Update purchase status
      await admin.firestore()
        .collection('system_purchases')
        .doc(purchaseId)
        .update({
          status: 'refunded',
          refundedAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      // Remove buyer access
      await admin.firestore()
        .collection('system_access')
        .doc(purchaseData.buyerId)
        .collection('purchased_systems')
        .doc(purchaseData.systemId)
        .delete();

      console.log(`✅ [System Payment] Purchase ${purchaseId} refunded`);

      return { success: true };

    } catch (error: any) {
      console.error('❌ [System Payment] Error canceling purchase:', error);
      throw new functions.https.HttpsError('internal', error.message);
    }
  }
);
