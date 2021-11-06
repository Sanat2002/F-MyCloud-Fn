// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloud_photos/screens/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class Verifyemail extends StatefulWidget {
  final String email;
  const Verifyemail({ Key? key , required this.email}) : super(key: key);

  @override
  _VerifyemailState createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {

  final _auth = FirebaseAuth.instance;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3),(timer){
      checkemailverify();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  checkemailverify() async{
    await _auth.currentUser!.reload();
    if(_auth.currentUser!.emailVerified){
      timer.cancel();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -size.height*.1,
            left: 0,
            right: 0,
            child: Image.asset("assets/images/verifyemail.gif",height: size.height*.8,)
          ),
          Positioned(
            left: 0,
            right: 0,
            top: size.height*.6,
            child: Column(
              children: [
                "Email Verification link has been sent to ".text.xl2.make(),
                20.heightBox,
                widget.email.text.green700.xl3.make(),
                20.heightBox,
                "Verify your eamil to Sign in...".text.xl2.make()
              ],
            ).px12())
        ],
      )
    );
  }
}