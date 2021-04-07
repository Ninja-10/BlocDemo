import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parrotspellingapp/utils/app_color.dart';

class ConnectionErrorDialog extends StatelessWidget {
  static bool isShowing = false;

  static void show(BuildContext context) {
    if (true) {
      // isShowing = true;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ConnectionErrorDialog();
          });
    }
  }

  static void hide(BuildContext context) {
    if (true && Navigator.canPop(context)) {
      // isShowing = false;
      Navigator.pop(context);
    }
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: const Text("No Internet !"),
        content:
            const Text("Oops, you don\'t have working internet connection."),
        actions: <Widget>[
          FlatButton(
              onPressed: () =>
                  Future.delayed(const Duration(milliseconds: 100), () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }),
              child: Text(
                "Close App",
                style: TextStyle(color: AppColor.primaryColor),
              )),
          FlatButton(
            onPressed: () {
              AppSettings.openDataRoamingSettings();
            },
            child: Text("Enable Mobile Data",
                style: TextStyle(color: AppColor.primaryColor)),
          ),
          FlatButton(
            onPressed: () {
              AppSettings.openWIFISettings();
            },
            child: Text("Enable WIFI",
                style: TextStyle(color: AppColor.primaryColor)),
          ),
        ],
      ),
    );
  }
}
