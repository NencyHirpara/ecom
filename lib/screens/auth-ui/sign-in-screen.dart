import 'package:e_cart/controllers/get-user-data-controller.dart';
import 'package:e_cart/controllers/sign-in-controller.dart';
import 'package:e_cart/screens/admin%20-panel/admin-main-screen.dart';
import 'package:e_cart/screens/auth-ui/forgot_password_screen.dart';
import 'package:e_cart/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:e_cart/screens/auth-ui/sign-in-screen.dart';
import '../../utils/app_constant.dart';
import 'sign-up-screen.dart';

class signinscreen extends StatefulWidget {
  const signinscreen({super.key});
  @override
  State<signinscreen> createState() => _signinscreenState();
}
class _signinscreenState extends State<signinscreen> {
  bool _passwordVisible = false;
  SignInController signInController = Get.put(SignInController());
  GetUserDateContoller getUserDateContoller = Get.put(GetUserDateContoller());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: KeyboardVisibilityBuilder(
          builder: (context,isKeyboardVisible) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Sign In',style: TextStyle(color: AppConstant.apptextcolor)),
                backgroundColor: AppConstant.appsecondaycolor,
                elevation: 0,
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      isKeyboardVisible? Text('welcome',style: TextStyle(color: AppConstant.appsecondaycolor,fontWeight: FontWeight.bold,fontSize: 20),):
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
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: userPassword,
                            cursorColor: AppConstant.appsecondaycolor,
                            keyboardType: TextInputType.number,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                hintText: 'password',
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off,),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    }
                                ),
                                contentPadding: EdgeInsets.only(top: 2.0,left: 8.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap:  () => Get.to(() =>forgotpasswordscreen() ),
                            child: Text('Forgot password?',
                                style: TextStyle(
                                    color: AppConstant.appsecondaycolor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      SizedBox(height:20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppConstant.appsecondaycolor,
                        ),
                        height: 50,
                        width: 200,
                        child: TextButton(
                          child: Text('Sign In',style: TextStyle(color: AppConstant.apptextcolor,fontSize: 20,)),
                          onPressed: () async {
                            String email = userEmail.text.trim();
                            String password = userPassword.text.trim();

                            if ( email.isEmpty || password.isEmpty){
                              Get.snackbar('error', 'please enter all details');
                            }else{
                              UserCredential? userCredential = await signInController.signInMethod(email, password);
                              var userData = await getUserDateContoller.getUserData(userCredential!.user!.uid);
                              if(userCredential!= null){
                                if(userCredential.user!.emailVerified){
                                  if(userData[0]['isAdmin']==true){
                                    Get.snackbar('success', 'lodin successfully',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppConstant.appsecondaycolor,
                                      colorText: AppConstant.apptextcolor,);
                                    Get.offAll(() => AdminMainScreen());

                                  }else{
                                    Get.snackbar('success', 'lodin successfully',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppConstant.appsecondaycolor,
                                      colorText: AppConstant.apptextcolor,);
                                    Get.offAll(() => MainScreen());
                                  }

                                }else{
                                  Get.snackbar('error', 'please verify your email before login',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppConstant.appsecondaycolor,
                                    colorText: AppConstant.apptextcolor,);
                                }
                              }else{
                                Get.snackbar('error', 'please try again!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appsecondaycolor,
                                  colorText: AppConstant.apptextcolor,);
                              }
                            }
                          }, ),
                      ),
                      SizedBox(height:20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",style: TextStyle(color: AppConstant.appsecondaycolor,fontSize: 15)),
                          GestureDetector(
                            onTap: () => Get.to(() =>signupscreen() ),
                             // onTap: () {
                               // Navigator.push(context,MaterialPageRoute(builder: (context) => signupscreen(),));
                              //},ss
                              child: Text("  sign up",style: TextStyle(color: AppConstant.appsecondaycolor,fontWeight: FontWeight.bold,fontSize: 15))),
                        ],
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