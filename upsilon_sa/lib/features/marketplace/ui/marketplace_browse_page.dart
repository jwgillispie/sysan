import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/themes.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';
import 'package:upsilon_sa/features/marketplace/models/marketplace_system.dart';
import 'package:upsilon_sa/features/marketplace/repository/marketplace_repository.dart';
import 'package:upsilon_sa/features/marketplace/ui/components/system_card.dart';
import 'package:upsilon_sa/features/marketplace/ui/components/featured_tiles.dart';
import 'package:upsilon_sa/features/marketplace/ui/system_detail_sheet.dart';

/// Marketplace browse page with filters and search
class MarketplaceBrowsePage extends StatefulWidget {
  const MarketplaceBrowsePage({super.key});

  @override
  State<MarketplaceBrowsePage> createState() => _MarketplaceBrowsePageState();
}

class _MarketplaceBrowsePageState extends State<MarketplaceBrowsePage> {
  final MarketplaceRepository _repository = MarketplaceRepository();
  final TextEditingController _searchController = TextEditingController();

  List<MarketplaceSystem> _systems = [];
  bool _isLoading = false;
  String? _selectedSport;
  String _sortBy = 'popular';

  final List<String> _sports = ['MLB', 'NBA', 'NFL', 'NHL', 'NCAAB', 'NCAAF'];
  final Map<String, String> _sortOptions = {
    'popular': 'Most Popular',
    'newest': 'Newest',
    'price_low': 'Price: Low to High',
    'price_high': 'Price: High to Low',
    'roi': 'Highest ROI',
  };

  @override
  void initState() {
    super.initState();
    _loadSystems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSystems() async {
    setState(() => _isLoading = true);

    try {
      final systems = await _repository.getAllSystems(
        sport: _selectedSport,
        sortBy: _sortBy,
      );

      setState(() {
        _systems = systems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading systems: $e')),
        );
      }
    }
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      _loadSystems();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final systems = await _repository.searchSystems(query);
      setState(() {
        _systems = systems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showSystemDetail(MarketplaceSystem system) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SystemDetailSheet(system: system),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PulsingDot(),
            const SizedBox(width: 10),
            Text(
              'SHOP',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
                controller: _searchController,
                onChanged: _search,
                style: TextStyle(
                  color: isDark ? SystemsColors.white : SystemsColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Search systems...',
                  hintStyle: TextStyle(
                    color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                  ),
                  filled: true,
                  fillColor: isDark ? SystemsColors.darkGrey : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: SystemsColors.primary),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Featured tiles section
            const FeaturedTilesSection(),

            const SizedBox(height: 16),

            // Promo banner (optional, can be shown conditionally)
            // const PromoBanner(),

            // Filters row
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Sport filter
                  _buildFilterChip(
                    label: _selectedSport ?? 'All Sports',
                    isSelected: _selectedSport != null,
                    onTap: () => _showSportFilter(),
                  ),
                  const SizedBox(width: 8),
                  // Sort filter
                  _buildFilterChip(
                    label: _sortOptions[_sortBy]!,
                    isSelected: true,
                    onTap: () => _showSortFilter(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Systems list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _systems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store,
                                size: 64,
                                color: isDark ? SystemsColors.smokyGrey : Colors.black26,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No systems found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isDark ? SystemsColors.smokyGrey : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your filters',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? SystemsColors.smokyGrey : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadSystems,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _systems.length,
                            itemBuilder: (context, index) {
                              return SystemCard(
                                system: _systems[index],
                                onTap: () => _showSystemDetail(_systems[index]),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? SystemsColors.primary.withValues(alpha: 0.2)
              : (isDark ? SystemsColors.darkGrey : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? SystemsColors.primary
                : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? SystemsColors.primary
                    : (isDark ? SystemsColors.white : SystemsColors.black),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isSelected
                  ? SystemsColors.primary
                  : (isDark ? SystemsColors.white : SystemsColors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _showSportFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? SystemsColors.darkGrey
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Sports'),
                trailing: _selectedSport == null
                    ? const Icon(Icons.check, color: SystemsColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedSport = null);
                  Navigator.pop(context);
                  _loadSystems();
                },
              ),
              ..._sports.map((sport) => ListTile(
                    title: Text(sport),
                    trailing: _selectedSport == sport
                        ? const Icon(Icons.check, color: SystemsColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedSport = sport);
                      Navigator.pop(context);
                      _loadSystems();
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showSortFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? SystemsColors.darkGrey
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _sortOptions.entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                trailing: _sortBy == entry.key
                    ? const Icon(Icons.check, color: SystemsColors.primary)
                    : null,
                onTap: () {
                  setState(() => _sortBy = entry.key);
                  Navigator.pop(context);
                  _loadSystems();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
