import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'package:upsilon_sa/features/marketplace/ui/marketplace_browse_page.dart';

/// Marketplace page for browsing and purchasing systems
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  @override
  Widget build(BuildContext context) {
    return const MarketplaceBrowsePage();
  }
}

// OLD PLACEHOLDER CODE BELOW - KEPT FOR REFERENCE
class _MarketplacePlaceholder extends StatelessWidget {
  const _MarketplacePlaceholder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? SystemsColors.black : Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Systems Shop',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? SystemsColors.white : SystemsColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Buy winning systems from top creators',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search and filters placeholder
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? SystemsColors.darkGrey : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Search systems...',
                        style: TextStyle(
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Coming soon placeholder
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: SystemsColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.store,
                        size: 60,
                        color: SystemsColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Systems Marketplace',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? SystemsColors.white : SystemsColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Coming soon: Buy and sell proven betting systems from top creators',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: isDark ? SystemsColors.darkGrey : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: SystemsColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            Icons.shopping_cart,
                            'Buy winning systems',
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            Icons.sell,
                            'Sell your systems',
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            Icons.verified,
                            'Verified performance',
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            Icons.payments,
                            'Secure payments via Stripe',
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: SystemsColors.primary,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? SystemsColors.white : SystemsColors.black,
          ),
        ),
      ],
    );
  }
}
