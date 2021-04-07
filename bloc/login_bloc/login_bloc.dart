import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/models/sppeech_api.dart';
import 'package:parrotspellingapp/models/user_model.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/crashlytics_service.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/firestore_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/managers/app_form_validator.dart';
import 'package:parrotspellingapp/utils/managers/preference_manager.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AppFormValidator _formValidator = locator<AppFormValidator>();
  PreferenceManager _preferenceManger = locator<PreferenceManager>();
  FireStoreService _fireStoreService = locator<FireStoreService>();
  CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  UserBloc _userBloc;

  LoginBloc(this._userBloc) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmit) {
      yield* _mapLoginSubmitToState(event.email, event.password);
    }
  }

  Stream<LoginState> _mapLoginSubmitToState(
      String email, String password) async* {
    AppFormValidatorData data =
        _formValidator.validateFields(email: email, password: password);
    print(data.isValid);
    if (!data.isValid) {
      yield LoginValidation(data.emailError, data.passwordError);
    } else {
      try {
        yield LoginSubmitting();
        await _firebaseAuthService.logIn(email, password);

        SpeechApi speechApi = await _fireStoreService.getGoogleApiKey();
        await _preferenceManger.saveSpeechApiKey(speechApi.apiKey);
        // log(speechApi.apiKey);

        await _userBloc.loginUser();
        await _analyticsService.logLogIn();

        yield LoginSuccess('Logged in successfully');
      } on FirebaseAuthException catch (e, s) {
        //TODO: simplify errors
        consoleLog('platform exception: ${e.code}');
        await _crashlyticsService.recordError(e, s,
            reason: "Login platform exception");
        yield LoginFailure(e.code);
      } catch (e, s) {
        await _crashlyticsService.recordError(e, s, reason: "Login exception");
        yield LoginFailure(e.toString());
        consoleLog('exception :${e.toString()}');
      }
    }
  }
}
