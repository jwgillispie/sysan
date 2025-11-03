import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';

class FeaturedTile {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  FeaturedTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class FeaturedTilesSection extends StatelessWidget {
  const FeaturedTilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      FeaturedTile(
        title: 'Top ROI This Week',
        subtitle: 'Systems with 85%+ returns',
        icon: Icons.trending_up,
        color: SystemsColors.primary,
        onTap: () {
          // Navigate to filtered results
        },
      ),
      FeaturedTile(
        title: 'Consistent Creators',
        subtitle: 'Trusted system builders',
        icon: Icons.verified,
        color: SystemsColors.secondary,
        onTap: () {
          // Navigate to top creators
        },
      ),
      FeaturedTile(
        title: 'New Arrivals',
        subtitle: 'Fresh systems daily',
        icon: Icons.auto_awesome,
        color: Colors.purple,
        onTap: () {
          // Navigate to newest systems
        },
      ),
      FeaturedTile(
        title: 'Under \$50',
        subtitle: 'Budget-friendly picks',
        icon: Icons.savings,
        color: Colors.orange,
        onTap: () {
          // Navigate to budget systems
        },
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final tile = tiles[index];
          return _buildTile(context, tile);
        },
      ),
    );
  }

  Widget _buildTile(BuildContext context, FeaturedTile tile) {
    return GestureDetector(
      onTap: tile.onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: SystemsColors.darkGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: tile.color,
            width: 1.5,
          ),
          boxShadow: [
            // Outer glow effect
            BoxShadow(
              color: tile.color.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: -2,
            ),
            // Inner shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Subtle gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        tile.color.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: tile.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: tile.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        tile.icon,
                        color: tile.color,
                        size: 24,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tile.title,
                          style: const TextStyle(
                            color: SystemsColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tile.subtitle,
                          style: const TextStyle(
                            color: SystemsColors.smokyGrey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 140,
      decoration: BoxDecoration(
        color: SystemsColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SystemsColors.primary,
          width: 1.5,
        ),
        boxShadow: [
          // Glow effect
          BoxShadow(
            color: SystemsColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: -4,
          ),
          // Depth shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Stack(
          children: [
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      SystemsColors.primary.withValues(alpha: 0.1),
                      SystemsColors.secondary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            // Background pattern
            Positioned(
              right: -50,
              bottom: -30,
              child: Icon(
                Icons.query_stats,
                size: 150,
                color: SystemsColors.primary.withValues(alpha: 0.1),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: SystemsColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: SystemsColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'LIMITED TIME',
                      style: TextStyle(
                        color: SystemsColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Black Friday Sale',
                    style: TextStyle(
                      color: SystemsColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '30% off all premium systems',
                    style: TextStyle(
                      color: SystemsColors.smokyGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: SystemsColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: SystemsColors.primary,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Shop Now →',
                      style: TextStyle(
                        color: SystemsColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}