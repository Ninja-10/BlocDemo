import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:parrotspellingapp/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

import 'my_app.dart';

void main() async {
  //Todo: refactor to architecture
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  setupLocator();
  consoleLog(isDebugMode());
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ConnectivityBloc>(
        create: (BuildContext context) =>
            ConnectivityBloc()..add(ConnectivityLoad())),
    BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc()),
    BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) =>
          AuthenticationBloc(context.bloc<UserBloc>())
            ..add(AuthenticationStarted()),
    ),
  ], child: MyApp()));
}
