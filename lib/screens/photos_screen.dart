// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloud_photos/screens/photodetail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class Photos extends StatefulWidget {
  const Photos({ Key? key }) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  final storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  var searchimg = ValueNotifier<String>("");

  dynamic photopath;
  String name = "";
  String searchname = "";


  pickphoto() async{
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['png','jpg'],
      type: FileType.custom
    );
    
    if(result==null){
      photopath = null;
      return null;
    }
    photopath = result.files.single.path;
  }

  uploadphoto() async{

    File file = File(photopath);
    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");

    try{
      await storage.ref("MyCloud/$nemail/photos/$name").delete();
    } on FirebaseException catch(e){
      print(e);// return statement is not used here because if we use then function will exit here and rest code will we dead
    }

    try{
      await storage.ref("MyCloud/$nemail/photos/$name").putFile(file);
      return "Uploaded";
    } on FirebaseException catch(e){
      return "Upload Failed";
    }
  }

  Future<String?> showdialogtogetname(BuildContext context) async{
    Size size = MediaQuery.of(context).size;
    await showDialog<String>(
      context: context, 
      builder: (BuildContext context){ // add container or sizedbox to give height and weight of the child , if we don't it throw error of hasSize
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: SizedBox(
            height: size.height*.04,
            width: size.width*.7,
            child: "Name of Image with extension".text.white.make()),
          content: Container(
            height: size.height*.06,
            width:size.width*.7,
            color: Colors.white,
            child: Form(
              key: _formkey,
              child: TextFormField(
                cursorColor: Colors.black,
                cursorHeight: 25,
                autofocus: true,
                style: TextStyle(
                  fontSize: 20
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:BorderSide(color: Colors.transparent)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:BorderSide(color: Colors.transparent)
                  )
                ),
                onChanged: (e){
                  name = e;
                },
                validator: (value){
                  return value!.isEmpty ? "Enter name" : null;
                },
              ),
            )
          ),
          actions: [
            TextButton(
              onPressed: (){
                if(_formkey.currentState!.validate()){
                  Navigator.of(context).pop();
                }
              }, 
              child: SizedBox(height: size.height*.02,width: size.width*.15,child: "Done".text.white.xl2.make()))
          ],
        );
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton:CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black87,
        child: IconButton(
          splashRadius: 1,
          onPressed: () async{
            await pickphoto();
            if(photopath!=null){
             await showdialogtogetname(context);
             if(name.isNotEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: "Uploading, this may take a while...".toString().text.red400.make()));
              var res = await uploadphoto();
              name = "";
              setState(() {
               
              });
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
             }
            }
          },
         icon: Icon(Icons.image,color: Colors.white,size:30),
      )),
      body: SizedBox(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Opacity(opacity: .75,child: Image.asset("assets/images/photos.jpg",height: size.height,))
            ),
            Positioned(
              top:size.height*.03,
              left: 0,
              right: 0,
              child: "YOUR PHOTOS".text.textStyle(TextStyle(fontFamily:GoogleFonts.walterTurncoat().fontFamily)).xl6.make().p(.2)),
            Positioned(
              top: size.height*.13,
              left: 0,
              right: 0,
              child:TextFormField(
                onChanged: (e){
                  searchimg.value = e;
                  searchname = e;
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                cursorColor: Colors.black,
                cursorHeight: 30,
                decoration: InputDecoration(
                  hintText: "Search",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.black,width: 3)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.black,width: 3)
                  )
                 ),
              ).px(40)
            ),
            Positioned(
              top:size.height*.2,
              left:0,
              right:0,
              bottom: 0, // make bottom is equal to zero whenever you use singlechildscrollview or gridview.builder or listview.builder 
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: storage.ref("MyCloud/${_auth.currentUser!.email.toString().replaceAll(".", "")}/photos").listAll(),
                  builder:(BuildContext context, AsyncSnapshot<ListResult> snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return SizedBox(
                        height: size.height*.7,
                        child: Center(child: CircularProgressIndicator(color: Colors.white,)));
                    }

                    List storephotos = [];
                    snapshot.data!.items.forEach((e){
                      storephotos.add(e);
                    });
                    
                    List searchedphotos;
                    tosearchphotos(searchname){
                      searchedphotos = [];
                      storephotos.forEach((element) {
                        if(element.name.toString().contains(searchname)){
                          searchedphotos.add(element);
                        }
                      });
                      return searchedphotos;
                    }

                    // print(storephotos[0].root);
                    // print(snapshot.data!.items[0]);
                    
                    return ValueListenableBuilder(
                      valueListenable: searchimg,
                      builder: (BuildContext context, String value, Widget? child) {
                        return storephotos.isEmpty ? Center(child: "Nothing added yet".text.extraBlack.xl4.make()).h(size.height*.5) : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: value.isNotEmpty? tosearchphotos(searchname).length : storephotos.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2
                          ), 
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoDetail(name: value.isNotEmpty? tosearchphotos(searchname)[index].name: storephotos[index].name)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:size.height*.2,
                                        child: FutureBuilder(
                                          future: value.isNotEmpty? tosearchphotos(searchname)[index].getDownloadURL(): storephotos[index].getDownloadURL(),
                                          builder: (BuildContext context,AsyncSnapshot<String> snapshot){
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return Center(child: CircularProgressIndicator(color: Colors.white,));
                                            }
                                            return Image.network(snapshot.data!,height: size.height*.1,);
                                          }),
                                      ),
                                      Divider(color: Colors.white,),
                                      value.isNotEmpty? tosearchphotos(searchname)[index].name.toString().text.white.make().py(3) : storephotos[index].name.toString().text.white.make().py(3)
                                    ],
                                  ).p(4),
                                ),
                              ).px(4).py(2),
                            );
                          }).p(4);
                      },
                    );
                  },),
              ))
          ],
        ),
      )
    );
  }
}