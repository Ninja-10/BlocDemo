import 'package:flutter/cupertino.dart';

import 'app_color.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColor.primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(
      size.width - 5,
      size.height - 5,
      size.width,
      size.height - 40,
    );
//    path.lineTo(size.width, size.height - 100);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
