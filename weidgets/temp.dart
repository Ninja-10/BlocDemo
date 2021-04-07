import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/utils/app_color.dart';
import 'package:parrotspellingapp/utils/app_styles.dart';
import 'package:parrotspellingapp/weidgets/shaired/button/app_icon_btn.dart';

class TempView extends StatefulWidget {
  final int stars;
  final String spelling;

  TempView({this.spelling, this.stars});

  @override
  _TempViewState createState() => _TempViewState();
}

class _TempViewState extends State<TempView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'CORRECT!',
          style: TextStyle(
              color: AppColor.buttonOptionalPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 50),
        ),
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColor.primaryColor),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            widget.spelling,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                letterSpacing: 10),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: <Widget>[
            Text(
              widget.stars.toString(),
              style: AppStyle.dialLogScoreText,
            ),
            Text(
              'X',
              style: AppStyle.dialLogScoreText,
            ),
            Icon(
              Icons.star,
              color: Colors.yellow,
              size: 40,
            ),
            Text(
              '=',
              style: AppStyle.dialLogScoreText,
            ),
            Text(
              (widget.stars * 10).toString(),
              style: AppStyle.dialLogScoreText,
            ),
            Icon(
              Icons.monetization_on,
              color: Colors.yellow,
              size: 40,
            )
          ],
        ),
      ),
      Row(
        children: [
          Flexible(
            child: AppIconButton(
              buttonColour: AppStyle.optionalSecondaryButton,
              iconPosition: IconPosition.Left,
              icon: Icons.menu,
              margin: EdgeInsets.fromLTRB(16, 6, 8, 16),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
          Flexible(
              child: AppIconButton(
            buttonColour: AppStyle.optionalSecondaryButton,
            iconPosition: IconPosition.Right,
            margin: EdgeInsets.fromLTRB(8, 6, 16, 16),
            onPressed: () {
              setState(() {});
            },
          )),
        ],
      )
    ]);
  }
}
