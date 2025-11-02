import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'package:upsilon_sa/features/marketplace/models/marketplace_system.dart';
import 'package:upsilon_sa/features/marketplace/repository/marketplace_repository.dart';

/// Page for creators to manage their system listings
class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  final MarketplaceRepository _repository = MarketplaceRepository();
  List<MarketplaceSystem> _listings = [];
  bool _isLoading = true;
  double _totalEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    _loadListings();
    _loadEarnings();
  }

  Future<void> _loadListings() async {
    setState(() => _isLoading = true);

    final listings = await _repository.getMyListings();

    setState(() {
      _listings = listings;
      _isLoading = false;
    });
  }

  Future<void> _loadEarnings() async {
    final earnings = await _repository.getTotalEarnings();
    setState(() => _totalEarnings = earnings);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? SystemsColors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDark ? SystemsColors.black : Colors.white,
        title: Text(
          'My Listings',
          style: TextStyle(
            color: isDark ? SystemsColors.white : SystemsColors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? SystemsColors.white : SystemsColors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateListingDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Earnings card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SystemsColors.primary, SystemsColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Earnings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_totalEarnings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 48,
                ),
              ],
            ),
          ),

          // Listings
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _listings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.store_outlined,
                              size: 64,
                              color: isDark ? SystemsColors.smokyGrey : Colors.black26,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No listings yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your first system listing',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? SystemsColors.smokyGrey : Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _showCreateListingDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Create Listing'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SystemsColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadListings,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _listings.length,
                          itemBuilder: (context, index) {
                            return _buildListingCard(_listings[index], isDark);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(MarketplaceSystem listing, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? SystemsColors.darkGrey : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: listing.isActive
              ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!)
              : SystemsColors.red.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  listing.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? SystemsColors.white : SystemsColors.black,
                  ),
                ),
              ),
              Text(
                '\$${listing.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SystemsColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              _buildStatChip(
                '${listing.totalPurchases} sales',
                Icons.shopping_bag,
                isDark,
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                listing.sport,
                Icons.sports,
                isDark,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: listing.isActive
                      ? SystemsColors.primary.withValues(alpha: 0.1)
                      : SystemsColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  listing.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: listing.isActive ? SystemsColors.primary : SystemsColors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toggleListingStatus(listing),
                  icon: Icon(
                    listing.isActive ? Icons.visibility_off : Icons.visibility,
                    size: 16,
                  ),
                  label: Text(listing.isActive ? 'Deactivate' : 'Activate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? SystemsColors.white : SystemsColors.black,
                    side: BorderSide(
                      color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.grey[400]!,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editListing(listing),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SystemsColors.primary,
                    side: const BorderSide(color: SystemsColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? SystemsColors.smokyGrey.withValues(alpha: 0.3) : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? SystemsColors.white : SystemsColors.black,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? SystemsColors.white : SystemsColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleListingStatus(MarketplaceSystem listing) async {
    final success = await _repository.updateListing(
      listingId: listing.id,
      isActive: !listing.isActive,
    );

    if (success) {
      await _loadListings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(listing.isActive ? 'Listing deactivated' : 'Listing activated'),
          ),
        );
      }
    }
  }

  void _editListing(MarketplaceSystem listing) {
    // TODO: Open edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming soon')),
    );
  }

  void _showCreateListingDialog() {
    // TODO: Show create listing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create listing functionality coming soon')),
    );
  }
}
