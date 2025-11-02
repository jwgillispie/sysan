import 'package:cloud_firestore/cloud_firestore.dart';

/// System purchase record
class SystemPurchase {
  final String id;
  final String buyerId;
  final String creatorId;
  final String systemId;
  final String systemName;
  final double price;
  final double platformFee;
  final double totalAmount;
  final String status; // pending_payment, completed, refunded
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? refundedAt;

  SystemPurchase({
    required this.id,
    required this.buyerId,
    required this.creatorId,
    required this.systemId,
    required this.systemName,
    required this.price,
    required this.platformFee,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.paidAt,
    this.refundedAt,
  });

  factory SystemPurchase.fromJson(Map<String, dynamic> json, String docId) {
    return SystemPurchase(
      id: docId,
      buyerId: json['buyer_id'] ?? json['buyerId'] ?? '',
      creatorId: json['creator_id'] ?? json['creatorId'] ?? '',
      systemId: json['system_id'] ?? json['systemId'] ?? '',
      systemName: json['system_name'] ?? json['systemName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      platformFee: (json['platform_fee'] ?? json['platformFee'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending_payment',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'])
          : (json['paidAt'] as Timestamp?)?.toDate(),
      refundedAt: json['refunded_at'] != null
          ? DateTime.parse(json['refunded_at'])
          : (json['refundedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts to JSON for FastAPI (snake_case)
  Map<String, dynamic> toJson() {
    return {
      'buyer_id': buyerId,
      'creator_id': creatorId,
      'system_id': systemId,
      'system_name': systemName,
      'price': price,
      'platform_fee': platformFee,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'refunded_at': refundedAt?.toIso8601String(),
    };
  }

  /// Converts to JSON for Firebase (camelCase, Timestamp)
  Map<String, dynamic> toFirebaseJson() {
    return {
      'buyerId': buyerId,
      'creatorId': creatorId,
      'systemId': systemId,
      'systemName': systemName,
      'price': price,
      'platformFee': platformFee,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'refundedAt': refundedAt != null ? Timestamp.fromDate(refundedAt!) : null,
    };
  }

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending_payment';
  bool get isRefunded => status == 'refunded';

  bool get canRefund {
    if (!isCompleted || paidAt == null) return false;
    final hoursSincePurchase = DateTime.now().difference(paidAt!).inHours;
    return hoursSincePurchase <= 24;
  }
}
