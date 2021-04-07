part of 'password_reset_bloc.dart';

abstract class PasswordResetState {
  String message;
}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetValidation extends PasswordResetState {
  final String emailError;

  PasswordResetValidation(this.emailError);
}

class PasswordResetSubmitting extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {
  final String message;

  PasswordResetSuccess(this.message);
}

class PasswordResetFailure extends PasswordResetState {
  final String message;

  PasswordResetFailure(this.message);
}
