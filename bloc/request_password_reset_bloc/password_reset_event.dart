part of 'password_reset_bloc.dart';

abstract class PasswordResetEvent {}

class PasswordResetSubmit extends PasswordResetEvent {
  final String email;

  PasswordResetSubmit(this.email);
}
