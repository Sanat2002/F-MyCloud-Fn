import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeCurverPainter1 extends CustomPainter{
  @override
  void paint(Canvas canvas,Size size){
    var paint = Paint();
    paint.color = Vx.green300;
    // paint.color = Colors.black26;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.quadraticBezierTo(size.width*.125, size.height*.125, size.width*.25, size.height*.25);
    path.quadraticBezierTo(size.width*.375, size.height*.375, size.width*.15, size.height*.5);
    path.quadraticBezierTo(size.width*.375, size.height*.75, size.width*.1, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HomeCurverPainter1 oldDelegate){
    return false;
  }
}

class HomeCurverPainter2 extends CustomPainter{
  @override
  void paint(Canvas canvas,Size size){
    var paint = Paint();
    paint.color = Vx.green300;
    // paint.color = Colors.black26;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width, size.height);
    path.quadraticBezierTo(size.width*.825, size.height*.825, size.width*.775, size.height*.775);
    path.quadraticBezierTo(size.width*.65, size.height*.65, size.width*.925, size.height*.5);
    path.quadraticBezierTo(size.width*.59, size.height*.25, size.width*.9, 0);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HomeCurverPainter2 oldDelegate){
    return false;
  }
}