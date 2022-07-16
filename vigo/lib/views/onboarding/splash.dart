import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vigo/utils/constants.dart';
import 'package:vigo/views/home/navigation_page.dart';
import 'package:vigo/views/onboarding/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timer();
  }

  @override
  void dispose() {
    timer();
    super.dispose();
  }

  timer() async {
    return FirebaseAuth.instance.authStateChanges().listen((User? user) {
      Get.offAll(() => user == null ? const Login() : const HomeNavigation());
    });
  }



  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:const  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Constants.color1,
              Constants.color2,
            ],
          ),
        ),
        child:const Center(
          child:  Text('Vigo')
        ),
      ),
    );
  }
}
