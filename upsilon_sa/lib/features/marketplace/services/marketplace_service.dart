import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:upsilon_sa/features/marketplace/models/marketplace_system.dart';
import 'package:upsilon_sa/features/marketplace/models/system_purchase.dart';

class MarketplaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========== BROWSE SYSTEMS ==========

  /// Get all active marketplace systems
  Future<List<MarketplaceSystem>> getAllSystems({
    String? sport,
    String? sortBy = 'popular', // popular, newest, price_low, price_high, roi
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection('marketplace_systems')
          .where('isActive', isEqualTo: true);

      // Filter by sport
      if (sport != null && sport.isNotEmpty) {
        query = query.where('sport', isEqualTo: sport);
      }

      // Sort
      switch (sortBy) {
        case 'popular':
          query = query.orderBy('totalPurchases', descending: true);
          break;
        case 'newest':
          query = query.orderBy('createdAt', descending: true);
          break;
        case 'price_low':
          query = query.orderBy('price', descending: false);
          break;
        case 'price_high':
          query = query.orderBy('price', descending: true);
          break;
        case 'roi':
          query = query.orderBy('stats.roi', descending: true);
          break;
        default:
          query = query.orderBy('totalPurchases', descending: true);
      }

      query = query.limit(limit);

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => MarketplaceSystem.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error fetching systems: $e');
      return [];
    }
  }

  /// Search systems by name
  Future<List<MarketplaceSystem>> searchSystems(String searchTerm) async {
    try {
      if (searchTerm.isEmpty) return [];

      final snapshot = await _firestore
          .collection('marketplace_systems')
          .where('isActive', isEqualTo: true)
          .get();

      // Filter by search term (case-insensitive)
      final searchLower = searchTerm.toLowerCase();
      return snapshot.docs
          .map((doc) => MarketplaceSystem.fromJson(
                doc.data(),
                doc.id,
              ))
          .where((system) =>
              system.name.toLowerCase().contains(searchLower) ||
              system.description.toLowerCase().contains(searchLower) ||
              system.tags.any((tag) => tag.toLowerCase().contains(searchLower)))
          .toList();
    } catch (e) {
      print('Error searching systems: $e');
      return [];
    }
  }

  /// Get a single system by ID
  Future<MarketplaceSystem?> getSystemById(String systemId) async {
    try {
      final doc = await _firestore
          .collection('marketplace_systems')
          .doc(systemId)
          .get();

      if (!doc.exists) return null;

      return MarketplaceSystem.fromJson(doc.data()!, doc.id);
    } catch (e) {
      print('Error fetching system: $e');
      return null;
    }
  }

  // ========== CREATOR OPERATIONS ==========

  /// List a system for sale
  Future<String?> listSystem({
    required String systemId,
    required String systemName,
    required String description,
    required double price,
    required String sport,
    List<String> tags = const [],
    SystemStats? stats,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final userName = _auth.currentUser?.displayName ?? 'Unknown';

      final docRef = await _firestore.collection('marketplace_systems').add({
        'creatorId': userId,
        'creatorName': userName,
        'systemId': systemId,
        'name': systemName,
        'description': description,
        'price': price,
        'sport': sport,
        'tags': tags,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'stats': stats?.toJson(),
        'totalPurchases': 0,
        'averageRating': 0.0,
        'totalReviews': 0,
      });

      return docRef.id;
    } catch (e) {
      print('Error listing system: $e');
      return null;
    }
  }

  /// Update a system listing
  Future<bool> updateListing({
    required String listingId,
    String? description,
    double? price,
    List<String>? tags,
    bool? isActive,
    SystemStats? stats,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (description != null) updateData['description'] = description;
      if (price != null) updateData['price'] = price;
      if (tags != null) updateData['tags'] = tags;
      if (isActive != null) updateData['isActive'] = isActive;
      if (stats != null) updateData['stats'] = stats.toJson();

      await _firestore
          .collection('marketplace_systems')
          .doc(listingId)
          .update(updateData);

      return true;
    } catch (e) {
      print('Error updating listing: $e');
      return false;
    }
  }

  /// Get creator's listings
  Future<List<MarketplaceSystem>> getMyListings() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('marketplace_systems')
          .where('creatorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MarketplaceSystem.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching my listings: $e');
      return [];
    }
  }

  /// Delete a listing (soft delete)
  Future<bool> deleteListing(String listingId) async {
    try {
      await _firestore
          .collection('marketplace_systems')
          .doc(listingId)
          .update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error deleting listing: $e');
      return false;
    }
  }

  // ========== PURCHASE OPERATIONS ==========

  /// Get user's purchased systems
  Future<List<SystemPurchase>> getMyPurchases() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('system_purchases')
          .where('buyerId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .orderBy('paidAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SystemPurchase.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching purchases: $e');
      return [];
    }
  }

  /// Check if user has purchased a system
  Future<bool> hasPurchasedSystem(String systemId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final snapshot = await _firestore
          .collection('system_purchases')
          .where('buyerId', isEqualTo: userId)
          .where('systemId', isEqualTo: systemId)
          .where('status', isEqualTo: 'completed')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking purchase: $e');
      return false;
    }
  }

  /// Check if user has access to system (purchased or owns it)
  Future<bool> hasAccessToSystem(String systemId, String creatorId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      // User owns the system
      if (userId == creatorId) return true;

      // User purchased the system
      return await hasPurchasedSystem(systemId);
    } catch (e) {
      print('Error checking access: $e');
      return false;
    }
  }

  /// Get creator's sales
  Future<List<SystemPurchase>> getMySales() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('system_purchases')
          .where('creatorId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .orderBy('paidAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SystemPurchase.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching sales: $e');
      return [];
    }
  }

  /// Get creator's total earnings
  Future<double> getTotalEarnings() async {
    try {
      final sales = await getMySales();
      return sales.fold<double>(0.0, (total, purchase) => total + purchase.price);
    } catch (e) {
      print('Error calculating earnings: $e');
      return 0.0;
    }
  }
}
