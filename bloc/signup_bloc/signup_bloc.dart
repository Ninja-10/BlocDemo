import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/models/sppeech_api.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/crashlytics_service.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/firestore_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/managers/app_form_validator.dart';
import 'package:parrotspellingapp/utils/managers/preference_manager.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FireStoreService _fireStoreService = locator<FireStoreService>();
  AppFormValidator _formValidator = locator<AppFormValidator>();
  PreferenceManager _preferenceManger = locator<PreferenceManager>();
  CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  UserBloc _userBloc;

  SignUpBloc(this._userBloc) : super(SignUpInitial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpSubmit) {
      yield* _mapSignUpSubmitToState(
          event.email, event.password, event.conformPassword);
    }
  }

  Stream<SignUpState> _mapSignUpSubmitToState(
      String email, String password, String conformPassword) async* {
    AppFormValidatorData data = _formValidator.validateFields(
        email: email, password: password, conformPassword: conformPassword);
    if (!data.isValid) {
      yield SignUpValidation(
          data.emailError, data.passwordError, data.conformPasswordError);
    } else {
      try {
        yield SignUpSubmitting();
        UserCredential result =
            await _firebaseAuthService.signUp(email, password);

        SpeechApi api = await _fireStoreService.getGoogleApiKey();
        await _preferenceManger.saveSpeechApiKey(api.apiKey);
        // log(api.apiKey);

        await _userBloc.registerNewUser(result.user);
        await _analyticsService.logSignUp();

        yield SignUpSuccess('Signed in successfully');
      } on PlatformException catch (e, s) {
        await _crashlyticsService.recordError(e, s,
            reason: "Signup platform exception");
        yield SignUpFailure(e.code);
      } catch (e, s) {
        await _crashlyticsService.recordError(e, s, reason: "Signup exception");
        yield SignUpFailure(e.code);
        print(e.toString());
      }
    }
  }
}
