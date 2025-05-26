import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const TutorialOverlay({super.key, required this.onClose});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: "Welcome to System Creation",
      description: "Create custom betting systems by defining specific criteria and factors.",
      icon: Icons.rocket_launch,
    ),
    TutorialStep(
      title: "Name Your System",
      description: "Give your system a descriptive name that reflects its strategy.",
      icon: Icons.edit,
    ),
    TutorialStep(
      title: "Select Sport",
      description: "Choose which sport this system will analyze (NBA, NFL, MLB, NHL).",
      icon: Icons.sports_basketball,
    ),
    TutorialStep(
      title: "Add Factors",
      description: "Select statistical factors that your system will evaluate. These determine what data points matter for your predictions.",
      icon: Icons.analytics,
    ),
    TutorialStep(
      title: "Configure Thresholds",
      description: "Set minimum and maximum values for each factor to define when a bet meets your criteria.",
      icon: Icons.tune,
    ),
    TutorialStep(
      title: "Finish & Test",
      description: "Complete your system and run backtests to see how it would have performed historically.",
      icon: Icons.check_circle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _close();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _close() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.black.withOpacity(0.8),
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: SystemsColors.primary.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: SystemsColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: SystemsColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _steps[_currentStep].icon,
                          color: SystemsColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _steps[_currentStep].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _close,
                        icon: const Icon(
                          Icons.close,
                          color: SystemsColors.smokyGrey,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Content
                  Text(
                    _steps[_currentStep].description,
                    style: const TextStyle(
                      color: SystemsColors.smokyGrey,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentStep
                              ? SystemsColors.primary
                              : SystemsColors.smokyGrey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: SystemsColors.smokyGrey.withOpacity(0.5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(color: SystemsColors.smokyGrey),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SystemsColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _currentStep == _steps.length - 1 ? 'Get Started' : 'Next',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}