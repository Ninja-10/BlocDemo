part of 'email_verification_bloc.dart';

@immutable
abstract class EmailVerificationEvent {}

class EmailVerificationGet extends EmailVerificationEvent {}

class EmailVerificationStart extends EmailVerificationEvent {}
