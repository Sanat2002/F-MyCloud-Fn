// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloud_photos/painters/signin_curvepainter.dart';
import 'package:flutter_cloud_photos/screens/home_screen.dart';
import 'package:flutter_cloud_photos/services/authentication.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class SignIn extends StatefulWidget {
  const SignIn({ Key? key }) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _auth = FirebaseAuth.instance;

  final _formkey = GlobalKey<FormState>();

  var emailcont = TextEditingController();
  var passcont = TextEditingController();

  bool _loading = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: _loading? Center(child: CircularProgressIndicator(color: Vx.pink400,),) 
      :SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: size.height*.25,
                  width: size.width,
                  child: CustomPaint(
                    painter: SigninCurvePainter1(),
                  ),
                )
              ),
              Positioned(
                top:size.height*.05,
                left:0,
                right: 0,
                child: Lottie.asset("assets/images/signin.json",height: size.height*.45)
              ),
              Positioned(
                top: size.height*.5,
                child: SizedBox(
                  height: size.height*.5,
                  width: size.width,
                  child: CustomPaint(
                    painter: SigninCurvePainter2(),
                  ),
                )
              ),
              Positioned(
                top:size.height*.5,
                left: 0,
                right: 0,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      "Sign In".text.xl3.make(),
                      35.heightBox,
                      Container(
                        height: size.height*.07,
                        width: size.width*.8,
                        decoration: BoxDecoration(
                          color: Vx.pink300,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailcont,
                          validator: (value){
                            if(!EmailValidator.validate(value!)){
                              return "Enter valid email address";
                            }
                            return null;
                          },
                          cursorColor: Vx.pink500,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white
                          ),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.white
                            ),
                            hintText: "Email address",
                            hintStyle: TextStyle(
                              color: Colors.white
                            ),
                            prefixIcon: Icon(Icons.mail,color: Colors.white,size: 27,),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent
                              )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent
                              )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                          ),
                        ).px(20),
                      ),
                      25.heightBox,
                      Container(
                        height: size.height*.07,
                        width: size.width*.8,
                        decoration: BoxDecoration(
                          color: Vx.pink300,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _visible? false : true,
                          controller: passcont,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(value!.length<6){
                              return "Length is greater than 6...";
                            }
                            return null;
                          },
                          cursorColor: Vx.pink500,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white
                          ),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.white
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.white
                            ),
                            prefixIcon: Icon(Icons.lock_open_rounded,color: Colors.white,size: 27,),
                            suffixIcon:_visible? IconButton(onPressed: (){
                              setState(() {
                                _visible = false;
                              });
                            }, icon: Icon(Icons.visibility,color: Colors.white,)): IconButton(onPressed: (){
                              setState(() {
                                _visible = true;
                              });
                            }, icon: Icon(Icons.visibility_off,color: Colors.white,)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent
                              )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent
                              )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                          ),
                        ).px(20),
                      ),
                      30.heightBox,
                      ElevatedButton(
                        style: ButtonStyle(
                          textStyle:MaterialStateProperty.all(TextStyle(fontSize: 18)),
                          backgroundColor:MaterialStateProperty.all(Vx.pink500),
                          shape: MaterialStateProperty.all(StadiumBorder()),
                        ),
                        onPressed: () async{
                          if(_formkey.currentState!.validate()){
                            setState(() {
                              _loading = true;
                            });

                            var res = await AuthenticationServices().signinemail(emailcont.text, passcont.text);

                            if(res=="Success"){
                              if(_auth.currentUser!.emailVerified){
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
                              }
                              else{
                                await AuthenticationServices().signout();
                                res = "Please, Verify your email..";
                              }
                            }

                            setState(() {
                              _loading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.text.red400.make()));

                          }
                        }, 
                        child:"Sign In".text.xl.make()
                      ).w(size.width*.3).h(size.height*.05)
                    ],
                  ),
                ))
            ],
          ),
        ),
      )
    );
  }
}