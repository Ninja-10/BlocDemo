import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:parrotspellingapp/bloc/signup_bloc/signup_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';
import 'package:parrotspellingapp/weidgets/shaired/app_logo.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/filled_input_card.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();

  static String name = 'SignUpView';

  static Widget providedInstance() {
    return BlocProvider<SignUpBloc>(
      create: (BuildContext context) => SignUpBloc(context.bloc<UserBloc>()),
      child: SignUpView(),
    );
  }
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _conformPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _conformPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              consoleLog('signUp: $state');
              context.bloc<AuthenticationBloc>().add(AuthenticationStarted());
              Navigator.pop(context);
            } else if (state is SignUpFailure)
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.message),
                ),
              ));
          },
          builder: (context, state) =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AppLogo(),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 50, 18, 16),
              child: FilledInputCard(
                enabled: !(state is SignUpSubmitting),
                error: (state is SignUpValidation) ? state.emailError : null,
                controller: _emailController,
                hintText: 'Email',
                helperText: 'Enter email',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 4, 18, 16),
              child: FilledInputCard(
                isPassword: true,
                enabled: !(state is SignUpSubmitting),
                error: (state is SignUpValidation) ? state.passwordError : null,
                controller: _passwordController,
                hintText: 'Password',
                helperText: 'Enter password',
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(18, 4, 18, 16),
                child: FilledInputCard(
                  isPassword: true,
                  enabled: !(state is SignUpSubmitting),
                  error: (state is SignUpValidation)
                      ? state.conformPasswordError
                      : null,
                  controller: _conformPasswordController,
                  hintText: 'Conform Password',
                  helperText: 'Conform password',
                )),
            BusyButton(
              busy: state is SignUpSubmitting,
              buttonColour: AppStyle.secondaryButton,
              margin: EdgeInsets.fromLTRB(16, 30, 16, 0),
              onPressed: () async {
                context.bloc<SignUpBloc>().add(SignUpSubmit(
                    _emailController.text,
                    _passwordController.text,
                    _conformPasswordController.text));
              },
              title: 'SIGN UP',
            ),
          ]),
        )),
      ),
    );
  }
}
