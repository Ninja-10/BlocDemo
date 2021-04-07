import 'package:flutter/material.dart';

class AppFormValidator {
  String _validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
        .hasMatch(email);

    if (!emailValid) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  String _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password can\'t be less than 8 characters';
    }
    return null;
  }

  String _validateConformPassword(String password, String conformPassword) {
    if (password != conformPassword) {
      return 'Password does not match';
    }
    return null;
  }

  AppFormValidatorData validateFields(
      {String email, String password, String conformPassword}) {
    String _emailError;
    String _passwordError;
    String _conformPasswordError;
    bool _isValid = false;
    if (email != null) {
      _emailError = _validateEmail(email);
      _isValid = (_emailError == null);
    }
    if (password != null) {
      _passwordError = _validatePassword(password);
      _isValid = (_passwordError == null);
    }
    if (conformPassword != null) {
      _conformPasswordError =
          _validateConformPassword(password, conformPassword);
      _isValid = (_passwordError == null);
    }
    return AppFormValidatorData(
        emailError: _emailError,
        passwordError: _passwordError,
        conformPasswordError: _conformPasswordError,
        isValid: _isValid);
  }
}

@immutable
class AppFormValidatorData {
  final String emailError;
  final String passwordError;
  final String conformPasswordError;
  final bool isValid;

  AppFormValidatorData(
      {this.emailError,
      this.passwordError,
      this.conformPasswordError,
      this.isValid});
}
