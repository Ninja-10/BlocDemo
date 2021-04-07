import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/services/navigation_service.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/views/authentication/login_view.dart';
import 'package:parrotspellingapp/views/main/main_view.dart';
import 'package:parrotspellingapp/views/main/startup_view.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

import 'bloc/authentication_bloc/authentication_bloc.dart';
import 'bloc/connectivity_bloc/connectivity_bloc.dart';
import 'connection_error_dialog.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: AppColor.primaryColor,
////        systemNavigationBarColor: AppColor.primaryColor
//    )); //Hexcolor('#3700B3')
    return MaterialApp(
        title: 'Parrot',
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigationKey,
        navigatorObservers: [
          locator<AnalyticsService>().getAnalyticsObserver(),
        ],
        theme: ThemeData(
          primaryColor: AppColor.primaryColor,
          primaryColorDark: AppColor.primaryColorDark,
          accentColor: AppColor.accentColor,
          fontFamily: 'BalooThambi2',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, connectionState) {
            if (!connectionState.connected) {
              ConnectionErrorDialog.show(context);
            } else {
              ConnectionErrorDialog.hide(context);
            }
            consoleLog('connectivity : ${connectionState.connected}');
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            consoleLog('Authentication: $state');
            if (state is AuthenticationInitial) {
              return StartupView();
            } else if (state is AuthenticationSuccess) {
              return MainView.providedInstance();
            } else {
              return LoginView.providedInstance();
            }
          }),
        ));
  }
}
