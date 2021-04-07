part of 'signup_bloc.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpSubmitting extends SignUpState {}

class SignUpValidation extends SignUpState {
  final String emailError;
  final String passwordError;
  final String conformPasswordError;

  SignUpValidation(
      this.emailError, this.passwordError, this.conformPasswordError);
}

class SignUpSuccess extends SignUpState {
  final String message;

  SignUpSuccess(this.message);
}

class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure(this.message);
}
