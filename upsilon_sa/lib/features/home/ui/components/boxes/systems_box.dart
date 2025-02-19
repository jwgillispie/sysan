// Path: lib/features/home/ui/components/boxes/systems_box.dart
import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/boxes/cyber_box.dart';

class SystemsBox extends CyberBox {
  final List<String> systemItems;
  final List<double> systemValues;

  const SystemsBox({
    Key? key,
    required this.systemItems,
    required this.systemValues,
    required double width,
    required double height,
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) : super(
          key: key,
          width: width,
          height: height,
          title: title,
          icon: icon,
          onTap: onTap,
        );

  @override
  Widget buildContent(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView.builder(
      itemCount: systemItems.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final value = systemValues[index];
        final valueColor = value > 90 ? Colors.green : primaryColor;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: valueColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: valueColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      systemItems[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: valueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: valueColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(valueColor.withOpacity(0.3)),
                  minHeight: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
