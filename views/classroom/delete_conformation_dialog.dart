import 'package:flutter/material.dart';
import 'package:parrotspellingapp/utils/app_color.dart';

class DeleteConformationDialog extends StatelessWidget {
  static show(BuildContext context) async => await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConformationDialog();
      });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Confirmation"),
      content: const Text("Are you sure you want to delete this Course?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Delete",
              style: TextStyle(color: AppColor.primaryColor),
            )),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Cancel", style: TextStyle(color: AppColor.primaryColor)),
        ),
      ],
    );
  }
}
