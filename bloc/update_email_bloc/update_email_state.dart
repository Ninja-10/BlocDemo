part of 'update_email_bloc.dart';

@immutable
abstract class UpdateEmailState {}

class UpdateEmailInitial extends UpdateEmailState {}

class UpdateEmailSubmitting extends UpdateEmailState {}

class UpdateEmailValidation extends UpdateEmailState {
  final String emailError;
  final String passwordError;

  UpdateEmailValidation(this.emailError, this.passwordError);
}

class UpdateEmailSuccess extends UpdateEmailState {
  final String email;
  final String successMessage;

  UpdateEmailSuccess(this.successMessage, {this.email});
}

class UpdateEmailFailure extends UpdateEmailState {
  final String errorMessage;

  UpdateEmailFailure(this.errorMessage);
}
