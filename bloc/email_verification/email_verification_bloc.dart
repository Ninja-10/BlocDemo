import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/locator.dart';

part 'email_verification_event.dart';

part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  EmailVerificationBloc() : super(EmailVerificationInitial());

  @override
  Stream<EmailVerificationState> mapEventToState(
    EmailVerificationEvent event,
  ) async* {
    if (event is EmailVerificationGet) {
      yield* emailVerificationReadToState();
    } else if (event is EmailVerificationStart) {
      yield* emailVerificationStartToState();
    }
  }

  Stream<EmailVerificationState> emailVerificationReadToState() async* {
    bool value = await _firebaseAuthService.isEmailVerified();
    if (value) yield EmailVerificationStatus();
  }

  Stream<EmailVerificationState> emailVerificationStartToState() async* {
    yield EmailVerificationSending();
    try {
      await _firebaseAuthService.sendEmailVerification();
      await _analyticsService.logVerifyEmail();
      yield EmailVerificationSendSuccess(
          'Email verification link send to your email successfully');
    } catch (e) {
      print(e.toString());
      yield EmailVerificationSendFailure(
          'Could not send verification link check internet connection');
    }
  }
}
