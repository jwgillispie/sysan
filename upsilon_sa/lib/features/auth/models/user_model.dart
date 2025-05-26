import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInTime;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.createdAt,
    this.lastSignInTime,
  });

  factory AppUser.fromFirebaseUser(dynamic firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.metadata?.creationTime,
      lastSignInTime: firebaseUser.metadata?.lastSignInTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      emailVerified: map['emailVerified'] ?? false,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      lastSignInTime: map['lastSignInTime'] != null ? DateTime.parse(map['lastSignInTime']) : null,
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastSignInTime,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        emailVerified,
        createdAt,
        lastSignInTime,
      ];
}