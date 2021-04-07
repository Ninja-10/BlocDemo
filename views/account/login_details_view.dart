import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/services/navigation_service.dart';
import 'package:parrotspellingapp/views/account/update_email.dart';
import 'package:parrotspellingapp/views/account/update_password.dart';

import 'email_verification.dart';

class LoginDetailsView extends StatelessWidget {
  static String name = 'LoginDetailsView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Login Details'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: SvgPicture.asset(
                'images/email.svg',
                height: 30,
                width: 30,
              ),
              title: Text('Update Email Address'),
              subtitle: Text('Update user email address'),
              trailing: Icon(Icons.navigate_next),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onTap: () {
                locator<NavigationService>().goAndComeBack(
                    UpdateEmailView.providedInstance(), UpdateEmailView.name);
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'images/verification.svg',
                height: 30,
                width: 30,
              ),
              title: Text('Email Verification'),
              subtitle: Text(
                  'Verify login email to receive account recovery information'),
              trailing: Icon(Icons.navigate_next),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onTap: () {
                locator<NavigationService>().goAndComeBack(
                    EmailVerification.providedInstance(),
                    EmailVerification.name);
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'images/lock.svg',
                height: 30,
                width: 30,
              ),
              title: Text('Update Password'),
              subtitle: Text('Update user password'),
              trailing: Icon(Icons.navigate_next),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              onTap: () {
                locator<NavigationService>()
                    .goAndComeBack(UpdatePasswordView.providedInstance(),UpdatePasswordView.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
