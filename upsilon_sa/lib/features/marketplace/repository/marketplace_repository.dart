import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:upsilon_sa/features/marketplace/models/marketplace_system.dart';
import 'package:upsilon_sa/features/marketplace/models/system_purchase.dart';

/// Repository for marketplace operations via FastAPI backend
class MarketplaceRepository {
  final String baseUrl = 'http://localhost:8000';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========== AUTH HELPERS ==========

  /// Get Firebase ID token for authenticated requests
  Future<String?> _getAuthToken() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      log('Error getting auth token: $e');
      return null;
    }
  }

  /// Get headers with authentication
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ========== BROWSE SYSTEMS ==========

  /// Get all active marketplace systems with filters
  Future<List<MarketplaceSystem>> getAllSystems({
    String? sport,
    String? sortBy = 'popular',
    int limit = 20,
  }) async {
    try {
      log('Fetching marketplace systems from $baseUrl/marketplace/systems');

      final queryParams = <String, String>{
        if (sport != null && sport.isNotEmpty) 'sport': sport,
        if (sortBy != null) 'sort_by': sortBy,
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/marketplace/systems')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('Successfully fetched ${data.length} marketplace systems');

        return data
            .map((json) => MarketplaceSystem.fromJson(json, json['id'] ?? ''))
            .toList();
      } else {
        log('Error fetching systems: ${response.statusCode}');
        throw Exception('Failed to fetch systems: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching systems: $e');
      rethrow;
    }
  }

  /// Search systems by query term
  Future<List<MarketplaceSystem>> searchSystems(String query) async {
    try {
      log('Searching systems with query: $query');

      final uri = Uri.parse('$baseUrl/marketplace/systems/search')
          .replace(queryParameters: {'q': query});

      final response = await http.get(uri, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => MarketplaceSystem.fromJson(json, json['id'] ?? ''))
            .toList();
      } else {
        throw Exception('Failed to search systems: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while searching systems: $e');
      rethrow;
    }
  }

  /// Get a single system by ID
  Future<MarketplaceSystem?> getSystemById(String systemId) async {
    try {
      log('Fetching system by ID: $systemId');

      final response = await http.get(
        Uri.parse('$baseUrl/marketplace/systems/$systemId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return MarketplaceSystem.fromJson(json, json['id'] ?? systemId);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch system: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching system: $e');
      rethrow;
    }
  }

  // ========== CREATOR OPERATIONS ==========

  /// Create a new system listing
  Future<String?> createListing({
    required String systemId,
    required String systemName,
    required String description,
    required double price,
    required String sport,
    List<String> tags = const [],
    SystemStats? stats,
  }) async {
    try {
      log('Creating system listing: $systemName');

      final body = {
        'system_id': systemId,
        'name': systemName,
        'description': description,
        'price': price,
        'sport': sport,
        'tags': tags,
        'is_active': true,
        if (stats != null) 'stats': stats.toJson(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/marketplace/systems'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        log('Successfully created listing: ${json['id']}');
        return json['id'];
      } else {
        throw Exception('Failed to create listing: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while creating listing: $e');
      rethrow;
    }
  }

  /// Update an existing system listing
  Future<bool> updateListing({
    required String listingId,
    String? description,
    double? price,
    List<String>? tags,
    bool? isActive,
    SystemStats? stats,
  }) async {
    try {
      log('Updating listing: $listingId');

      final body = <String, dynamic>{};
      if (description != null) body['description'] = description;
      if (price != null) body['price'] = price;
      if (tags != null) body['tags'] = tags;
      if (isActive != null) body['is_active'] = isActive;
      if (stats != null) body['stats'] = stats.toJson();

      final response = await http.put(
        Uri.parse('$baseUrl/marketplace/systems/$listingId'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        log('Successfully updated listing');
        return true;
      } else {
        throw Exception('Failed to update listing: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while updating listing: $e');
      return false;
    }
  }

  /// Get creator's listings
  Future<List<MarketplaceSystem>> getMyListings() async {
    try {
      log('Fetching my listings');

      final response = await http.get(
        Uri.parse('$baseUrl/marketplace/my-listings'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('Successfully fetched ${data.length} listings');
        return data
            .map((json) => MarketplaceSystem.fromJson(json, json['id'] ?? ''))
            .toList();
      } else {
        throw Exception('Failed to fetch listings: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching listings: $e');
      rethrow;
    }
  }

  /// Delete a listing (soft delete)
  Future<bool> deleteListing(String listingId) async {
    try {
      log('Deleting listing: $listingId');

      final response = await http.delete(
        Uri.parse('$baseUrl/marketplace/systems/$listingId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        log('Successfully deleted listing');
        return true;
      } else {
        throw Exception('Failed to delete listing: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while deleting listing: $e');
      return false;
    }
  }

  // ========== PURCHASE OPERATIONS ==========

  /// Get user's purchased systems
  Future<List<SystemPurchase>> getMyPurchases() async {
    try {
      log('Fetching my purchases');

      final response = await http.get(
        Uri.parse('$baseUrl/marketplace/purchases'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('Successfully fetched ${data.length} purchases');
        return data
            .map((json) => SystemPurchase.fromJson(json, json['id'] ?? ''))
            .toList();
      } else {
        throw Exception('Failed to fetch purchases: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching purchases: $e');
      rethrow;
    }
  }

  /// Check if user has purchased a system
  Future<bool> hasPurchasedSystem(String systemId) async {
    try {
      log('Checking if system is purchased: $systemId');

      final response = await http.get(
        Uri.parse('$baseUrl/marketplace/systems/$systemId/purchased'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['purchased'] == true;
      } else {
        return false;
      }
    } catch (e) {
      log('Exception while checking purchase: $e');
      return false;
    }
  }

  /// Create payment intent for system purchase
  Future<Map<String, dynamic>> createPaymentIntent({
    required String systemId,
    required String systemName,
    required String creatorId,
    required double price,
  }) async {
    try {
      log('Creating payment intent for system: $systemName');

      final body = {
        'system_id': systemId,
        'system_name': systemName,
        'creator_id': creatorId,
        'price': price,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/marketplace/purchase/create-intent'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log('Successfully created payment intent');
        return json;
      } else {
        throw Exception('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while creating payment intent: $e');
      rethrow;
    }
  }

  /// Get creator's sales
  Future<List<SystemPurchase>> getMySales() async {
    try {
      log('Fetching my sales');

      final response = await http.get(
        Uri.parse('$baseUrl/marketplace/sales'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('Successfully fetched ${data.length} sales');
        return data
            .map((json) => SystemPurchase.fromJson(json, json['id'] ?? ''))
            .toList();
      } else {
        throw Exception('Failed to fetch sales: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching sales: $e');
      rethrow;
    }
  }

  /// Get creator's total earnings
  Future<double> getTotalEarnings() async {
    try {
      log('Fetching total earnings');

      final response = await http.get(
        Uri.parse('$baseUrl/marketplace/earnings'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final earnings = (json['total_earnings'] ?? 0).toDouble();
        log('Total earnings: \$${earnings.toStringAsFixed(2)}');
        return earnings;
      } else {
        throw Exception('Failed to fetch earnings: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching earnings: $e');
      return 0.0;
    }
  }

  // ========== STRIPE CONNECT OPERATIONS ==========

  /// Create Stripe Connect account for creator
  Future<Map<String, dynamic>> createStripeConnectAccount({
    required String email,
    String businessType = 'individual',
  }) async {
    try {
      log('Creating Stripe Connect account for: $email');

      final body = {
        'email': email,
        'business_type': businessType,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/stripe/connect/create-account'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log('Successfully created Stripe Connect account');
        return json;
      } else {
        throw Exception('Failed to create Stripe account: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while creating Stripe account: $e');
      rethrow;
    }
  }

  /// Check Stripe Connect account status
  Future<Map<String, dynamic>> checkStripeAccountStatus() async {
    try {
      log('Checking Stripe account status');

      final response = await http.get(
        Uri.parse('$baseUrl/stripe/connect/status'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        log('Successfully fetched Stripe status');
        return json;
      } else {
        throw Exception('Failed to check status: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while checking Stripe status: $e');
      rethrow;
    }
  }

  /// Disconnect Stripe Connect account
  Future<bool> disconnectStripeAccount() async {
    try {
      log('Disconnecting Stripe account');

      final response = await http.delete(
        Uri.parse('$baseUrl/stripe/connect/disconnect'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        log('Successfully disconnected Stripe account');
        return true;
      } else {
        throw Exception('Failed to disconnect: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while disconnecting Stripe: $e');
      return false;
    }
  }
}
