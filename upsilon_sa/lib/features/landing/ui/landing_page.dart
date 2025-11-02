import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSuccess = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

// Update the _submitForm method to use this formatter
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await FirebaseFirestore.instance.collection('waitlist').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _formatPhoneForStorage(
              _phoneController.text), // Format before storing
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
        });

        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting form: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 1000;

    return Scaffold(
      body: Stack(
        children: [
          // Background with simple cyber grid
          Positioned.fill(
            child: CustomPaint(
              painter: CyberGridPainter(
                color: const Color(0xFF09BF30).withValues(alpha: 0.05),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF09BF30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF09BF30).withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "SYSTEMS ANALYTICS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Mission statement
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: const Text(
                    'Our mission is to make every sports bettor feel like a professional.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Hero section with signup form prominently displayed at the top
                isWideScreen
                    ? _buildWideScreenHeroSection()
                    : _buildNarrowScreenHeroSection(),

                const SizedBox(height: 60),

                // Core values
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      const Text(
                        'OUR VALUES',
                        style: TextStyle(
                          color: Color(0xFF09BF30),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildValueCard(
                            icon: Icons.bar_chart,
                            title: 'Low Barrier to High-End Tools',
                            description:
                                'Access advanced analytical tools with no coding required',
                          ),
                          _buildValueCard(
                            icon: Icons.person,
                            title: 'Make Everyone Feel Like a Pro',
                            description:
                                'Analyze games and track your bets like the professionals do',
                          ),
                          _buildValueCard(
                            icon: Icons.trending_up,
                            title: 'Make Money Smarter',
                            description:
                                'Use data-driven decisions for more confident betting',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Customer testimonial
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: Color(0xFF09BF30),
                        size: 40,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '"Systems allowed me to avoid reading articles and analyzing what other people said by allowing me to run an analysis on what I think is important for determining what will happen in a game. Being able to use data to analyze games and track my bets makes me feel like I\'m putting my money into stocks when I\'m sports betting!"',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '— Systems User',
                        style: TextStyle(
                          color: Color(0xFF09BF30),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Feature highlights
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      const Text(
                        'KEY FEATURES',
                        style: TextStyle(
                          color: Color(0xFF09BF30),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildFeatureRow(
                        title: 'Click and Choose Factors',
                        description:
                            'Easily select your preferred factors for analyzing and predicting sports outcomes without any prior coding knowledge.',
                        icon: Icons.touch_app,
                        isReversed: false,
                      ),
                      const SizedBox(height: 40),
                      _buildFeatureRow(
                        title: 'Low Barrier to Entry',
                        description:
                            'Systems reduces the barrier to entry of conventional betting research through its low user cost and ease of use.',
                        icon: Icons.accessibility_new,
                        isReversed: true,
                      ),
                      const SizedBox(height: 40),
                      _buildFeatureRow(
                        title: 'Feel Like a Pro',
                        description:
                            'Our tools give you the confidence to make data-driven betting decisions just like professional analysts.',
                        icon: Icons.psychology,
                        isReversed: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  color: Colors.black,
                  child: Column(
                    children: [
                      Text(
                        '© 2025 SYSTEMS ANALYTICS. ALL RIGHTS RESERVED.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sports betting should be approached responsibly.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Add this helper function to your _LandingPageState class
  String _formatPhoneForStorage(String input) {
    // Remove all non-digit characters
    final digitsOnly = input.replaceAll(RegExp(r'[^\d]'), '');

    // If we have a 10-digit number, format it as +1XXXXXXXXXX
    if (digitsOnly.length == 10) {
      return '+1$digitsOnly';
    }

    // Return the digits as-is
    return digitsOnly;
  }

  // Two-column layout for wide screens
  Widget _buildWideScreenHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column with promotional content
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF09BF30).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SIGN UP TODAY',
                    style: TextStyle(
                      color: Color(0xFF09BF30),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Use the market to your advantage',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildFeaturePoint('No coding required'),
                      const SizedBox(width: 20),
                      _buildFeaturePoint('Easy to use'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildFeaturePoint('Data-driven decisions'),
                      const SizedBox(width: 20),
                      _buildFeaturePoint('Affordable'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 30),

          // Right column with signup form
          Expanded(
            flex: 4,
            child: _buildSignupForm(isWeb: true),
          ),
        ],
      ),
    );
  }

  // Single column layout for narrow screens
  Widget _buildNarrowScreenHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Signup form on top for mobile
          _buildSignupForm(isWeb: false),

          const SizedBox(height: 30),

          // Promotional content below
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF09BF30).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'GET STARTED TODAY',
                  style: TextStyle(
                    color: Color(0xFF09BF30),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Join thousands of sports bettors already using Systems Analytics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFeaturePoint('No coding required'),
                    _buildFeaturePoint('Easy to use'),
                    _buildFeaturePoint('Data-driven decisions'),
                    _buildFeaturePoint('Affordable'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePoint(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF09BF30),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm({required bool isWeb}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF09BF30),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF09BF30).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(30),
      // Add constraints based on platform
      constraints: BoxConstraints(
        maxWidth: isWeb ? 500 : double.infinity,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSuccess)
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Thanks for joining! We\'ll notify you when we launch.',
                        style: TextStyle(color: Colors.green.shade300),
                      ),
                    ),
                  ],
                ),
              ),

            const Center(
              child: Text(
                'JOIN THE WAITLIST',
                style: TextStyle(
                  color: Color(0xFF09BF30),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name field
            const Text(
              'FULL NAME',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF09BF30),
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Color(0xFF09BF30),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Email field
            const Text(
              'EMAIL ADDRESS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF09BF30),
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Color(0xFF09BF30),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Phone Number field - New addition
            const Text(
              'PHONE NUMBER',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '(123) 456-7890',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF09BF30).withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF09BF30),
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.phone,
                  color: Color(0xFF09BF30),
                ),
                helperText: 'Format: (123) 456-7890',
                helperStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              // Format the phone number as the user types
              onChanged: (value) {
                // Skip formatting if deleting text
                if (value.length < _phoneController.text.length) return;

                // Remove all non-digit characters
                final digits = value.replaceAll(RegExp(r'[^\d]'), '');

                // Format the number as (XXX) XXX-XXXX
                if (digits.length <= 3) {
                  _phoneController.value = TextEditingValue(
                    text: digits,
                    selection: TextSelection.collapsed(offset: digits.length),
                  );
                } else if (digits.length <= 6) {
                  _phoneController.value = TextEditingValue(
                    text: '(${digits.substring(0, 3)}) ${digits.substring(3)}',
                    selection:
                        TextSelection.collapsed(offset: digits.length + 3),
                  );
                } else if (digits.length <= 10) {
                  _phoneController.value = TextEditingValue(
                    text:
                        '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}',
                    selection:
                        TextSelection.collapsed(offset: digits.length + 4),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }

                // Check if the number has the right number of digits
                final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

                if (digitsOnly.length < 10) {
                  return 'Please enter a complete phone number';
                }

                if (digitsOnly.length > 10) {
                  return 'Please enter a 10-digit US phone number';
                }

                return null;
              },
            ),
            const SizedBox(height: 30),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09BF30),
                  foregroundColor: Colors.black,
                  disabledBackgroundColor:
                      const Color(0xFF09BF30).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'GET EARLY ACCESS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF09BF30).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF09BF30).withValues(alpha: 0.1),
              border: Border.all(
                color: const Color(0xFF09BF30).withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF09BF30),
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required String title,
    required String description,
    required IconData icon,
    required bool isReversed,
  }) {
    Widget iconSection = Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF09BF30).withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: const Color(0xFF09BF30),
          size: 70,
        ),
      ),
    );

    Widget textSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );

    // For smaller screens, we'll use a column layout
    if (MediaQuery.of(context).size.width < 800) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconSection,
          const SizedBox(height: 20),
          textSection,
        ],
      );
    }

    // For larger screens, use row layout with direction based on isReversed
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isReversed
          ? [
              Expanded(flex: 5, child: textSection),
              const SizedBox(width: 30),
              Expanded(flex: 4, child: iconSection),
            ]
          : [
              Expanded(flex: 4, child: iconSection),
              const SizedBox(width: 30),
              Expanded(flex: 5, child: textSection),
            ],
    );
  }
}

class CyberGridPainter extends CustomPainter {
  final Color color;
  final double gridSpacing;
  final double lineWidth;

  CyberGridPainter({
    required this.color,
    this.gridSpacing = 25,
    this.lineWidth = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CyberGridPainter oldDelegate) =>
      color != oldDelegate.color ||
      gridSpacing != oldDelegate.gridSpacing ||
      lineWidth != oldDelegate.lineWidth;
}
