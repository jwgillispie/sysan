import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'package:upsilon_sa/features/marketplace/models/marketplace_system.dart';
import 'package:upsilon_sa/features/marketplace/services/marketplace_service.dart';

/// Detailed view of a marketplace system with purchase option
class SystemDetailSheet extends StatefulWidget {
  final MarketplaceSystem system;

  const SystemDetailSheet({
    super.key,
    required this.system,
  });

  @override
  State<SystemDetailSheet> createState() => _SystemDetailSheetState();
}

class _SystemDetailSheetState extends State<SystemDetailSheet> {
  final MarketplaceService _service = MarketplaceService();
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  bool _isProcessing = false;
  bool _hasPurchased = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPurchaseStatus();
  }

  Future<void> _checkPurchaseStatus() async {
    final purchased = await _service.hasPurchasedSystem(widget.system.systemId);
    setState(() {
      _hasPurchased = purchased;
      _isLoading = false;
    });
  }

  Future<void> _purchaseSystem() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // Call cloud function to create payment intent
      final callable = _functions.httpsCallable('createSystemPurchasePaymentIntent');
      final result = await callable.call({
        'creatorId': widget.system.creatorId,
        'systemId': widget.system.systemId,
        'systemName': widget.system.name,
        'price': widget.system.price,
      });

      final data = result.data as Map<String, dynamic>;
      final clientSecret = data['clientSecret'] as String;
      final totalAmount = data['totalAmount'] as double;
      final platformFee = data['platformFee'] as double;

      if (!mounted) return;

      // Show payment confirmation dialog
      final confirmed = await _showPaymentConfirmation(totalAmount, platformFee);
      if (!confirmed) {
        setState(() => _isProcessing = false);
        return;
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Systems Marketplace',
          style: Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Payment successful
      if (mounted) {
        setState(() {
          _hasPurchased = true;
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Purchase successful! System unlocked.'),
              ],
            ),
            backgroundColor: SystemsColors.primary,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isProcessing = false);

      if (mounted) {
        String errorMessage = 'Purchase failed';
        if (e is StripeException) {
          errorMessage = e.error.message ?? 'Payment failed';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: SystemsColors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showPaymentConfirmation(double total, double fee) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? SystemsColors.darkGrey : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Confirm Purchase',
                style: TextStyle(
                  color: isDark ? SystemsColors.white : SystemsColors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System: ${widget.system.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? SystemsColors.white : SystemsColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPriceRow('System Price', widget.system.price, isDark),
                  _buildPriceRow('Platform Fee (6%)', fee, isDark),
                  const Divider(height: 24),
                  _buildPriceRow(
                    'Total',
                    total,
                    isDark,
                    isTotal: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SystemsColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildPriceRow(String label, double amount, bool isDark, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDark ? SystemsColors.white : SystemsColors.black,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? SystemsColors.primary : (isDark ? SystemsColors.white : SystemsColors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? SystemsColors.black : Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? SystemsColors.smokyGrey : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: SystemsColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.system.sport.toUpperCase(),
                          style: const TextStyle(
                            color: SystemsColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${widget.system.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: SystemsColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // System name
                  Text(
                    widget.system.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? SystemsColors.white : SystemsColors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Creator
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 18,
                        color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'by ${widget.system.creatorName}',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.system.totalPurchases} purchases',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stats
                  if (widget.system.stats != null) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? SystemsColors.darkGrey : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: SystemsColors.primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Performance Stats',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? SystemsColors.white : SystemsColors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildBigStat(
                                  'ROI',
                                  '${widget.system.stats!.roi.toStringAsFixed(1)}%',
                                  SystemsColors.primary,
                                  isDark,
                                ),
                              ),
                              Expanded(
                                child: _buildBigStat(
                                  'Win Rate',
                                  '${widget.system.stats!.winRate.toStringAsFixed(1)}%',
                                  SystemsColors.secondary,
                                  isDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSmallStat(
                                  'Total Bets',
                                  widget.system.stats!.totalBets.toString(),
                                  isDark,
                                ),
                              ),
                              Expanded(
                                child: _buildSmallStat(
                                  'Wins',
                                  widget.system.stats!.wins.toString(),
                                  isDark,
                                ),
                              ),
                              Expanded(
                                child: _buildSmallStat(
                                  'Losses',
                                  widget.system.stats!.losses.toString(),
                                  isDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text(
                    'About This System',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? SystemsColors.white : SystemsColors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.system.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: isDark ? SystemsColors.smokyGrey : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tags
                  if (widget.system.tags.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? SystemsColors.white : SystemsColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.system.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? SystemsColors.darkGrey : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? SystemsColors.white : SystemsColors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 80),
                  ],
                ],
              ),
            ),
              ),
            ],
          ),
          // Purchase button
          _buildPurchaseButton(isDark),
        ],
      ),
    );
  }

  Widget _buildBigStat(String label, String value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? SystemsColors.smokyGrey : Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStat(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? SystemsColors.smokyGrey : Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? SystemsColors.white : SystemsColors.black,
          ),
        ),
      ],
    );
  }

  // Purchase button (sticky at bottom)
  Widget _buildPurchaseButton(bool isDark) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? SystemsColors.black : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasPurchased
                ? ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SystemsColors.primary.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: SystemsColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Already Purchased',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: SystemsColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _isProcessing ? null : _purchaseSystem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SystemsColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Buy for \$${widget.system.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
      ),
    );
  }
}
