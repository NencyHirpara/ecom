import 'package:e_cart/controllers/forget-password-controller.dart';
import 'package:e_cart/controllers/sign-in-controller.dart';
import 'package:e_cart/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_constant.dart';
import 'sign-up-screen.dart';

class forgotpasswordscreen extends StatefulWidget {
  const forgotpasswordscreen({super.key});
  @override
  State<forgotpasswordscreen> createState() => _forgotpasswordscreenstate();
}
class _forgotpasswordscreenstate extends State<forgotpasswordscreen> {

ForgotPasswordController _forgotPasswordController = Get.put(ForgotPasswordController());
  TextEditingController userEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: KeyboardVisibilityBuilder(
          builder: (context,isKeyboardVisible) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Forgot password',style: TextStyle(color: AppConstant.apptextcolor)),
                backgroundColor: AppConstant.appsecondaycolor,
                elevation: 0,
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      isKeyboardVisible? Text('',style: TextStyle(color: AppConstant.appsecondaycolor,fontWeight: FontWeight.bold,fontSize: 20),):
                      Column(
                        children: [
                          Container(
                              width: double.infinity,
                              color: AppConstant.appsecondaycolor,
                              child: Lottie.asset('assets/image/sp.json')),
                        ],
                      ),
                      SizedBox(height:20),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: userEmail,
                            cursorColor: AppConstant.appsecondaycolor,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height:50),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppConstant.appsecondaycolor,
                        ),
                        height: 50,
                        width: 200,
                        child: TextButton(
                          child: Text('Forgot',style: TextStyle(color: AppConstant.apptextcolor,fontSize: 20,)),
                          onPressed: () async {
                            String email = userEmail.text.trim();
                            if ( email.isEmpty){
                              Get.snackbar('error', 'please enter all details');
                            }else{
                              String email = userEmail.text.trim();
                              _forgotPasswordController.ForgotPasswordMethod(email);
                            }
                          }, ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}