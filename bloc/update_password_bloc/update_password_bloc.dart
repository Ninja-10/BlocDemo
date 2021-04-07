import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/managers/app_form_validator.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

part 'update_password_event.dart';

part 'update_password_state.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AppFormValidator _formValidator = locator<AppFormValidator>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  UpdatePasswordBloc() : super(UpdatePasswordInitial());

  @override
  Stream<UpdatePasswordState> mapEventToState(
    UpdatePasswordEvent event,
  ) async* {
    if (event is UpdatePasswordGet) {
      yield* loginDetailsGetToState();
    } else if (event is UpdatePasswordUpdate) {
      yield* _mapLoginDetailsUpdatePasswordToState(
          event.oldPassword, event.newPassword, event.conformNewPassword);
    }
  }

  Stream<UpdatePasswordState> loginDetailsGetToState() async* {
    String email = _firebaseAuthService.getUser().email;
  }

  Stream<UpdatePasswordState> _mapLoginDetailsUpdatePasswordToState(
      String oldPassword,
      String newPassword,
      String conformNewPassword) async* {
    consoleLog(
        'oldPassword $oldPassword, newPassword: $newPassword, conformNewPassword: $conformNewPassword',
        active: false);

    AppFormValidatorData oldPasswordValidatorData =
        _formValidator.validateFields(password: oldPassword);
    AppFormValidatorData newPasswordValidatorData =
        _formValidator.validateFields(
            password: newPassword, conformPassword: conformNewPassword);

    consoleLog(
        'oldPassword_isValid ${oldPasswordValidatorData.isValid}, newPassword_isValid: ${newPasswordValidatorData.isValid}',
        active: false);

    if (!oldPasswordValidatorData.isValid ||
        !newPasswordValidatorData.isValid) {
      yield UpdatePasswordValidation(
          oldPasswordValidatorData.passwordError,
          newPasswordValidatorData.passwordError,
          newPasswordValidatorData.conformPasswordError);
    } else {
      yield UpdatePasswordSubmitting();
      try {
        await _firebaseAuthService.reAuthUser(oldPassword);
        await _firebaseAuthService.updateUserPassword(newPassword);
        await _analyticsService.logUpdatePassword();
        yield UpdatePasswordSuccess('Password changed successfully');
      } on FirebaseAuthException catch (e) {
        yield UpdatePasswordFailure(e.code);
      } catch (e) {
        yield UpdatePasswordFailure('Password changed failed');
      }
    }
  }
}
