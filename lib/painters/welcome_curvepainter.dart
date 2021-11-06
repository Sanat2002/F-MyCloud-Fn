import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeCurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas,Size size){

    var paint = Paint();
    // set properties of paint(paintbrush)
    paint.color = Vx.orange100;
    paint.style = PaintingStyle.fill;
    // paint.strokeWidth = 3;

    var path = Path();
    // draw your path
    path.moveTo(0, size.height*.25);
    path.quadraticBezierTo(size.width*.5, 0, size.width, size.height*.25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return false;
  }

}