import 'package:flutter/material.dart';

class AppColor {
  static Color primaryColor = Color(0xff6200EE);
  static Color primaryColorDark = Color(0xff6200EE);
  static Color accentColor = Color(0xff03DAC5);

  static Color buttonPrimary = Colors.greenAccent;
  static Color buttonPrimaryDark = Colors.green;

  static Color buttonOptionalPrimary = Color(0xff6FCC00);
  static Color buttonOptionalPrimaryDark = Color(0xff00A554);

  static Color buttonOptionalSecondary = Color(0xffF2DA60);
  static Color buttonOptionalSecondaryDark = Color(0xffCCB029);

  static Color buttonSecondary = Colors.yellowAccent.shade400;
  static Color buttonSecondaryDark = Colors.yellow.shade700;
  static Color buttonSecondaryText = Color(0xff9E6BE7);

  static Color buttonAccent = Colors.deepPurpleAccent;
  static Color buttonAccentDark = Colors.deepPurpleAccent.shade400;

  static Color iconColor = Colors.deepPurpleAccent;
  static Color errorColor = Colors.pink;
  static Color successColor = Colors.green;

  static Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };
}
