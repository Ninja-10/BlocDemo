import 'dart:async';

import 'package:android_in_app_update/android_in_app_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parrotspellingapp/bloc/enrolled_courses_bloc/enrolled_courses_bloc.dart';
import 'package:parrotspellingapp/bloc/explore_courses_bloc/explore_courses_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';
import 'package:parrotspellingapp/services/crashlytics_service.dart';
import 'package:parrotspellingapp/services/firebase_messaging.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/views/account/account_view.dart';
import 'package:parrotspellingapp/views/classroom/my_classroom_view.dart';
import 'package:parrotspellingapp/views/home/home_view.dart';
import 'package:parrotspellingapp/views/home/profile_setup_dialog.dart';
import 'package:parrotspellingapp/weidgets/shaired/screen_util.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();

  static Widget providedInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExploreCoursesBloc>(
          create: (BuildContext context) => ExploreCoursesBloc(),
        ),
        BlocProvider<EnrolledCoursesBloc>(
          create: (BuildContext context) =>
              EnrolledCoursesBloc(context.bloc<UserBloc>()),
        ),
      ],
      child: MainView(),
    );
  }
}

class _MainViewState extends State<MainView> {
  List<Widget> _widgetOptions = [HomeView(), MyClassroomView(), AccountView()];

  int _selectedIndex = 0;
  List<String> screenNames = ['Explore', 'MyLibrary', 'Account'];
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      locator<AnalyticsService>().setCurrentScreen(name: screenNames[index]);
    });
  }

  @override
  void initState() {
    super.initState();
    locator<FirebaseMessagingService>()..initialize();
    Future.delayed(Duration.zero, () => ProfileSetupDialog.show(context));
    locator<AnalyticsService>().setCurrentScreen(name: screenNames[0]);
    checkForAppUpdate();
  }

  void popupSnackbarForCompleteUpdate() async {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('An update has just been downloaded.'),
      duration: Duration(days: 1),
      action: SnackBarAction(
          label: 'RESTART',
          onPressed: () async {
            await AndroidInAppUpdate.installFlexibleUpdate();
          }),
    ));
  }

  void checkForAppUpdate() async {
    try {
      UpdateStatus status = await AndroidInAppUpdate.updateStatus;
      print('status: $status');
      if (status == UpdateStatus.DOWNLOADED) {
        popupSnackbarForCompleteUpdate();
      } else if (status == UpdateStatus.AVAILABLE) {
        UpdateResult result = await AndroidInAppUpdate.startFlexibleUpdate();
        if (result == UpdateResult.OK) {
          popupSnackbarForCompleteUpdate();
        }
      }
    } catch (e, s) {
      locator<CrashlyticsService>().recordError(e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil(context);
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          _onItemTapped(0);
          return false;
        } else
          return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.primaryColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:
                  SvgPicture.asset('images/search.svg', width: 30, height: 30),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('images/chalk.svg', width: 30, height: 30),
              label: 'My Library',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('images/businessman.svg',
                  width: 30, height: 30),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.deepPurpleAccent.shade100,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
