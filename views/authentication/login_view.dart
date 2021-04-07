import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:parrotspellingapp/bloc/login_bloc/login_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/services/navigation_service.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/views/authentication/password_resset_view.dart';
import 'package:parrotspellingapp/views/authentication/signup_view.dart';
import 'package:parrotspellingapp/weidgets/shaired/app_logo.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/app_button.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/filled_input_card.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();

  static Widget providedInstance() {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(context.bloc<UserBloc>()),
      child: LoginView(),
    );
  }
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child:
                BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
          if (state is LoginSuccess) {
            context.bloc<AuthenticationBloc>().add(AuthenticationStarted());
          } else if (state is LoginFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state.message),
              ),
            ));
          }
        }, builder: (context, state) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLogo(),
                Padding(
                  padding: EdgeInsets.fromLTRB(18, 50, 18, 16),
                  child: FilledInputCard(
                    controller: _emailController,
                    hintText: 'Email',
                    helperText: 'Enter email',
                    error: (state is LoginValidation) ? state.emailError : null,
                    enabled: !(state is LoginSubmitting),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18, 4, 18, 16),
                  child: FilledInputCard(
                    controller: _passwordController,
                    isPassword: true,
                    hintText: 'Password',
                    helperText: 'Enter password',
                    error:
                        (state is LoginValidation) ? state.passwordError : null,
                    enabled: !(state is LoginSubmitting),
                  ),
                ),
                BusyButton(
                  busy: state is LoginSubmitting,
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  buttonColour: AppStyle.primaryButton,
                  title: 'LOG IN',
                  onPressed: () async {
                    context.bloc<LoginBloc>().add(LoginSubmit(
                        _emailController.text, _passwordController.text));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text('or',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.white)),
                      Flexible(
                        flex: 1,
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  title: 'SIGN UP',
                  buttonColour: AppStyle.secondaryButton,
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  onPressed: () async {
                    locator<NavigationService>().goAndComeBack(
                        SignUpView.providedInstance(), SignUpView.name);
                  },
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: FlatButton(
                    padding: EdgeInsets.all(22),
                    onPressed: () {
                      locator<NavigationService>().goAndComeBack(
                          PasswordResetView.providedInstance(),
                          PasswordResetView.name);
                    },
                    child: Text('Forgot password?',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColor.buttonSecondaryText,
                            fontSize: 18)),
                  ),
                ),
              ]);
        })),
      ),
    );
  }
}
