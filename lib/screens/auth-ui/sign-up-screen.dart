import 'package:e_cart/controllers/sign-up-controller.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import 'sign-in-screen.dart';

class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  bool _passwordVisible = false;
  SignUpController signUpController = Get.put(SignUpController());
  TextEditingController userName = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
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
                title: Text('Sign Up',style: TextStyle(color: AppConstant.apptextcolor)),
                backgroundColor: AppConstant.appsecondaycolor,
                elevation: 0,
              ),
              body: Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Container(
                          alignment: Alignment.center,
                          child: SizedBox.shrink()),
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
                            controller: userName,
                            cursorColor: AppConstant.appsecondaycolor,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintText: 'Username',
                                prefixIcon: Icon(Icons.person),
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
                            controller: userPhone,
                            cursorColor: AppConstant.appsecondaycolor,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'phone',
                                prefixIcon: Icon(Icons.phone),
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
                            controller: userCity,
                            cursorColor: AppConstant.appsecondaycolor,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintText: 'City',
                                prefixIcon: Icon(Icons.location_pin),
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
                                suffixIcon:  IconButton(
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
                      SizedBox(height:20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppConstant.appsecondaycolor,
                        ),
                        height: 50,
                        width: 200,
                        child: TextButton(
                          child: Text('Sign Up',style: TextStyle(color: AppConstant.apptextcolor,fontSize: 20,)),
                          onPressed:  () async{
                            String name = userName.text.trim();
                            String email = userEmail.text.trim();
                            String phone = userPhone.text.trim();
                            String password = userPassword.text.trim();
                            String city = userCity.text.trim();
                            String userDevicesToken = ' ';

                            if(name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || city.isEmpty){
                              Get.snackbar("error", "please enter all details",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appsecondaycolor,
                                  colorText: AppConstant.apptextcolor);
                            }else{
                              UserCredential? userCredential = await signUpController.signUpMethod(
                                  name,
                                  email,
                                  phone,
                                  city,
                                  password,
                                  userDevicesToken);
                              if(userCredential != null){
                                Get.snackbar("verification email send",
                                    "please check email",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppConstant.appsecondaycolor,
                                    colorText: AppConstant.apptextcolor);
                                FirebaseAuth.instance.signOut();
                                Get.to(() =>signinscreen());
                              }
                            }

                          },),
                      ),
                      SizedBox(height:20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",style: TextStyle(color: AppConstant.appsecondaycolor,fontSize: 15)),
                          Text(" Sign in",style: TextStyle(color: AppConstant.appsecondaycolor,fontWeight: FontWeight.bold,fontSize: 15)),
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
