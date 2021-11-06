// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloud_photos/painters/home_curvepainter.dart';
import 'package:flutter_cloud_photos/screens/music_screen.dart';
import 'package:flutter_cloud_photos/screens/othersfiles_screen.dart';
import 'package:flutter_cloud_photos/screens/photos_screen.dart';
import 'package:flutter_cloud_photos/screens/signin_screen.dart';
import 'package:flutter_cloud_photos/screens/signup_screen.dart';
import 'package:flutter_cloud_photos/screens/welcome_screen.dart';
import 'package:flutter_cloud_photos/services/authentication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final DatabaseReference _dbref = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();

  var nname="";
  var npass="";
  var delemail;

  updateprofile()async{
    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");
    try{
      _dbref.child("MyCloud").child(nemail).update({
        "name" : nname,
        "password" : npass
      });
      return "Profile Updated";
    } on FirebaseException catch(e){
      return "Updation Failed";
    }
  }

  deletephotos(deluser) async{
    var allphotos = await storage.ref("MyCloud/$deluser/photos").listAll();
    allphotos.items.forEach((element) async {
      await storage.ref("MyCloud/$deluser/photos/${element.name}").delete();
    });
  }

  deletemusic(deluser) async{
    var allmusic = await storage.ref("MyCloud/$deluser/music").listAll();
    allmusic.items.forEach((element) async {
      await storage.ref("MyCloud/$deluser/music/${element.name}").delete();
    });
  }

  deleteotherfiles(deluser) async{
    var allotherfiles = await storage.ref("MyCloud/$deluser/otherfiles").listAll();
    allotherfiles.items.forEach((element) async {
      await storage.ref("MyCloud/$deluser/otherfiles/${element.name}").delete();
    });
  }

  deleteaccount(deluser) async{
    try{
      await deletephotos(deluser);
      await deletemusic(deluser);
      await deleteotherfiles(deluser);
      await _dbref.child("MyCloud").child(deluser).remove();
      return "Deleted";
    } on FirebaseException catch(e){
      return "Deletion Failed...";
    }
  }

  deleteaccountdialog(BuildContext context) async{
    delemail = _auth.currentUser!.email;
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            height: size.height*.03,
            width: size.width*.2,
            child: "Delete Account".text.xl3.red700.make()),
          content: SizedBox(
            height: size.height*.222,
            width:size.width*.5,
            child: Form(
              key: _formkey1,
              child: Column(
                children:[
                  Divider(color: Colors.redAccent,),
                  TextFormField(
                      validator: (value){
                        return  value!=delemail ? "Enter correct email" : null; 
                      },
                      cursorColor: Colors.black,
                      onChanged: (e){
                        npass = e;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.mail,color:Colors.black),
                        label: "Email".text.make(),
                        labelStyle: TextStyle(
                          color:Colors.black
                        ),
                        hintText: "Your Email",
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black
                          )
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black
                          )
                        )
                      ),
                    ),
                  SizedBox(
                    height: size.height*.05,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () async{
                      if(_formkey1.currentState!.validate()){
                        var deluser = _auth.currentUser!.email.toString().replaceAll(".", "");
                        var res = await AuthenticationServices().deleteuser();

                        if(res == "ReSign"){
                          await AuthenticationServices().signout();
                          res = "Re-SignIn required!!!";
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignIn()), (route) => false);
                        }
                        else if(res == "Success"){
                          var res1 = await deleteaccount(deluser);
                          res = res1;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignUp()), (route) => false);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
                      }
                    }, 
                    child: "Delete".text.make())
                ]
              )),
          ),
        );
      });
  }

  editprofiledialog(BuildContext context) async{
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Container(
            alignment:Alignment.center,
            height:size.height*.03,
            width: size.width*.0,
            child: "Edit Profile".text.xl3.make()),
          content:SizedBox(
            height: size.height*.3429,
            width: size.width*.5,
            child: Form(
              key:_formkey,
              child: Column(
                children: [
                  Divider(color: Colors.black,),
                  TextFormField(
                    validator: (value){
                      return value!.isEmpty? "Enter new name" : null;
                    },
                    cursorColor: Colors.black,
                    initialValue: nname,
                    onChanged: (e){
                      nname = e;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.person,color:Colors.black),
                      label: "Username".text.make(),
                      labelStyle: TextStyle(
                        color:Colors.black
                      ),
                      hintText: "New name",
                      enabledBorder:UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black
                        )
                      ),
                      focusedBorder:UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black
                        )
                      )
                    ),
                  ),
                  TextFormField(
                    validator: (value){
                      return value!.length<6 ? "Enter atleast 6 char..." : null; 
                    },
                    cursorColor: Colors.black,
                    initialValue: npass,
                    onChanged: (e){
                      npass = e;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock,color:Colors.black),
                      label: "Password".text.make(),
                      labelStyle: TextStyle(
                        color:Colors.black
                      ),
                      hintText: "New password",
                      enabledBorder:UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black
                        )
                      ),
                      focusedBorder:UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black
                        )
                      )
                    ),
                  ),
                  SizedBox(
                    height: size.height*.02,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black12)
                    ),
                    onPressed: ()async{
                      deleteaccountdialog(context);
                    },
                    child: "Delete Account".text.red800.xl2.make()),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black12)
                    ),
                    onPressed: ()async{
                      if(_formkey.currentState!.validate()){
                        var res = await updateprofile();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
                        Navigator.pop(context);
                      }
                    },
                    child: "Change".text.black.xl2.make())
                ],
              ),
            ),
          )
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
            height:size.height,
            width: size.width,
            child: CustomPaint(
              painter: HomeCurverPainter1(),
            ),
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
            height:size.height,
            width: size.width,
            child: CustomPaint(
              painter: HomeCurverPainter2(),
            ),
          )),
          Positioned(
            top: size.height*.2,
            left: size.width*.1,
            right: size.width*.1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<DataSnapshot>(
                    future:_dbref.child("MyCloud").child(_auth.currentUser!.email.toString().replaceAll(".", "")).get(),
                    builder: (_,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(color:Colors.white));
                      }

                      var data = snapshot.data!.value;
                      var name = data["name"];
                      var email = data["email"];
                      nname = name;
                      npass = data["password"];

                      return ListTile(
                        title:name.toString().text.textStyle(TextStyle(fontFamily: GoogleFonts.vesperLibre().fontFamily)).xl5.make(),
                        subtitle: email.toString().text.textStyle(TextStyle(fontFamily: GoogleFonts.varela().fontFamily)).make(),
                      );
                    }),
                  20.heightBox,
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Photos()));
                    },
                    leading: Icon(Icons.image_rounded,color: Colors.black,),
                    title:"Photos".text.xl.make().px(size.width*.03)
                  ).px(size.width*.1),
                  ListTile(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Music()));
                    },
                    leading: Row(
                      children: [
                        Icon(Icons.movie_creation,color: Colors.black,),
                        Icon(Icons.music_note_outlined,color: Colors.black,),
                      ],
                    ).w(size.width*.13),
                    title:"Movies/Music".text.xl.make()
                  ).px(size.width*.1),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherFiles()));
                    },
                    leading: Icon(Icons.file_copy_rounded,color: Colors.black,),
                    title:"Other Files".text.xl.make().px(size.width*.03)
                  ).px(size.width*.1)
                ],
              ),
            )),
          Positioned(
            top: size.height*.6,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashRadius: 1,
                  onPressed: () async{
                    await AuthenticationServices().signout();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Welcome()), (route) => false);
                },
                icon: Icon(CupertinoIcons.decrease_quotelevel,size: 30,)),
                190.widthBox,
                IconButton(
                  splashRadius: 1,
                  onPressed: ()async{
                    await editprofiledialog(context);
                },
                icon: Icon(CupertinoIcons.profile_circled,size: 30,))
              ],
            ))
        ],
      ),
    );
  }
}