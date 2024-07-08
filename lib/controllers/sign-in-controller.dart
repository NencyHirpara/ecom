import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/user_model.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?>signInMethod(

    String userEmail,
      String userPassword,
      ) async{
    try{
      EasyLoading.show(status: "please wait...");

      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );
      EasyLoading.dismiss();
      return userCredential;


    } on FirebaseAuthException catch(e){
      EasyLoading.dismiss();
      Get.snackbar("Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appsecondaycolor,
        colorText: AppConstant.apptextcolor,
      );
    }
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }

}