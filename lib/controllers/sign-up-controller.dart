import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/user_model.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?>signUpMethod(
      String userName,
      String userEmail,
      String userPhone,
      String userCity,
      String userPassword,
      String userDeviceToken,
      ) async{
    try{
      EasyLoading.show(status: "please wait...");

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );

      //sent email varification

      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          uID: userCredential.user!.uid,
          username: userName,
          email: userEmail,
          phone: userPhone,
          userImg: ' ',
          userDeviceToken: userDeviceToken,
          country: ' ',
          userAddress: ' ',
          street: ' ',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now());

     _firestore
      .collection('users')
      .doc(userCredential.user!.uid)
      .set(userModel.toMap());
      
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
}