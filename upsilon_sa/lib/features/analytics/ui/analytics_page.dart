// lib/features/analytics/ui/analytics_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/analytics/bloc/analytics_bloc.dart';
import 'package:upsilon_sa/features/analytics/ui/systems_creation_page.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);
  
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    // Simply return the system creation page
    return const SystemCreationPage();
  }
}