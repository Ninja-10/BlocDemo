part of 'email_verification_bloc.dart';

@immutable
abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationStatus extends EmailVerificationState {}

class EmailVerificationSending extends EmailVerificationState {}

class EmailVerificationSendSuccess extends EmailVerificationState {
  final String message;

  EmailVerificationSendSuccess(this.message);
}

class EmailVerificationSendFailure extends EmailVerificationState {
  final String message;

  EmailVerificationSendFailure(this.message);
}
