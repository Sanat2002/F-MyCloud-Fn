// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';

class Music extends StatefulWidget {
  const Music({ Key? key }) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {

  final storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  var searchmus = ValueNotifier<String>("");

  dynamic photopath;
  String name = "";
  String searchname = "";

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async{
    await Permission.storage.request();
  }

  downloadmusic(name) async{
    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");
    var path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

    File tostorein = File("$path/$name");

    try{
      await storage.ref("MyCloud/$nemail/music/$name").writeToFile(tostorein);
      return "Downloaded";
    } on FirebaseException catch(e){
      return "Download Failed";
    }
  }

  deletemusic(name) async{
    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");
    try{
      await storage.ref("MyCloud/$nemail/music/$name").delete();
      return "Deleted";
    } on FirebaseException catch(e){
      return "Deletion Failed";
    }
  }

  pickmusic() async{
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['mp3','mp4'],
      type: FileType.custom
    );
    
    if(result==null){
      photopath = null;
      return null;
    }
    photopath = result.files.single.path;
  }

  uploadmusic() async{
    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");
    File file = File(photopath);

    try{
      await storage.ref("MyCloud/$nemail/music/$name").delete();
    } on FirebaseException catch(e){
      print(e);// return statement is not used here because if we use then function will exit here and rest code will we dead
    }

    try{
      await storage.ref("MyCloud/$nemail/music/$name").putFile(file);
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
            child: "Name of Mo/usic with extension".text.white.make()),
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
        backgroundColor: Colors.black,
        child: IconButton(
          splashRadius: 1,
          onPressed: () async{
            await pickmusic();
            if(photopath!=null){
             await showdialogtogetname(context);
             if(name.isNotEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: "Uploading, this may take a while...".toString().text.red400.make()));
              var res = await uploadmusic();
              name = "";
              setState(() {
               
              });
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
             }
            }
          },
         icon: Icon(Icons.movie_filter_outlined,color: Colors.white,size:30),
      )),
      body: SizedBox(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: -size.width*1.2,
              child: Opacity(opacity: .75,child: Image.asset("assets/images/music.jpg",height: size.height*6,))
            ),
            Positioned(
              top:size.height*.03,
              left: size.width*.07,
              right: 0,
              child: "YOUR MOV/USIC".text.color(Vx.gray700).textStyle(TextStyle(fontFamily:GoogleFonts.walterTurncoat().fontFamily)).xl5.make().p(.2)),
            Positioned(
              top: size.height*.13,
              left: 0,
              right: 0,
              child:TextFormField(
                onChanged: (e){
                  searchmus.value = e;
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
              child: FutureBuilder(
                future: storage.ref("MyCloud/${_auth.currentUser!.email.toString().replaceAll(".", "")}/music").listAll(),
                builder:(BuildContext context, AsyncSnapshot<ListResult> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return SizedBox(
                      height: size.height*.7,
                      child: Center(child: CircularProgressIndicator(color: Colors.white,)));
                  }

                  List storemusic = [];
                  snapshot.data!.items.forEach((e){
                    storemusic.add(e);
                  });
                  
                  List searchedmusic;
                  tosearchmusic(searchname){
                    searchedmusic = [];
                    storemusic.forEach((element) {
                      if(element.name.toString().contains(searchname)){
                        searchedmusic.add(element);
                      }
                    });
                    return searchedmusic;
                  }

                  // print(storemusic[0].root);
                  // print(snapshot.data!.items[0]);
                  
                  return ValueListenableBuilder(
                    valueListenable: searchmus,
                    builder: (BuildContext context, String value, Widget? child) {
                      return storemusic.isEmpty ? Center(child: "Nothing added yet".text.white.xl4.make().h(size.height*.3)) : ListView.builder(
                        itemCount: value.isNotEmpty? tosearchmusic(searchname).length :storemusic.length,
                        itemBuilder: (context,index){
                          return Container(
                            height:size.height*.07,
                            decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(20)
                            ),
                            width: size.width*.1,
                            child: Row(
                              children: [
                                10.widthBox,
                                Icon(Icons.insert_drive_file_outlined,color:Colors.black),
                                10.widthBox,
                                SingleChildScrollView(
                                  child: SizedBox(
                                    width: size.width*.5,
                                    child: value.isNotEmpty? tosearchmusic(searchname)[index].name.toString().text.make(): storemusic[index].name.toString().text.make()),
                                ),
                                IconButton(
                                  onPressed: () async{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: "Downloading...".toString().text.red400.make()));
                                    var res = await downloadmusic(value.isNotEmpty?tosearchmusic(searchname)[index].name : storemusic[index].name);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icon(Icons.download)
                                ),
                                IconButton(
                                  onPressed: () async{
                                    var res = await deletemusic(value.isNotEmpty?tosearchmusic(searchname)[index].name : storemusic[index].name);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icon(Icons.delete))
                              ],
                            ),
                          ).px(size.width*.07).py(3);
                        });
                    },
                  ); 
                },))
          ],
        ),
      )
    );
  }
}