import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/request_password_reset_bloc/password_reset_bloc.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/weidgets/shaired/app_logo.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/filled_input_card.dart';

class PasswordResetView extends StatefulWidget {
  @override
  _State createState() => _State();

  static String name = 'PasswordResetView';

  static Widget providedInstance() {
    return BlocProvider<PasswordResetBloc>(
      create: (BuildContext context) => PasswordResetBloc(),
      child: PasswordResetView(),
    );
  }
}

class _State extends State<PasswordResetView> {
  TextEditingController _emailEditingController = TextEditingController();

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
            child: SingleChildScrollView(
                child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
          listener: (context, state) {
            print('=== $state');
            if (state is PasswordResetSuccess ||
                state is PasswordResetFailure) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.message),
                ),
              ));
            }
          },
          builder: (context, state) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLogo(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: FilledInputCard(
                    controller: _emailEditingController,
                    error: (state is PasswordResetValidation)
                        ? state.emailError
                        : null,
                    hintText: 'Email',
                    helperText: 'Enter email',
                    enabled: !(state is PasswordResetSubmitting),
                  ),
                ),
                BusyButton(
                  busy: state is PasswordResetSubmitting,
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  buttonColour: AppStyle.secondaryButton,
                  title: 'SEND',
                  onPressed: () {
                    context
                        .bloc<PasswordResetBloc>()
                        .add(PasswordResetSubmit(_emailEditingController.text));
                  },
                ),
              ]),
        ))));
  }
}
