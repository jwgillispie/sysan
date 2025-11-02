/**
 * Centralized payment and fee constants for the Systems marketplace
 *
 * This class contains all platform fees, processing fees, and helper methods
 * for consistent fee calculations across Cloud Functions.
 */
export class PaymentConstants {
  // ========== PLATFORM FEES (as decimal percentages) ==========

  /**
   * Platform fee for system purchases (6%)
   * Applied on top of system price - buyer pays this
   */
  static readonly SYSTEM_PLATFORM_FEE_PERCENT = 0.06;

  // ========== STRIPE PROCESSING FEES ==========

  /**
   * Stripe processing percentage (2.9%)
   * This is approximate - actual varies by card type and country
   */
  static readonly STRIPE_PROCESSING_PERCENT = 0.029;

  /**
   * Stripe fixed fee per transaction ($0.30)
   */
  static readonly STRIPE_FIXED_FEE = 0.30;

  // ========== HELPER METHODS ==========

  /**
   * Calculate platform fee for system purchases
   *
   * @example $50 system → $3 platform fee
   */
  static calculateSystemPlatformFee(price: number): number {
    return price * this.SYSTEM_PLATFORM_FEE_PERCENT;
  }

  /**
   * Calculate total charge (price + platform fee)
   *
   * @example $50 system → $53 total charge
   */
  static calculateSystemTotal(price: number): number {
    return price + this.calculateSystemPlatformFee(price);
  }

  /**
   * Calculate Stripe processing fee for a transaction
   *
   * @example $53 charge → ~$1.84 Stripe fee
   */
  static calculateStripeProcessingFee(totalAmount: number): number {
    return (totalAmount * this.STRIPE_PROCESSING_PERCENT) + this.STRIPE_FIXED_FEE;
  }

  /**
   * Calculate platform's net revenue after Stripe fees
   *
   * @example $3 platform fee on $53 charge → $3 - $1.84 = $1.16 net
   */
  static calculateNetRevenue(platformFee: number, totalAmount: number): number {
    return platformFee - this.calculateStripeProcessingFee(totalAmount);
  }
}
