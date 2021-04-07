import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/enrolled_courses_bloc/enrolled_courses_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/weidgets/classroom/classroom_child.dart';
import 'package:parrotspellingapp/weidgets/classroom/classroom_empty.dart';
import 'package:parrotspellingapp/weidgets/classroom/classroom_loading.dart';

class MyClassroomView extends StatefulWidget {
  @override
  _MyClassroomViewState createState() => _MyClassroomViewState();

  static Widget providedInstance() {
    return BlocProvider<EnrolledCoursesBloc>(
      create: (BuildContext context) =>
          EnrolledCoursesBloc(context.bloc<UserBloc>()),
      child: MyClassroomView(),
    );
  }
}

class _MyClassroomViewState extends State<MyClassroomView> {
  @override
  void initState() {
    context.bloc<EnrolledCoursesBloc>()..requestMoreData(0);
    super.initState();
  }

  Widget switchChild(EnrolledCoursesState state) {
    if (state is EnrolledCoursesSuccess) {
      return ClassroomChild();
    } else if (state is EnrolledCoursesEmpty) {
      return EmptyClassroom();
    }
    return ClassroomLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            title: Text(
              'PARROT',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 24, letterSpacing: 5),
            ),
          )),
      body: SafeArea(
          child: BlocBuilder<EnrolledCoursesBloc, EnrolledCoursesState>(
        buildWhen: (previousState, state) {
          // Note: Only build when the state changes from loading to success or empty.
          return (previousState.runtimeType != state.runtimeType);
        },
        builder: (context, state) => AnimatedSwitcher(
            child: switchChild(state), duration: Duration(milliseconds: 800)),
      )),
    );
  }
}
