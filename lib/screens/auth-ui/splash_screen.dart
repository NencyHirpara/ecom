import 'dart:async';
import 'package:e_cart/controllers/get-user-data-controller.dart';
import 'package:e_cart/screens/admin%20-panel/admin-main-screen.dart';
import 'package:e_cart/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_constant.dart';
import 'welcome_scrreen.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});
  @override
  State<splashscreen> createState() => _splashscreenState();
}
User? user = FirebaseAuth.instance.currentUser;
class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:3), (){
      loggdin(context);
    });
  }
  Future<void> loggdin(BuildContext context)async{
    if(user != null){
      final GetUserDateContoller getUserDateContoller = Get.put(GetUserDateContoller());
      var userdata = await getUserDateContoller.getUserData(user!.uid);
      if(userdata[0]['isAdmin']== true){
        Get.offAll(() =>MainScreen());

      }else{
        Get.offAll(() => MainScreen());
      }
    }else{
      Get.offAll(() => MainScreen());

    }
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor:AppConstant.appsecondaycolor,
        appBar: AppBar(
          backgroundColor:AppConstant.appsecondaycolor,
          elevation: 0,
        ),
        body: Center(
          child: Container(
            child: Lottie.asset('assets/image/sp.json',width: 300,height: 300),
          ),
        ),
      ),
    );
  }
}

