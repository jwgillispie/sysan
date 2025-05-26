import 'package:equatable/equatable.dart';

abstract class AuthFailure extends Equatable {
  final String message;
  
  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends AuthFailure {
  const ServerFailure(super.message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('This email is already registered.');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('Please enter a valid email address.');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Password is too weak. Please use at least 6 characters.');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('Wrong password provided.');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('No user found with this email.');
}

class UserDisabledFailure extends AuthFailure {
  const UserDisabledFailure() : super('This user account has been disabled.');
}

class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure() : super('Too many attempts. Please try again later.');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure() : super('Network error. Please check your connection.');
}

class UnknownFailure extends AuthFailure {
  const UnknownFailure() : super('An unexpected error occurred. Please try again.');
}