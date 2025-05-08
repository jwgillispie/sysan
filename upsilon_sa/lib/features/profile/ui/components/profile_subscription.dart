// lib/features/profile/ui/components/profile_subscription.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/profile/bloc/profile_bloc.dart';

class ProfileSubscription extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;

  const ProfileSubscription({
    super.key,
    required this.subscriptionData,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.card_membership,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SUBSCRIPTION',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              _buildPlanLabel(context, subscriptionData['currentPlan']),
            ],
          ),
          const SizedBox(height: 16),
          _buildCurrentSubscriptionRow(context),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                context,
                'UPGRADE',
                Icons.upgrade,
                primaryColor,
                () => _showUpgradeOptions(context),
              ),
              _buildActionButton(
                context,
                'EXTEND',
                Icons.calendar_today,
                primaryColor,
                () => _showExtendOptions(context),
              ),
              _buildActionButton(
                context,
                'CANCEL',
                Icons.cancel_outlined,
                Colors.red.shade300,
                () => _showCancelConfirmation(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanLabel(BuildContext context, String planName) {
    Color planColor;
    switch (planName) {
      case 'Premium':
        planColor = Colors.purpleAccent;
        break;
      case 'Pro':
        planColor = Colors.blueAccent;
        break;
      default:
        planColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: planColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: planColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        planName.toUpperCase(),
        style: TextStyle(
          color: planColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionRow(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final expiryDate = subscriptionData['expiryDate'] ?? 'Unknown';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Renewal',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subscriptionData['autoRenew'] ? 'Automatic' : 'Manual',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expires',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              expiryDate,
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeOptions(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    final plans = [
      {
        'name': 'Pro',
        'price': '\$19.99',
        'features': ['All predictions', 'Advanced analytics', 'Early access'],
      },
      {
        'name': 'Premium',
        'price': '\$39.99',
        'features': ['Custom systems', 'Priority support', 'Unlimited data', 'API access'],
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'UPGRADE PLAN',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: plans.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  if (plan['name'] == subscriptionData['currentPlan']) {
                    return const SizedBox.shrink(); // Skip current plan
                  }
                  return ListTile(
                    title: Text(
                      '${plan['name']} Plan - ${plan['price']}/month',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      (plan['features'] as List).join(' • '),
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<ProfileBloc>().add(
                              UpdateSubscriptionEvent(plan['name'] as String),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black, // Text color for visibility
                      ),
                      child: const Text(
                        'SELECT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
void _showExtendOptions(BuildContext context) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  
  // Get screen dimensions to ensure dialog fits properly
  final screenHeight = MediaQuery.of(context).size.height;
  final bottomPadding = MediaQuery.of(context).padding.bottom;
  
  // Calculate maximum height for the dialog
  final maxHeight = screenHeight * 0.7;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    isScrollControlled: true, // This allows the sheet to be sized based on content
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottomPadding, // Account for bottom safe area
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take minimum height needed
        children: [
          // Handle for the bottom sheet
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Text(
            'EXTEND SUBSCRIPTION',
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Make this part scrollable
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildExtendOption(
                    context,
                    duration: '3 Months',
                    discount: '10% discount',
                    price: '\$53.97',
                    originalPrice: '\$59.97',
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildExtendOption(
                    context,
                    duration: '6 Months',
                    discount: '15% discount',
                    price: '\$101.94',
                    originalPrice: '\$119.94',
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildExtendOption(
                    context,
                    duration: '12 Months',
                    discount: '20% discount',
                    price: '\$191.90',
                    originalPrice: '\$239.88',
                    recommended: true,
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper method to build each extension option
Widget _buildExtendOption(
  BuildContext context, {
  required String duration,
  required String discount,
  required String price,
  required String originalPrice,
  required Color primaryColor,
  bool recommended = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: recommended 
            ? primaryColor 
            : primaryColor.withOpacity(0.3),
        width: recommended ? 2 : 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (recommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'BEST VALUE',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                discount,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                originalPrice,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle subscription extension
                  final bloc = context.read<ProfileBloc>();
                  // For now, just update the expiry date
                  final currentPlan = bloc.subscriptionData!['currentPlan'];
                  bloc.add(UpdateSubscriptionEvent(currentPlan));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'SELECT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
  void _showCancelConfirmation(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Cancel Subscription',
          style: TextStyle(color: Colors.red.shade300),
        ),
        content: const Text(
          'Are you sure you want to cancel your subscription? You will lose access to premium features when your current subscription period ends.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'NO, KEEP IT',
              style: TextStyle(color: primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileBloc>().add(CancelSubscriptionEvent());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red.shade300,
            ),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );
  }
}