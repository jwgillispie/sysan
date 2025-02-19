// Path: lib/features/systems/ui/systems_page.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:upsilon_sa/core/widgets/cyber_grid.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/core/config/constants.dart';
import 'package:upsilon_sa/features/systems/ui/components/performance_metrics_section.dart';
import 'package:upsilon_sa/features/systems/ui/components/systems_overview_section.dart';
import 'package:upsilon_sa/features/systems/ui/components/roi_chart_section.dart';

class SystemsPage extends StatefulWidget {
  const SystemsPage({super.key});

  @override
  State<SystemsPage> createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<FlSpot> roiData = [
    const FlSpot(0, 65),
    const FlSpot(1, 72),
    const FlSpot(2, 85),
    const FlSpot(3, 78),
    const FlSpot(4, 92),
    const FlSpot(5, 88),
  ];

  final Map<String, dynamic> metricsData = {
    'winRate': 83.7,
    'roi': 27.4,
    'activeBets': 14,
    'profit': 1842,
    'recentActivity': [
      {
        'title': 'System ALPHA-X Prediction',
        'subtitle': 'Lakers vs Warriors | ML: Lakers -110',
        'time': '2h ago',
        'status': 'WIN'
      },
      {
        'title': 'Neural Beta Analysis',
        'subtitle': 'Chiefs vs Ravens | Over 47.5',
        'time': '3h ago',
        'status': 'PENDING'
      },
      {
        'title': 'Quantum System Alert',
        'subtitle': 'Celtics vs 76ers | Spread: BOS -2.5',
        'time': '4h ago',
        'status': 'WIN'
      }
    ]
  };

  final List<Map<String, dynamic>> systemsData = [
    {'name': 'System ALPHA-X', 'winRate': 99.8},
    {'name': 'Neural Beta', 'winRate': 92.3},
    {'name': 'Quantum System', 'winRate': 88.5},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UIConstants.longAnimationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const CyberGrid(),
          _buildMainContent(),
          _buildFloatingActionButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PulsingDot(),
          const SizedBox(width: 10),
          Text(
            "SYSTEMS",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.analytics_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pushNamed(context, '/datasets'),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SystemsOverviewSection(
              systems: systemsData,
              fadeAnimation: _fadeAnimation,
            ),
            const SizedBox(height: 20),
            PerformanceMetricsSection(metrics: metricsData),
            const SizedBox(height: 20),
            ROIChartSection(roiData: roiData),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GlowingActionButton(
        onPressed: () {
          // Add system creation logic
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('CREATE SYSTEM'),
          ],
        ),
      ),
    );
  }
}