import 'dart:async';
import 'package:bloc/bloc.dart';
import '../repository/auth_repository.dart';
import '../models/user_model.dart';
import '../models/auth_failure.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AppUser?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);

    _userSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthUserUpdated(user));
    });
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      if (e is AuthFailure) {
        emit(AuthError(e));
      } else {
        emit(const AuthError(UnknownFailure()));
      }
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      if (e is AuthFailure) {
        emit(AuthError(e));
      } else {
        emit(const AuthError(UnknownFailure()));
      }
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      if (e is AuthFailure) {
        emit(AuthError(e));
      } else {
        emit(const AuthError(UnknownFailure()));
      }
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordResetSent(event.email));
    } catch (e) {
      if (e is AuthFailure) {
        emit(AuthError(e));
      } else {
        emit(const AuthError(UnknownFailure()));
      }
    }
  }

  Future<void> _onAuthEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendEmailVerification();
      emit(AuthEmailVerificationSent());
    } catch (e) {
      if (e is AuthFailure) {
        emit(AuthError(e));
      } else {
        emit(const AuthError(UnknownFailure()));
      }
    }
  }

  void _onAuthUserUpdated(AuthUserUpdated event, Emitter<AuthState> emit) {
    if (event.firebaseUser != null) {
      final user = AppUser.fromFirebaseUser(event.firebaseUser);
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}