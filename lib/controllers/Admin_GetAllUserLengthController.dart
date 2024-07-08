import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserLengthControlller extends GetxController{
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late StreamSubscription<QuerySnapshot<Map<String,dynamic>>> _usercontrolllersubscription;

final Rx<int> userCollectionLength = Rx<int>(0);

@override
  void onInit(){
  super.onInit();
      _usercontrolllersubscription = _firestore.collection('users')
          .where('isAdmin',isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
            userCollectionLength.value = snapshot.size;
      });
}
@override
  void onClose(){
  _usercontrolllersubscription.cancel();
  super.onClose();
}
}