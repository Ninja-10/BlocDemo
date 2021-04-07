part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSubmitting extends LoginState {}

class LoginValidation extends LoginState {
  final String emailError;
  final String passwordError;

  LoginValidation(this.emailError, this.passwordError);
  
}

class LoginSuccess extends LoginState {
  final String message;

  LoginSuccess(this.message);
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
