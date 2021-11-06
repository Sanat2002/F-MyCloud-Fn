import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SigninCurvePainter1 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    paint.color = Vx.pink400;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.quadraticBezierTo(size.width*.25, size.height, size.width*.5, size.height*.5);
    path.quadraticBezierTo(size.width*.75, size.height*.35, size.width, size.height);
    path.lineTo(size.width, 0);
    


    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(SigninCurvePainter1 oldDelegate){
    return false;
  }
}
class SigninCurvePainter2 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    paint.color = Vx.pink400;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(size.width*.65, size.height*.2, size.width*.5, size.height*.5);
    path.quadraticBezierTo(size.width*.25, size.height*.95, 0, size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(SigninCurvePainter2 oldDelegate){
    return false;
  }
}