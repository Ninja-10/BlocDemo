import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/connectivity_service.dart';
import 'package:parrotspellingapp/services/crashlytics_service.dart';
import 'package:parrotspellingapp/services/firebase_messaging.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/firestore_service.dart';
import 'package:parrotspellingapp/services/google_tts_service.dart';
import 'package:parrotspellingapp/services/navigation_service.dart';
import 'package:parrotspellingapp/utils/managers/app_form_validator.dart';
import 'package:parrotspellingapp/utils/managers/preference_manager.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CrashlyticsService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => AppFormValidator());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FireStoreService());
  locator.registerLazySingleton(() => FirebaseMessagingService());
  locator.registerLazySingleton(() => PreferenceManager());
  locator.registerLazySingleton(() => GoogleTtsService());
}
