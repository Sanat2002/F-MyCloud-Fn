// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cloud_photos/screens/photos_screen.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';

class PhotoDetail extends StatefulWidget {
  final String name;
  const PhotoDetail({ Key? key,required this.name }) : super(key: key);

  @override
  _PhotoDetailState createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {

  final storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    await Permission.storage.request();
    // Permission.storage.status;
  }

  downloadphoto() async{

    // to download data in app user data
    // Directory appDocDir = await getApplicationDocumentsDirectory(); // getting document directory of local device
    // File tostorein = File("${appDocDir.path}/${widget.name}"); // making path(file) in local device to store(write) the todownloadfile 
    // print(appDocDir.path);

    // <----------------------------------------------------------------------->

    // to download data inside phones download folder
    // 1. add dependencies ->   ext_storage: ^1.0.3
                            // permission_handler: ^8.2.5

    // 2. add->  in src level manifest in  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    //           <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

    // 3. get permission of storage -> using getPermission() funct

    // 4. get phone's download folder path and then write to file

    // <------------------------------------------------------------------------>

    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");

    var path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    File tostorein = File("$path/${widget.name}");

    try{
      await storage.ref("MyCloud/$nemail/photos/${widget.name}").writeToFile(tostorein);
      return "Downloaded";
    } on FirebaseException catch(e){
      return "Download Failed";
    }
  }


  deletephoto() async{
    var nemail = _auth.currentUser!.email.toString().replaceAll(".", "");
    try{
      await storage.ref("MyCloud/$nemail/photos/${widget.name}").delete();
      return "Deleted";
    } on FirebaseException catch(e){
      return "Deletion Failed";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: [
            100.heightBox,
            FutureBuilder(
              future: storage.ref("MyCloud/${_auth.currentUser!.email.toString().replaceAll(".", "")}/photos/${widget.name}").getDownloadURL(),
              builder: (BuildContext context,AsyncSnapshot<String> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Container(
                    decoration: BoxDecoration(
                    color:Colors.black54,
                    borderRadius: BorderRadius.circular(50)
                    ),
                    height:size.height*.3 ,
                    width: size.width,
                    child: Center(child: CircularProgressIndicator(color: Colors.green,))
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                  color:Colors.black54,
                  borderRadius: BorderRadius.circular(50)
                  ),
                  height:size.height*.3 ,
                  width: size.width,
                  child: Image.network(snapshot.data!,).p(20)
                );
              }),
            50.heightBox,
            Row(
              children: [
                "Name = ${widget.name}".text.xl.make().px(8),
              ],
            ),
            60.heightBox,
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Vx.green500),
                shape: MaterialStateProperty.all(StadiumBorder())
              ),
              onPressed: () async{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: "Downloading...".toString().text.red400.make()));
                var res = await downloadphoto();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
              }, 
              child: "Download".text.xl2.make()
            ).wh(size.width*.7, size.height*.06),
            30.heightBox,
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                shape: MaterialStateProperty.all(StadiumBorder())
              ),
              onPressed: () async{
                var res = await deletephoto();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Photos()), (route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res.toString().text.red400.make()));
              }, 
              child: "Delete".text.xl2.make()
            ).wh(size.width*.7, size.height*.06)
        ],).p(20),
      ) ,
    );
  }
}