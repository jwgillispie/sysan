// Path: lib/core/widgets/boxes/cyber_box.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/containers/animated_border_container.dart';

abstract class CyberBox extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? accentColor;

  const CyberBox({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.icon,
    this.onTap,
    this.accentColor,
  });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final primaryColor = accentColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBorderContainer(
        width: width,
        height: height,
        borderColor: primaryColor,
        borderWidth: 1,
        borderRadius: 8,
        duration: const Duration(seconds: 4),
        lightSize: 2,
        lightColor: primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final primaryColor = accentColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
