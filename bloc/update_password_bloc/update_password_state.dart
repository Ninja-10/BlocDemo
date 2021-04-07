part of 'update_password_bloc.dart';

@immutable
abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordSubmitting extends UpdatePasswordState {}

class UpdatePasswordValidation extends UpdatePasswordState {
  final String passwordError;
  final String newPasswordError;
  final String conformNewPasswordError;

  UpdatePasswordValidation(
      this.passwordError, this.newPasswordError, this.conformNewPasswordError);
}

class UpdatePasswordSuccess extends UpdatePasswordState {
  final String successMessage;

  UpdatePasswordSuccess(this.successMessage);
}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String errorMessage;

  UpdatePasswordFailure(this.errorMessage);
}
