// lib/core/widgets/hot_props_widget.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/boxes/cyber_box.dart';

class HotProp {
  final String name;
  final double confidence;
  final String odds;

  const HotProp({
    required this.name,
    required this.confidence,
    required this.odds,
  });
}

class HotPropsBox extends CyberBox {
  final List<HotProp> props;

  const HotPropsBox({
    super.key,
    required super.width,
    required super.height,
    required this.props,
  }) : super(
          title: 'HOT PROPS',
          icon: Icons.local_fire_department,
          accentColor: Colors.redAccent,
        );

  @override
  Widget buildContent(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: props.length,
      itemBuilder: (context, index) {
        return HotPropCard(prop: props[index]);
      },
    );
  }
}

class HotPropCard extends StatefulWidget {
  final HotProp prop;

  const HotPropCard({
    super.key,
    required this.prop,
  });

  @override
  State<HotPropCard> createState() => _HotPropCardState();
}

class _HotPropCardState extends State<HotPropCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getHeatColor() {
    if (widget.prop.confidence >= 85) {
      return Colors.red;
    } else if (widget.prop.confidence >= 70) {
      return Colors.orange;
    }
    return Colors.yellow;
  }

  double _getAnimationSpeed() {
    if (widget.prop.confidence >= 85) return 1.0;
    if (widget.prop.confidence >= 70) return 0.7;
    return 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final heatColor = _getHeatColor();
    _controller.duration =
        Duration(milliseconds: (1500 * _getAnimationSpeed()).toInt());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: heatColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: heatColor.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.prop.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Icon(
                      Icons.local_fire_department,
                      color: heatColor,
                      size: 24,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Confidence',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${widget.prop.confidence.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: heatColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Odds',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.prop.odds,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: widget.prop.confidence / 100,
              backgroundColor: Colors.grey[900],
              valueColor: AlwaysStoppedAnimation<Color>(heatColor),
              minHeight: 2,
            ),
          ),
        ],
      ),
    );
  }
}
