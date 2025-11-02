import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upsilon_sa/core/config/themes.dart';

/// Stripe Connect Widget for Creator Settings
/// Displays Stripe account connection status and allows management
class StripeConnectWidget extends StatefulWidget {
  const StripeConnectWidget({super.key});

  @override
  State<StripeConnectWidget> createState() => _StripeConnectWidgetState();
}

class _StripeConnectWidgetState extends State<StripeConnectWidget> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Connection state
  bool _isConnected = false;
  bool _isLoading = true;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  String? _errorMessage;

  // Stripe account data
  Map<String, dynamic>? _stripeData;
  bool _fullyVerified = false;
  bool _chargesEnabled = false;
  bool _payoutsEnabled = false;
  bool _detailsSubmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStripeConnectionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Auto-refresh when app returns to foreground (e.g., after Stripe onboarding)
    if (state == AppLifecycleState.resumed) {
      debugPrint('🟣 [Stripe Connect] App resumed, refreshing status...');
      // Check if we have a pending connection or existing connection
      if (_isConnected) {
        // Already connected - refresh to get latest verification status
        _refreshStatus();
      } else if (_isConnecting || _currentUser != null) {
        // User might have just completed onboarding - check for new connection
        _loadStripeConnectionStatus();
      }
    }
  }

  Future<void> _loadStripeConnectionStatus() async {
    if (_currentUser == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not authenticated';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Fetch creator integration data
      final doc = await _firestore
          .collection('creator_integrations')
          .doc(_currentUser!.uid)
          .get();

      if (doc.exists && doc.data()?['stripe'] != null) {
        final stripeInfo = doc.data()!['stripe'] as Map<String, dynamic>;

        setState(() {
          _isConnected = stripeInfo['accountId'] != null;
          _stripeData = stripeInfo;
          _fullyVerified = stripeInfo['status'] == 'active';
          _chargesEnabled = stripeInfo['chargesEnabled'] ?? false;
          _payoutsEnabled = stripeInfo['payoutsEnabled'] ?? false;
          _detailsSubmitted = stripeInfo['detailsSubmitted'] ?? false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isConnected = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading Stripe connection: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load connection status';
      });
    }
  }

  Future<void> _connectStripe() async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      debugPrint('🟣 [Stripe Connect] Starting account creation...');

      // Call Cloud Function to create Connect account
      final callable = _functions.httpsCallable('createStripeConnectAccount');
      final result = await callable.call({
        'email': _currentUser!.email,
        'businessType': 'individual',
      });

      final data = result.data as Map<String, dynamic>;
      final accountLink = data['accountLink'] as String;

      debugPrint('🟣 [Stripe Connect] Launching onboarding URL...');

      // Launch Stripe onboarding
      final launched = await launchUrl(
        Uri.parse(accountLink),
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Could not launch Stripe onboarding');
      }

      // Show connection in progress dialog
      if (mounted) {
        _showConnectionInProgressDialog();
      }

    } catch (e) {
      debugPrint('❌ [Stripe Connect] Error: $e');
      setState(() {
        _errorMessage = 'Failed to start Stripe connection: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  Future<void> _refreshStatus() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🟣 [Stripe Connect] Refreshing account status...');

      final callable = _functions.httpsCallable('checkStripeAccountStatus');
      final result = await callable.call();

      final data = result.data as Map<String, dynamic>;

      if (data['connected'] == true) {
        setState(() {
          _isConnected = true;
          _fullyVerified = data['fullyVerified'] ?? false;
          _chargesEnabled = data['chargesEnabled'] ?? false;
          _payoutsEnabled = data['payoutsEnabled'] ?? false;
          _detailsSubmitted = data['detailsSubmitted'] ?? false;
        });

        // Reload from Firestore to get updated data
        await _loadStripeConnectionStatus();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text('Status updated'),
              ],
            ),
            backgroundColor: SystemsColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }

    } catch (e) {
      debugPrint('❌ [Stripe Connect] Error refreshing status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _disconnectStripe() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dialogIsDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: dialogIsDark ? SystemsColors.darkGrey : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: SystemsColors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Disconnect Stripe?',
                style: TextStyle(
                  color: dialogIsDark ? SystemsColors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'This will disconnect your Stripe account and you won\'t be able to sell systems until you reconnect.',
            style: TextStyle(color: dialogIsDark ? SystemsColors.smokyGrey : Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: dialogIsDark ? SystemsColors.smokyGrey : Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: SystemsColors.red,
              ),
              child: const Text('Disconnect'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isDisconnecting = true;
      _errorMessage = null;
    });

    try {
      final callable = _functions.httpsCallable('disconnectStripeAccount');
      await callable.call();

      setState(() {
        _isConnected = false;
        _stripeData = null;
        _fullyVerified = false;
        _chargesEnabled = false;
        _payoutsEnabled = false;
        _detailsSubmitted = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text('Stripe account disconnected'),
              ],
            ),
            backgroundColor: SystemsColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to disconnect: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isDisconnecting = false;
      });
    }
  }

  void _showConnectionInProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final dialogIsDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: dialogIsDark ? SystemsColors.darkGrey : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF635BFF)), // Stripe purple
              ),
              const SizedBox(height: 24),
              Text(
                'Setting up Stripe Connect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dialogIsDark ? SystemsColors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please complete onboarding in your browser',
                style: TextStyle(
                  color: dialogIsDark ? SystemsColors.smokyGrey : Colors.black54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _loadStripeConnectionStatus(); // Refresh status
              },
              child: const Text('Check Status'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null && !_isConnected) {
      return _buildErrorState();
    }

    return _isConnected ? _buildConnectedState() : _buildDisconnectedState();
  }

  Widget _buildLoadingState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? SystemsColors.darkGrey : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF635BFF).withOpacity(0.5),
              ),
              backgroundColor: isDark ? SystemsColors.smokyGrey : Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Stripe connection...',
              style: TextStyle(
                color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? SystemsColors.darkGrey : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: SystemsColors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: SystemsColors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Connection error',
              style: TextStyle(
                color: SystemsColors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _loadStripeConnectionStatus,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF635BFF),
                side: const BorderSide(color: Color(0xFF635BFF)),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _fullyVerified
        ? SystemsColors.primary
        : _detailsSubmitted
            ? Colors.orange
            : SystemsColors.secondary;

    final statusText = _fullyVerified
        ? 'Fully Verified'
        : _detailsSubmitted
            ? 'Verification Pending'
            : 'Setup Incomplete';

    return Card(
            color: isDark ? SystemsColors.darkGrey : Colors.white,
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: statusColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF635BFF), // Stripe purple stays same
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF635BFF).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.payments,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Stripe Connected',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? SystemsColors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _stripeData?['businessName'] ?? 'Stripe Account',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _showConnectionMenu,
                        icon: Icon(
                          Icons.more_vert,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Status info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? SystemsColors.smokyGrey.withOpacity(0.3) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.verified_user,
                          'Status',
                          statusText,
                          valueColor: statusColor,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.credit_card,
                          'Accept Payments',
                          _chargesEnabled ? 'Enabled' : 'Disabled',
                          valueColor: _chargesEnabled ? SystemsColors.primary : SystemsColors.red,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.account_balance,
                          'Payouts',
                          _payoutsEnabled ? 'Enabled' : 'Disabled',
                          valueColor: _payoutsEnabled ? SystemsColors.primary : SystemsColors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _refreshStatus,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Refresh Status'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF635BFF),
                            side: BorderSide(
                              color: const Color(0xFF635BFF).withOpacity(0.5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isDisconnecting ? null : _disconnectStripe,
                          icon: _isDisconnecting
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      SystemsColors.red,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.link_off, size: 18),
                          label: Text(_isDisconnecting ? 'Disconnecting...' : 'Disconnect'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: SystemsColors.red,
                            side: BorderSide(
                              color: SystemsColors.red.withOpacity(0.5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildDisconnectedState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? SystemsColors.darkGrey : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark ? SystemsColors.smokyGrey.withOpacity(0.3) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.payments_outlined,
                      color: isDark ? SystemsColors.smokyGrey : Colors.black45,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connect Stripe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? SystemsColors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sell systems & get paid',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Benefits
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF635BFF).withOpacity(0.05),
                    const Color(0xFF635BFF).withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF635BFF).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: const Color(0xFF635BFF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Benefits',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF635BFF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('Sell your systems'),
                  _buildBenefitItem('Automatic payouts'),
                  _buildBenefitItem('6% platform fee'),
                  _buildBenefitItem('Secure Stripe processing'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Connect button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isConnecting ? null : _connectStripe,
                icon: _isConnecting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.link),
                label: Text(
                  _isConnecting ? 'Connecting...' : 'Connect Stripe Account',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF), // Stripe purple
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Privacy note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 14,
                  color: isDark ? SystemsColors.smokyGrey : Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  'Secure Stripe Express connection',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? SystemsColors.smokyGrey : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? SystemsColors.smokyGrey : Colors.black45,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? (isDark ? SystemsColors.white : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: SystemsColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? SystemsColors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showConnectionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? SystemsColors.darkGrey : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.refresh, color: Color(0xFF635BFF)),
                title: Text('Refresh Status', style: TextStyle(color: isDark ? SystemsColors.white : Colors.black87)),
                subtitle: Text('Check latest verification status', style: TextStyle(color: isDark ? SystemsColors.smokyGrey : Colors.black54)),
                onTap: () {
                  Navigator.pop(context);
                  _refreshStatus();
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: isDark ? SystemsColors.smokyGrey : Colors.black54),
                title: Text('Help', style: TextStyle(color: isDark ? SystemsColors.white : Colors.black87)),
                subtitle: Text('Learn about Stripe Connect', style: TextStyle(color: isDark ? SystemsColors.smokyGrey : Colors.black54)),
                onTap: () {
                  Navigator.pop(context);
                  _showHelpDialog();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.link_off, color: SystemsColors.red),
                title: const Text(
                  'Disconnect',
                  style: TextStyle(color: SystemsColors.red),
                ),
                subtitle: Text('Remove Stripe connection', style: TextStyle(color: isDark ? SystemsColors.smokyGrey : Colors.black54)),
                onTap: () {
                  Navigator.pop(context);
                  _disconnectStripe();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final dialogIsDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: dialogIsDark ? SystemsColors.darkGrey : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: const Color(0xFF635BFF),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Stripe Connect',
                style: TextStyle(
                  color: dialogIsDark ? SystemsColors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: dialogIsDark ? SystemsColors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect your Stripe account to sell systems. Stripe handles secure payment processing and automatically pays you out to your bank account.',
                  style: TextStyle(
                    color: dialogIsDark ? SystemsColors.smokyGrey : Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Platform Fees',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: dialogIsDark ? SystemsColors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• 6% platform fee (added to customer total)\n'
                  '• Creator receives 100% of system price\n'
                  '• Stripe processing: ~2.9% + \$0.30 (deducted from creator payout)',
                  style: TextStyle(
                    color: dialogIsDark ? SystemsColors.smokyGrey : Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Privacy & Security',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: dialogIsDark ? SystemsColors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stripe Express provides secure, compliant payment processing. Your bank details are safely stored with Stripe, not with us.',
                  style: TextStyle(
                    color: dialogIsDark ? SystemsColors.smokyGrey : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}
