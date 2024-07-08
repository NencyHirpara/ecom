import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../utils/app_constant.dart';

class ForgotPasswordController extends GetxController{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore  = FirebaseFirestore.instance;

  Future<void> ForgotPasswordMethod(
      String userEmail,
      )async {
    try{
      EasyLoading.show(status: 'please wait......');

      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar('Request send successfully', 'password reesr link send to $userEmail',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appsecondaycolor,
        colorText: AppConstant.apptextcolor,);
      EasyLoading.dismiss();

    }on FirebaseAuthException catch(e){
      EasyLoading.dismiss();
      Get.snackbar('error', '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appsecondaycolor,
        colorText: AppConstant.apptextcolor,);
    }
  }

}