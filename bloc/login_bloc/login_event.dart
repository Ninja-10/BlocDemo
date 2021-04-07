part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginSubmit extends LoginEvent {
  final String email;
  final String password;

  LoginSubmit(this.email, this.password);
}
