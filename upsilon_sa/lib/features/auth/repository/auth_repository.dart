import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/auth_failure.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? AppUser.fromFirebaseUser(firebaseUser) : null;
    });
  }

  AppUser? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser != null ? AppUser.fromFirebaseUser(firebaseUser) : null;
  }

  Future<AppUser> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const UnknownFailure();
      }

      if (displayName != null) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      return AppUser.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const UnknownFailure();
      }

      return AppUser.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  Future<void> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  AuthFailure _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'user-disabled':
        return const UserDisabledFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return const UnknownFailure();
    }
  }
}