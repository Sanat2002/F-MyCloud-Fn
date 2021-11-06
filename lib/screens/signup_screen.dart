// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cloud_photos/painters/signup_curvepainter.dart';
import 'package:flutter_cloud_photos/screens/verify_screen.dart';
import 'package:flutter_cloud_photos/services/authentication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final DatabaseReference _dbref = FirebaseDatabase.instance.reference();

  var emailcont = TextEditingController();
  var passcont = TextEditingController();
  var namecont = TextEditingController();

  bool _loading =false;

  adduser(){
    var nemail = emailcont.text.toString().replaceAll(".", "");
    _dbref.child("MyCloud").child(nemail).set({
      "name" : namecont.text,
      "email" : emailcont.text,
      "password" : passcont.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:_loading? Center(child: CircularProgressIndicator(
        color: Vx.purple400,
      ),): SingleChildScrollView(
        child: SizedBox(
          height:size.height,
          width:size.width,
          child: Stack( // always try to put stack in container
            children: [
              Positioned(
                child: SizedBox(
                  height: size.height*.5,
                  width: size.width,
                  child: CustomPaint( // put custompaint in container of your dimensions so to draw correctly
                    painter: SignupCurvePainter1(),
                  ),
                )),
                Positioned(
                  top: size.height*.06,
                  left: size.width*.15,
                  right: size.width*.15,
                  child: "Upload your files and we will keep it safe and private.".text.textStyle(TextStyle(fontFamily:GoogleFonts.zillaSlab().fontFamily)).xl2.white.make()
                ),
                Positioned(
                  top: size.height*.14,
                  left: 0,
                  right: 0,
                  child: Lottie.asset("assets/images/signup.json",height:size.height*.4)
                ),
                Positioned(
                  top: size.height*.55,
                  child: SizedBox(
                    height: size.height*.45,
                    width: size.width,
                    child: CustomPaint(
                      painter: SignupCurvePainter2(),
                    ),
                  )
                ),
                Positioned(
                  top: size.height*.56,
                  left: size.width*.1,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        "Sign Up".text.xl3.make(),
                        20.heightBox,
                        Container(
                          height: size.height*.07,
                          width: size.width*.8,
                          decoration:BoxDecoration(
                          color: Vx.purple500,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          child: TextFormField(
                            controller: namecont,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter username";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 17,
                              color: Vx.white
                            ),
                            cursorColor: Vx.white,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color:Colors.white
                              ),
                              prefixIcon: Icon(Icons.person,color: Colors.white,size: 27,),
                              hintText: "Username",
                              hintStyle: TextStyle(
                                color: Vx.white
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide(
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
                        Container(
                          height: size.height*.07,
                          width: size.width*.8,
                          decoration:BoxDecoration(
                          color: Vx.purple500,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          child: TextFormField(
                            controller: emailcont,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType:TextInputType.emailAddress,
                            validator: (value){
                              if(!EmailValidator.validate(value!)){
                                return "Enter valid email";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 17,
                              color: Vx.white
                            ),
                            cursorColor: Vx.white,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color:Colors.white
                              ),
                              prefixIcon: Icon(Icons.email,color: Colors.white,size: 27,),
                              hintText: "Email address",
                              hintStyle: TextStyle(
                                color: Vx.white
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide(
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
                        ).py(10), 
                        Container(
                          height: size.height*.07,
                          width: size.width*.8,
                          decoration:BoxDecoration(
                          color: Vx.purple500,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          child: TextFormField(
                            controller:passcont,
                            keyboardType: TextInputType.visiblePassword,
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if(value!.length<6){
                                return "Length should be of atleast 6 char..";
                              }
                              return null;
                            },
                            obscureText: visible?false: true,
                            style: TextStyle(
                              fontSize: 17,
                              color: Vx.white
                            ),
                            cursorColor: Vx.white,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color:Colors.white
                              ),
                              prefixIcon: Icon(Icons.lock,color: Colors.white,size: 27,),
                              suffixIcon: visible? IconButton(
                                splashRadius: 1,
                                onPressed: (){
                                  setState(() {
                                    visible = false;
                                  }
                                );
                                },
                                icon: Icon(Icons.visibility,color:Colors.white)
                              ) : IconButton(
                                splashRadius: 1,
                                onPressed: (){
                                  setState(() {
                                  visible=true;                                  
                                  });
                                },
                                icon: Icon(Icons.visibility_off,color:Colors.white)
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Vx.white
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide(
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
                        15.heightBox,
                        ElevatedButton(
                          style:ButtonStyle(
                            shape:MaterialStateProperty.all(StadiumBorder()),
                            textStyle:MaterialStateProperty.all(TextStyle(fontSize: 18)),
                            backgroundColor:MaterialStateProperty.all(Vx.purple600)
                          ),
                          onPressed: () async{
                            if(_formkey.currentState!.validate()){
                              setState(() {
                                _loading = true;
                              });
                              
                              var res = await AuthenticationServices().signupemail(emailcont.text, passcont.text);

                              if(res=="Success"){
                                await adduser();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Verifyemail(email: emailcont.text,)));
                              }

                              setState(() {
                                _loading = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.text.red400.make()));
                            }
                          },
                          child: "Sign Up".text.make()
                        ).w(size.width*.3).h(size.height*.05) 
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}