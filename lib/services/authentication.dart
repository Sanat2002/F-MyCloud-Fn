import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices{

  final _auth = FirebaseAuth.instance;

  // for signup
  Future<String> signupemail(email,password) async{
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser!.sendEmailVerification();
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return "Failed";
    }
  }

  // for signin
  Future<String> signinemail(email,password) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return "Failed";
    }
  }

  // signout
  Future<String> signout() async{
    try{
      await _auth.signOut();
      return "Success";
    } on FirebaseAuthException catch(e){
      return "Failed";
    }
  }

  // delete 
  Future<String> deleteuser() async{
    try{
      await _auth.currentUser!.delete();
      return "Success";
    } on FirebaseAuthException catch(e){
      if (e.code == 'requires-recent-login') {
        return 'ReSign';
      }
      return "Failed";
    }
  }

}