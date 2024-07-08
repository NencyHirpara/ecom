import 'package:e_cart/screens/auth-ui/sign-in-screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/google-sign-in-controller.dart';

class welcomescreem extends StatelessWidget {
   welcomescreem({super.key});

  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar:  AppBar(
          elevation: 0,
          backgroundColor: AppConstant.appsecondaycolor,
          title: Text('welcome to ecom_app'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color:AppConstant.appsecondaycolor,
                child: Lottie.asset('assets/image/sp.json'),
              ),
              SizedBox(height: 100,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppConstant.appsecondaycolor,
                ),
                height: 60,
                width: 300,
                child: TextButton.icon(
                  icon: Image.network('https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',height: 50,width: 50,),
                  label: Text('sign in with google',style: TextStyle(color: AppConstant.apptextcolor,fontSize: 20,)),
                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  }, ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppConstant.appsecondaycolor,
                ),
                height: 60,
                width: 300,
                child: TextButton.icon(
                  icon: Icon(Icons.email,color: AppConstant.apptextcolor,),
                  label: Text('sign in with email',style: TextStyle(color: AppConstant.apptextcolor,fontSize: 20,)),
                  onPressed: () {
                    Get.to(() =>signinscreen());
                  }, ),
              ),
            ],),
        ),
      ),
    );
  }
}
