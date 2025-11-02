import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';

enum PageIndicator { systemsCreation, betsPage }

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
      pageIndicator: PageIndicator.systemsCreation,
    ),
    TutorialStep(
      title: "Name Your System",
      description: "Give your system a descriptive name that reflects its strategy.",
      icon: Icons.edit,
      pageIndicator: PageIndicator.systemsCreation,
    ),
    TutorialStep(
      title: "Select Sport",
      description: "Choose which sport this system will analyze (NBA, NFL, MLB, NHL).",
      icon: Icons.sports_basketball,
      pageIndicator: PageIndicator.systemsCreation,
    ),
    TutorialStep(
      title: "Add Factors",
      description: "Select statistical factors that your system will evaluate. These determine what data points matter for your predictions.",
      icon: Icons.analytics,
      pageIndicator: PageIndicator.systemsCreation,
    ),
    TutorialStep(
      title: "Configure Thresholds",
      description: "Set minimum and maximum values for each factor to define when a bet meets your criteria.",
      icon: Icons.tune,
      pageIndicator: PageIndicator.systemsCreation,
    ),
    TutorialStep(
      title: "Finish System",
      description: "Complete your system creation by clicking 'FINISH' to save your configuration.",
      icon: Icons.check_circle,
      pageIndicator: PageIndicator.systemsCreation,
    ),
    TutorialStep(
      title: "Test on Bets Page",
      description: "Navigate to the Bets page to see your system in action. Your system will automatically filter bets that match your criteria.",
      icon: Icons.sports,
      pageIndicator: PageIndicator.betsPage,
    ),
    TutorialStep(
      title: "Review Results",
      description: "On the Bets page, you'll see highlighted bets that match your system's criteria, with detailed statistics and odds.",
      icon: Icons.assessment,
      pageIndicator: PageIndicator.betsPage,
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

  Color _getPageColor(PageIndicator pageIndicator) {
    switch (pageIndicator) {
      case PageIndicator.systemsCreation:
        return SystemsColors.primary; // Primary theme color for systems creation
      case PageIndicator.betsPage:
        return Colors.blue; // Blue for bets page (matching TEST ON BETS button)
    }
  }

  String _getPageName(PageIndicator pageIndicator) {
    switch (pageIndicator) {
      case PageIndicator.systemsCreation:
        return "SYSTEMS CREATION";
      case PageIndicator.betsPage:
        return "BETS PAGE";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_currentStep];
    final pageColor = _getPageColor(currentStep.pageIndicator);
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.black.withValues(alpha: 0.8),
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: pageColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: pageColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator badge
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: pageColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: pageColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: pageColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPageName(currentStep.pageIndicator),
                          style: TextStyle(
                            color: pageColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: pageColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          currentStep.icon,
                          color: pageColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          currentStep.title,
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
                    currentStep.description,
                    style: const TextStyle(
                      color: SystemsColors.smokyGrey,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Progress indicator with color coding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                      (index) {
                        final stepPageColor = _getPageColor(_steps[index].pageIndicator);
                        final isActive = index == _currentStep;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 12 : 8,
                          height: isActive ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? stepPageColor
                                : stepPageColor.withValues(alpha: 0.3),
                            border: isActive ? Border.all(
                              color: stepPageColor,
                              width: 2,
                            ) : null,
                          ),
                        );
                      },
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
                                color: SystemsColors.smokyGrey.withValues(alpha: 0.5),
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
                            backgroundColor: pageColor,
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
  final PageIndicator pageIndicator;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.pageIndicator,
  });
}