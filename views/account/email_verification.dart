import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/email_verification/email_verification_bloc.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
  static String name = 'EmailVerification';

  static Widget providedInstance() {
    return BlocProvider<EmailVerificationBloc>(
      create: (context) => EmailVerificationBloc()..add(EmailVerificationGet()),
      child: EmailVerification(),
    );
  }
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationSendSuccess ||
              state is EmailVerificationSendFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((state is EmailVerificationSendSuccess)
                    ? state.message
                    : (state as EmailVerificationSendFailure).message),
              ),
            ));
          }
        },
        builder: (context, state) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: AppColor.primaryColor,
                ),
                title: Text('Verification status'),
                subtitle: (state is EmailVerificationStatus)
                    ? Text.rich(
                        TextSpan(text: 'Email is Verified '),
                        style: TextStyle(color: Colors.green),
                      )
                    : Text.rich(
                        TextSpan(text: 'Email is not Verified'),
                        style: TextStyle(color: Colors.pink),
                      ),
                trailing: (state is EmailVerificationStatus)
                    ? Icon(
                        Icons.verified_user,
                        color: Colors.green,
                      )
                    : Icon(Icons.highlight_off, color: Colors.pink),
              ),
            ),
            Visibility(
              visible: (state is! EmailVerificationStatus),
              child: Align(
                alignment: Alignment.bottomRight,
                child: BusyButton(
                  busy: state is EmailVerificationSending,
                  margin: EdgeInsets.all(20),
                  buttonColour: AppStyle.optionalSecondaryButton,
                  title: "VERIFY",
                  textStyle: TextStyle(fontSize: 20, letterSpacing: 2),
                  width: 150,
                  onPressed: () => context
                      .bloc<EmailVerificationBloc>()
                      .add(EmailVerificationStart()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
