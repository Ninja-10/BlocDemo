import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/managers/app_form_validator.dart';

part 'password_reset_event.dart';

part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AppFormValidator _formValidator = locator<AppFormValidator>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  PasswordResetBloc() : super(PasswordResetInitial());

  @override
  Stream<PasswordResetState> mapEventToState(PasswordResetEvent event) async* {
    if (event is PasswordResetSubmit) {
      yield* _mapPasswordResetSubmitToState(event.email);
    }
  }

  Stream<PasswordResetState> _mapPasswordResetSubmitToState(
      String email) async* {
    AppFormValidatorData data = _formValidator.validateFields(email: email);
    await _analyticsService.logResetPassword();
    if (!data.isValid) {
      yield PasswordResetValidation(data.emailError);
    } else {
      yield PasswordResetSubmitting();
      try {
        await _firebaseAuthService.requestPasswordReset(email);
        yield PasswordResetSuccess(
            'Password reset instruction successfully sent to your email address');
      } on PlatformException catch (e) {
        yield PasswordResetFailure(e.code);
      } catch (e) {
        yield PasswordResetFailure(e.toString());
      }
    }
  }
}
