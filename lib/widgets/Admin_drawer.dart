import 'package:e_cart/screens/admin%20-panel/All_Order_screen.dart';
import 'package:e_cart/screens/admin%20-panel/all_product_screen.dart';
import 'package:e_cart/screens/admin%20-panel/alluserscreen.dart';
import 'package:e_cart/screens/user-panel/All-product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/google-sign-in-controller.dart';
import '../controllers/sign-in-controller.dart';
import '../screens/auth-ui/welcome_scrreen.dart';
import '../utils/app_constant.dart';

class adminDrawer extends StatefulWidget {
  const adminDrawer({super.key});

  @override
  State<adminDrawer> createState() => _adminDrawerState();
}

class _adminDrawerState extends State<adminDrawer> {
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  onTap: () => Get.to(() => AllUserScreen() ),
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('User',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.person,color: AppConstant.apptextcolor,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  onTap: () => Get.to(() => AllOrderScreen() ),

                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Orders',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.shopping_bag,color: AppConstant.apptextcolor,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  onTap: () => Get.to(() => AllProductScreen2() ),
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Product',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.shopping_cart_checkout,color: AppConstant.apptextcolor,),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Categories',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.category,color: AppConstant.apptextcolor,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text('Contect',style: TextStyle(color: AppConstant.apptextcolor),),
                  leading: Icon(Icons.call_outlined,color: AppConstant.apptextcolor,),
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
                    leading: Icon(Icons.logout,color: AppConstant.apptextcolor),
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
