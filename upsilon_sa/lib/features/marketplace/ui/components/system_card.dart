import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'package:upsilon_sa/features/marketplace/models/marketplace_system.dart';

class SystemCard extends StatelessWidget {
  final MarketplaceSystem system;
  final VoidCallback onTap;

  const SystemCard({
    super.key,
    required this.system,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? SystemsColors.darkGrey : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Sport badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: SystemsColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      system.sport.toUpperCase(),
                      style: const TextStyle(
                        color: SystemsColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Purchases count
                  if (system.totalPurchases > 0) ...[
                    Icon(
                      Icons.shopping_bag,
                      size: 14,
                      color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${system.totalPurchases}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Price
                  Text(
                    '\$${system.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SystemsColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // System name
              Text(
                system.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? SystemsColors.white : SystemsColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Creator name
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'by ${system.creatorName}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                system.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? SystemsColors.smokyGrey : Colors.black87,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Stats row (if available)
              if (system.stats != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? SystemsColors.smokyGrey.withValues(alpha: 0.3)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildStatItem(
                        'ROI',
                        '${system.stats!.roi.toStringAsFixed(1)}%',
                        SystemsColors.primary,
                        isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildStatItem(
                        'Win Rate',
                        '${system.stats!.winRate.toStringAsFixed(1)}%',
                        SystemsColors.secondary,
                        isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildStatItem(
                        'Bets',
                        '${system.stats!.totalBets}',
                        isDark ? SystemsColors.white : SystemsColors.black,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ],

              // Tags
              if (system.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: system.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? SystemsColors.white : SystemsColors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? SystemsColors.smokyGrey : Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
