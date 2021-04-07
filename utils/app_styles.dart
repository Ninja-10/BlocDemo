import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';

class AppStyle {
  static TextStyle dialLogScoreText =
      TextStyle(color: Colors.green, fontSize: 35, fontWeight: FontWeight.w600);

  static AppButtonColour primaryButton = AppButtonColour(
      backGroundColor: AppColor.buttonPrimaryDark,
      foreGroundColor: AppColor.buttonPrimary,
      textColor: Colors.white);

  static AppButtonColour optionalPrimaryButton = AppButtonColour(
      backGroundColor: AppColor.buttonOptionalPrimaryDark,
      foreGroundColor: AppColor.buttonOptionalPrimary,
      textColor: Colors.white);

  static AppButtonColour secondaryButton = AppButtonColour(
      backGroundColor: AppColor.buttonSecondaryDark,
      foreGroundColor: AppColor.buttonSecondary,
      textColor: AppColor.buttonSecondaryText);

  static AppButtonColour optionalSecondaryButton = AppButtonColour(
      backGroundColor: AppColor.buttonOptionalSecondaryDark,
      foreGroundColor: AppColor.buttonOptionalSecondary,
      textColor: AppColor.buttonSecondaryText);

  static AppButtonColour accentButton = AppButtonColour(
      backGroundColor: AppColor.buttonAccentDark,
      foreGroundColor: AppColor.buttonAccent,
      textColor: Colors.white);
}
