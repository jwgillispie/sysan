import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'package:upsilon_sa/features/marketplace/models/system_purchase.dart';
import 'package:upsilon_sa/features/marketplace/repository/marketplace_repository.dart';

/// Page showing user's purchased systems
class MyPurchasesPage extends StatefulWidget {
  const MyPurchasesPage({super.key});

  @override
  State<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends State<MyPurchasesPage> {
  final MarketplaceRepository _repository = MarketplaceRepository();
  List<SystemPurchase> _purchases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    setState(() => _isLoading = true);

    final purchases = await _repository.getMyPurchases();

    setState(() {
      _purchases = purchases;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? SystemsColors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDark ? SystemsColors.black : Colors.white,
        title: Text(
          'My Purchases',
          style: TextStyle(
            color: isDark ? SystemsColors.white : SystemsColors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? SystemsColors.white : SystemsColors.black,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _purchases.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: isDark ? SystemsColors.smokyGrey : Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No purchases yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Browse the marketplace to find systems',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPurchases,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _purchases.length,
                    itemBuilder: (context, index) {
                      return _buildPurchaseCard(_purchases[index], isDark);
                    },
                  ),
                ),
    );
  }

  Widget _buildPurchaseCard(SystemPurchase purchase, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? SystemsColors.darkGrey : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System name
          Text(
            purchase.systemName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? SystemsColors.white : SystemsColors.black,
            ),
          ),

          const SizedBox(height: 12),

          // Purchase details
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: isDark ? SystemsColors.smokyGrey : Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                'Purchased ${_formatDate(purchase.paidAt ?? purchase.createdAt)}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 14,
                color: isDark ? SystemsColors.smokyGrey : Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                '\$${purchase.totalAmount.toStringAsFixed(2)} (incl. fees)',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: SystemsColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: SystemsColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: SystemsColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Refund option (if within 24 hours)
              if (purchase.canRefund)
                TextButton(
                  onPressed: () => _showRefundDialog(purchase),
                  child: const Text(
                    'Request Refund',
                    style: TextStyle(
                      fontSize: 13,
                      color: SystemsColors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future<void> _showRefundDialog(SystemPurchase purchase) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? SystemsColors.darkGrey : Colors.white,
          title: Text(
            'Request Refund',
            style: TextStyle(
              color: isDark ? SystemsColors.white : SystemsColors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to refund this purchase? You will lose access to the system.',
            style: TextStyle(
              color: isDark ? SystemsColors.smokyGrey : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: SystemsColors.red),
              child: const Text('Refund'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // TODO: Implement refund via cloud function
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refund functionality coming soon')),
      );
    }
  }
}
