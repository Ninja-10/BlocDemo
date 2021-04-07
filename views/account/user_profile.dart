import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/app_button.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/number_input_card.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/outlined_input_card.dart';

class UserProfileView extends StatefulWidget {
  static String name = 'UserProfileView';

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with TickerProviderStateMixin {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _standardController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _placeController = TextEditingController();

  TabController _tabController;

  @override
  void initState() {
    UserSuccess state = context.bloc<UserBloc>().state;
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: state.user.gender ?? 0);
    if (state is UserSuccess) {
      _nameController.text = state.user.name;
      _ageController.text = state.user.age.toString();
      _standardController.text = state.user.standard;
      _schoolController.text = state.user.school;
      _placeController.text = state.user.place;
      print('===================${state.user.age}');
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _standardController.dispose();
    _schoolController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) {
          if (state is UserSuccess) {
            _nameController.text = state.user.name;
            _ageController.text = state.user.age.toString();
            _standardController.text = state.user.standard;
            _schoolController.text = state.user.school;
            _placeController.text = state.user.place;
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state.message),
              ),
            ));
          } else if (state is UserFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state.message),
              ),
            ));
          }
        }, builder: (context, state) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tabs: List.generate(
                      3,
                      (index) => Container(
                        height: 100,
                        child: SvgPicture.asset(
                          UserBloc.avatars[index],
                          height: 80,
                          width: 80,
                        ),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: OutLinedInputCard(
                  hintText: 'Name',
                  helperText: 'Input Your name',
                  controller: _nameController,
                  error: (state is UserValidation) ? state.nameError : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: NumberInputCard(
                  controller: _ageController,
                  hintText: 'Age',
                  helperText: 'Input your age',
                  error: (state is UserValidation) ? state.ageError : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: OutLinedInputCard(
                  hintText: 'Standard',
                  controller: _standardController,
                  helperText: 'input what class you are in',
                  error: (state is UserValidation) ? state.standardError : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: OutLinedInputCard(
                  hintText: 'School',
                  controller: _schoolController,
                  helperText: 'Input your school name',
                  error: (state is UserValidation) ? state.schoolError : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: OutLinedInputCard(
                  hintText: 'Place',
                  controller: _placeController,
                  helperText: 'Input your city, state & country',
                  error: (state is UserValidation) ? state.placeError : null,
                ),
              ),
              BusyButton(
                margin: EdgeInsets.fromLTRB(16, 30, 16, 50),
                busy: (state is UserSubmitting),
                buttonColour: AppStyle.optionalPrimaryButton,
                onPressed: () {
                  context.bloc<UserBloc>().add(UserUpdate(
                      name: _nameController.text,
                      gender: _tabController.index,
                      age: int.parse(_ageController.text),
                      standard: _standardController.text,
                      school: _schoolController.text,
                      place: _placeController.text));
                },
                title: 'UPDATE',
              ),
            ],
          );
        }))));
  }
}
