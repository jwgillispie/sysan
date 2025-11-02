import * as admin from 'firebase-admin';

// Initialize Firebase Admin
admin.initializeApp();

// Export Stripe Connect functions
export {
  createStripeConnectAccount,
  checkStripeAccountStatus,
  disconnectStripeAccount,
  getStripeAccountLink,
} from './stripe-connect';

// Export System Payment functions
export {
  createSystemPurchasePaymentIntent,
  getSystemPaymentStatus,
  cancelSystemPurchase,
} from './stripe-system-payments';
