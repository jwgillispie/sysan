import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import '../../../main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // No specific listener actions needed
      },
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          // Show loading while checking auth state
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          // User is authenticated, show main app
          return const SA();
        } else {
          // User is not authenticated, show login page
          return const LoginPage();
        }
      },
    );
  }
}