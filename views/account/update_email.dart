import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/update_email_bloc/update_email_bloc.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/services/navigation_service.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/views/account/email_verification.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/outlined_input_card.dart';

class UpdateEmailView extends StatefulWidget {
  @override
  _UpdateEmailViewState createState() => _UpdateEmailViewState();

  static String name = 'UpdateEmailView';

  static Widget providedInstance() {
    return BlocProvider<UpdateEmailBloc>(
        create: (context) => UpdateEmailBloc()..add(UpdateEmailGet()),
        child: UpdateEmailView());
  }
}

class _UpdateEmailViewState extends State<UpdateEmailView> {
  final _formKey = GlobalKey<FormState>();

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
    TextStyle updateLoginTitleTextStyle = TextStyle(
        fontSize: 18,
        color: AppColor.primaryColor,
        fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Email Address'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<UpdateEmailBloc, UpdateEmailState>(
            listener: (context, state) {
              if (state is UpdateEmailInitial) {
                //TODO: Refactor if possible
                // _emailController.text = state.email;
              } else if (state is UpdateEmailSuccess) {
                _emailController.text = state.email;
                _passwordController.text = '';
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.successMessage),
                  ),
                  action: SnackBarAction(
                    label: 'Verify',
                    onPressed: () => locator<NavigationService>().goAndComeBack(
                        EmailVerification.providedInstance(),
                        EmailVerification.name),
                  ),
                  duration: Duration(seconds: 60),
                ));
              } else if (state is UpdateEmailFailure) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.errorMessage),
                  ),
                ));
              }
              print('==============LoginDetailsBloc : $state');
            },
//              buildWhen: (previousState, state) => state is LoginDetailsSuccess,
            builder: (context, state) => Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: OutLinedInputCard(
                        enabled: (state is! UpdateEmailSubmitting),
                        controller: _emailController,
                        error: (state is UpdateEmailValidation)
                            ? state.emailError
                            : null,
//                          validator: (value) {
//                            bool emailValid = RegExp(
//                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                .hasMatch(value);
//
//                            if (!emailValid) {
//                              return 'Please enter a valid Email';
//                            }
//                            return null;
//                          },
                        hintText: 'New Email',
                        helperText: 'Enter email',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: OutLinedInputCard(
                        isPassword: true,
                        enabled: (state is! UpdateEmailSubmitting),
                        controller: _passwordController,
                        error: (state is UpdateEmailValidation)
                            ? state.passwordError
                            : null,
//                          validator: (value) {
//                            if (value.length < 8) {
//                              return 'Password can\'t be less than 8 characters';
//                            }
//                            return null;
//                          },
                        hintText: 'Password',
                        helperText: 'Enter password',
                      ),
                    ),
                    BusyButton(
                      busy: (state is UpdateEmailSubmitting),
                      buttonColour: AppStyle.optionalPrimaryButton,
                      margin: EdgeInsets.fromLTRB(16, 30, 16, 0),
                      title: 'UPDATE',
                      onPressed: () async {
                        context.bloc<UpdateEmailBloc>().add(UpdateEmailUpdate(
                            _emailController.text, _passwordController.text));
                        // context.bloc<LoginDetailsBloc>().add(LoginDetailsUpdate(
                        //     _emailController.text,
                        //     _passwordController.text,
                        //     _conformPasswordController.text));
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
