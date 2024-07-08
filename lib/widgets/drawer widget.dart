import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/google-sign-in-controller.dart';
import '../controllers/sign-in-controller.dart';
import '../screens/auth-ui/welcome_scrreen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());
  final SignInController _signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Drawer(
          backgroundColor: AppConstant.appsecondaycolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Wrap(
            runSpacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('E_cart',style: TextStyle(color: AppConstant.apptextcolor),),
                  subtitle: Text('version:1.0.1',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppConstant.appmaincolor,
                    child: Text('E',style: TextStyle(fontWeight: FontWeight.w500),),
                  ),
                ),
              ),
              Divider(
                indent: 10.0,
                endIndent: 10.0,
                thickness: 1.5,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Home',style:TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.home,color: AppConstant.apptextcolor,),
                  trailing: Icon(Icons.arrow_forward_outlined,color: AppConstant.apptextcolor,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('product',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.production_quantity_limits,color: AppConstant.apptextcolor,),
                  trailing: Icon(Icons.arrow_forward_outlined,color: AppConstant.apptextcolor,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: GestureDetector(
                  onTap: () {
                    //Get.offAll(() => allOrderScreen() );

                  },
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text('Order',style: TextStyle(color: AppConstant.apptextcolor),),
                    leading: Icon(Icons.shopping_bag,color: AppConstant.apptextcolor,),
                    trailing: Icon(Icons.arrow_forward_outlined,color: AppConstant.apptextcolor,),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Contact',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.person,color: AppConstant.apptextcolor,),
                  trailing: Icon(Icons.arrow_forward_outlined,color: AppConstant.apptextcolor,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: GestureDetector(
                  onTap:
                    () async {
                  //-------Here we create new object of googleSignIn for sign Out, but actual object of googleSignIn(which onw we create in GoogleSignInController()) is still signIn in controller-------//
                  /*GoogleSignIn googleS
                  ignIn = GoogleSignIn();
                  await googleSignIn.signOut();*/

                  //-------We have to signOut, actual object of google sign in(which we create in GoogxleSignInController())-------//
                  await _googleSignInController.signOut();

                  await _signInController.signOut();
                  Get.offAll(() => welcomescreem() );

                },
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text('Logout',style: TextStyle(color: AppConstant.apptextcolor),),
                    leading: Icon(Icons.logout),
                    trailing: Icon(Icons.arrow_forward_outlined,color: AppConstant.apptextcolor,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
