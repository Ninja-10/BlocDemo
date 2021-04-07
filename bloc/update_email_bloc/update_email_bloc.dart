import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/firestore_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/managers/app_form_validator.dart';

part 'update_email_event.dart';

part 'update_email_state.dart';

class UpdateEmailBloc extends Bloc<UpdateEmailEvent, UpdateEmailState> {
  UpdateEmailBloc() : super(UpdateEmailInitial());

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AppFormValidator _formValidator = locator<AppFormValidator>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  Stream<UpdateEmailState> mapEventToState(
    UpdateEmailEvent event,
  ) async* {
    if (event is UpdateEmailGet) {
      yield* _mapUpdateEmailGetToState();
    } else if (event is UpdateEmailUpdate) {
      yield* _mapUpdateEmailUpdateToState(event.newEmail, event.password);
    }
  }

  Stream<UpdateEmailState> _mapUpdateEmailGetToState() async* {}

  Stream<UpdateEmailState> _mapUpdateEmailUpdateToState(
      String newEmail, String password) async* {
    AppFormValidatorData data =
        _formValidator.validateFields(email: newEmail, password: password);
    if (!data.isValid) {
      yield UpdateEmailValidation(data.emailError, data.passwordError);
    } else {
      yield UpdateEmailSubmitting();
      try {
        await _firebaseAuthService.reAuthUser(password);
        await _firebaseAuthService.updateUserEmail(newEmail);
        await _analyticsService.logUpdateEmail();
        yield UpdateEmailSuccess('Successfully updated login email');
      } on FirebaseAuthException catch (e) {
        yield UpdateEmailFailure(e.code);
      } catch (e) {
        yield UpdateEmailFailure('Failed to update login email');
      }
    }
  }
}
