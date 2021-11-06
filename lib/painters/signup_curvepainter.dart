import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupCurvePainter1 extends CustomPainter{
  @override
  void paint(Canvas canvas,Size size){

    var paint = Paint();
    // set properties of paint(paintbrush)
    paint.color = Vx.purple400;
    paint.style = PaintingStyle.fill;


    var path = Path();
    // draw your path
    path.moveTo(0, size.height*.65);
    path.quadraticBezierTo(size.width*.5, size.height*.25, size.width, size.height*.65);
    path.lineTo(size.width,0);
    path.lineTo(0, 0);
    

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return false;
  }

}

class SignupCurvePainter2 extends CustomPainter{
  @override
  void paint(Canvas canvas,Size size){
    var paint = Paint();
    paint.color = Vx.purple400;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.quadraticBezierTo(size.width*.375, size.height*.25,size.width*.5,size.height*.5);
    path.quadraticBezierTo(size.width*.75, size.height*.875, size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SignupCurvePainter2 oldDelegate){
    return false;
  }
}