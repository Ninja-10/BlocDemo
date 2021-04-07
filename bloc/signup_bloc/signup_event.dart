part of 'signup_bloc.dart';

abstract class SignUpEvent {}

class SignUpSubmit extends SignUpEvent {
  final String email;
  final String password;
  final String conformPassword;

  SignUpSubmit(this.email, this.password, this.conformPassword);
}
