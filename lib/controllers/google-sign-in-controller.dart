import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/controllers/get-device-token-contoller.dart';
import 'package:e_cart/models/user_model.dart';
import 'package:e_cart/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController{
  final GoogleSignIn googleSignIn  = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<void> signInWithGoogle() async{
    GetDeviceTokenController getDeviceTokenController =  Get.put(GetDeviceTokenController());
    try{
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if(googleSignInAccount != null){
        EasyLoading.show(status: 'please wait...');
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if(user!=null){
          UserModel userModel = UserModel(
              uID: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: getDeviceTokenController.deviceToken.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now());

          FirebaseFirestore.instance.
          collection('user').
          doc(user.uid).set(userModel.toMap());
          EasyLoading.dismiss();
          Get.offAll(() =>MainScreen() );
        }

      }
    }catch(e){
      EasyLoading.dismiss();
      print('error $e');
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
  }

}