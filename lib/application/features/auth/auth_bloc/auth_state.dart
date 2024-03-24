part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState{}

class Authenticated extends AuthState{

 final User ?user;
  Authenticated(this.user);
}


class UnAuthenticated extends AuthState{}


class AuthenticatedError extends AuthState{


  final String message;

  AuthenticatedError({required this.message});

}

