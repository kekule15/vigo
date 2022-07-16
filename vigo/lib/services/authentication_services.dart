
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vigo/utils/notify_me.dart';

class AuthServiceImplementation {
  final Reader reader;
  AuthServiceImplementation(this.reader) : super() {
   
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  CollectionReference admin = FirebaseFirestore.instance.collection('Users');
  //SIGN UP METHOD
  Future<User?> signUp(
      {required String email,
      required String password,
      required String name,
      required String number,
      required String picture}) async {
    try {
      final data = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      admin.doc(data.user!.uid).set({
        'timesStamp':DateTime.now().toString(),
        
        'email': email,
        'name': name,
        'phone': number,
        'picture': picture
      }).then((value) {
        Fluttertoast.showToast(
            msg: "User Added Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      });
      return data.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        NotifyMe.showAlert('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        NotifyMe.showAlert('Wrong password provided for this user.');
      } else if (e.code == 'email-already-in-use') {
        NotifyMe.showAlert('Email already in use');
      } else {
        print('error ooooo ${e.code}');
      }
    }
  }

//login method
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      final data = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // print(data);
      return data.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        NotifyMe.showAlert('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        NotifyMe.showAlert('Wrong password provided for this user.');
      }
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    // ignore: avoid_print
    print('signout');
  }

 
}
