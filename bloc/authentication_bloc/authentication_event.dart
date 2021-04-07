part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

class AuthenticationStarted extends AuthenticationEvent {}


class AuthenticationLoggedOut extends AuthenticationEvent {}
