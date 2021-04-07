import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/update_password_bloc/update_password_bloc.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/busy_btn.dart';
import 'package:parrotspellingapp/weidgets/shaired/input_card/outlined_input_card.dart';

class UpdatePasswordView extends StatefulWidget {
  static String name = 'UpdatePasswordView';

  @override
  _UpdatePasswordViewState createState() => _UpdatePasswordViewState();

  static Widget providedInstance() {
    return BlocProvider<UpdatePasswordBloc>(
        create: (context) => UpdatePasswordBloc(), child: UpdatePasswordView());
  }
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _conformNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _conformNewPasswordController.dispose();
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
        title: Text('Update Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<UpdatePasswordBloc, UpdatePasswordState>(
            listener: (context, state) {
              if (state is UpdatePasswordSuccess) {
                _passwordController.text = '';
                _newPasswordController.text = '';
                _conformNewPasswordController.text = '';
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.successMessage),
                  ),
                ));
              } else if (state is UpdatePasswordFailure) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.errorMessage),
                  ),
                ));
              }
            },
            builder: (context, state) => Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: OutLinedInputCard(
                        isPassword: true,
                        enabled: (state is! UpdatePasswordSubmitting),
                        controller: _passwordController,
                        error: (state is UpdatePasswordValidation)
                            ? state.passwordError
                            : null,
                        hintText: 'Password',
                        helperText: 'Enter password',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: OutLinedInputCard(
                        isPassword: true,
                        enabled: (state is! UpdatePasswordSubmitting),
                        controller: _newPasswordController,
                        error: (state is UpdatePasswordValidation)
                            ? state.newPasswordError
                            : null,
                        hintText: 'New Password',
                        helperText: 'Enter new password',
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                        child: OutLinedInputCard(
                          isPassword: true,
                          enabled: (state is! UpdatePasswordSubmitting),
                          controller: _conformNewPasswordController,
                          error: (state is UpdatePasswordValidation)
                              ? state.conformNewPasswordError
                              : null,
                          hintText: 'Conform New Password',
                          helperText: 'Enter new password',
                        )),
                    BusyButton(
                      busy: (state is UpdatePasswordSubmitting),
                      buttonColour: AppStyle.optionalPrimaryButton,
                      margin: EdgeInsets.fromLTRB(16, 30, 16, 0),
                      title: 'UPDATE',
                      onPressed: () async {
                        context.bloc<UpdatePasswordBloc>().add(
                            UpdatePasswordUpdate(
                                _passwordController.text,
                                _newPasswordController.text,
                                _conformNewPasswordController.text));
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
