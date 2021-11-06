// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mycloud_fn/painters/welcome_curvepainter.dart';
// import 'package:flutter_cloud_photos/screens/home_screen.dart';
import 'package:flutter_mycloud_fn/screens/signin_screen.dart';
import 'package:flutter_mycloud_fn/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class Welcome extends StatefulWidget {
  const Welcome({ Key? key }) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: size.height*.05,
            left: size.width/5.9,
            child: "Welcome to My Cloud".text.xl3.textStyle(TextStyle(fontFamily: GoogleFonts.kameron().fontFamily)).orange600.make()),
          Positioned(
            top: size.height*.1,
            left:0,
            right: 0,
            child: Lottie.asset("assets/images/wel_cloud.json",)
          ),
          Positioned(
            top: size.height*.41,
            bottom:0,
            child: SizedBox(
              height: size.height*.6,
              width: size.width,
              child: CustomPaint(
                painter: WelcomeCurvePainter(),
              ),
            ),
          ),
          Positioned(
            top: size.height*.689,
            left: size.width*.15,
            child: ClipRect(
              child: ElevatedButton(
                style:ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all(Vx.orange500),
                  shape: MaterialStateProperty.all(StadiumBorder())
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                }, 
                child: "Sign Up".text.xl2.make()
              ).wh(size.width*.7, size.height*.055),
            )),
          Positioned(
            top: size.height*.79,
            left: size.width*.15,
            child: ClipRect(
              child: ElevatedButton(
                style:ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all(Vx.orange400),
                  shape: MaterialStateProperty.all(StadiumBorder())
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                }, 
                child: "Sign In".text.xl2.make()
              ).wh(size.width*.7, size.height*.055),
            ))
        ],
      ),
    );
  }
}