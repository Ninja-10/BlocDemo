import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parrotspellingapp/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/services/navigation_service.dart';
import 'package:parrotspellingapp/utils/account_backaground_painter.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/utils/squircle.dart';
import 'package:parrotspellingapp/views/account/email_verification.dart';
import 'package:parrotspellingapp/views/account/login_details_view.dart';
import 'package:parrotspellingapp/views/account/user_profile.dart';
import 'package:parrotspellingapp/weidgets/account/rank_card.dart';
import 'package:parrotspellingapp/weidgets/account/score_card.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/app_button.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();

  static String name = 'AccountView';
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    var accountItemTitle = TextStyle(
        fontSize: 16,
        color: AppColor.primaryColor,
        fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.all(0.0),
              child: CustomPaint(
                painter: BackgroundPainter(),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserSuccess)
                        consoleLog(
                            'new_state: ${(state as UserSuccess).user.score}');
                      return Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Material(
                            elevation: 10,
                            color: Colors.greenAccent,
                            shape: SquircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(UserBloc.avatars[
                                  (state is UserSuccess)
                                      ? state.user.gender
                                      : 0]),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (state is UserSuccess) ? state.user.name : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (state is UserSuccess) ? state.user.place : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Wrap(
                                children: [
                                  RankCard(
                                    rank: (state is UserSuccess)
                                        ? state.user.standard
                                        : '',
                                  ),
                                  ScoreCard(
                                    score: (state is UserSuccess)
                                        ? state.user.score
                                        : 0,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ]);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              child: Text(
                'Account Settings',
                style: accountItemTitle,
              ),
              padding: EdgeInsets.only(left: 16, top: 20),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'images/shield.svg',
                width: 30,
                height: 30,
              ),
              title: Text('Login & Security'),
              subtitle: Text('Update email and password'),
              trailing: Icon(Icons.navigate_next),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onTap: () {
                locator<NavigationService>()
                    .goAndComeBack(LoginDetailsView(), EmailVerification.name);
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'images/graduation.svg',
                width: 30,
                height: 30,
              ),
              title: Text('Update Learners details'),
              subtitle: Text('Add or edit learner info'),
              trailing: Icon(Icons.navigate_next),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onTap: () {
                locator<NavigationService>().goAndComeBack(UserProfileView(),UserProfileView.name);
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: AppButton(
                buttonColour: AppStyle.optionalSecondaryButton,
                title: "LOG OUT",
                textStyle: TextStyle(fontSize: 16, letterSpacing: 0),
                width: 150,
                margin: EdgeInsets.all(20),
                onPressed: () => context
                    .bloc<AuthenticationBloc>()
                    .add(AuthenticationLoggedOut()),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
