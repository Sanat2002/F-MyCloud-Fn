// ignore_for_file: prefer_const_constructors

// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter_cloud_photos/screens/home_screen.dart';
// import 'package:flutter_cloud_photos/screens/welcome_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;
  final _dbref = FirebaseDatabase.instance.reference();

  bool show = false;

  @override
  void initState() {
    super.initState();
    add();
  }

  add() async{
    try{
      await _dbref.child("kdk").set({
        "kd":"sanat"
      });
    } on FirebaseException catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    var user = _auth.currentUser;
    if(user == null){
      show = false;
    }
    else if(user.emailVerified){
      show = true;
    }

    return MaterialApp(
      title: 'My cloud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:"helo".text.make()
      // home: AnimatedSplashScreen(
      //   backgroundColor: Vx.white,
      //   splashIconSize: 250,
      //   duration: 3000,
      //   animationDuration: Duration(seconds: 1),
      //   splashTransition: SplashTransition.fadeTransition,
      //   splash:Lottie.asset("assets/images/cloud_splash_ani.json"), 
      //   nextScreen:show? Welcome(): Welcome()),
    );
  }
}
