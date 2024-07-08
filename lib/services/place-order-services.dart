import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/Cart_model.dart';
import 'package:e_cart/models/order-model.dart';
import 'package:e_cart/screens/user-panel/main_screen.dart';
import 'package:e_cart/services/genret-order-id-service.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerAddress,
  required String customerPhone,
  required String customerDeviceToken
})async{
final user = FirebaseAuth.instance.currentUser;
EasyLoading.show(status: 'please wait');
if(user != null){
  try{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection( 'cartOrders').get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for(var doc in documents){
      Map<String,dynamic>?  data = doc.data() as Map<String,dynamic>;

      String orderId = genretOrderId();

      OrderModel orderModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: data['productTotalPrice'],
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken
      );

       for(var x=0; x<documents.length; x++ ){
         await FirebaseFirestore.instance.collection('orders').doc(user.uid).set({
           'uid': user.uid,
           'customerName':customerName,
           'customerPhone': customerPhone,
           'customerAddress': customerAddress,
           'customerDeviceToken': customerDeviceToken,
           'status': false,
           'createdAt': DateTime.now(),
         }
         );
         //upload order
         await FirebaseFirestore.instance
             .collection('orders')
             .doc(user.uid)
             .collection('confirmOrders')
             .doc(orderId)
             .set(orderModel.toMap());
         
         //delete cart model 
         await FirebaseFirestore.instance
             .collection('cart')
             .doc(user.uid)
             .collection('cartOrders')
             .doc(orderModel.productId.toString())
         .delete();
       }
    }
    Get.snackbar('Order complete', 'Thankyou for order!',
    snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 4),
      backgroundColor: AppConstant.appsecondaycolor,
      colorText: AppConstant.apptextcolor,
    );
    EasyLoading.dismiss();
     Get.to(() => MainScreen());

  }catch(e){
    print('error $e');
  }
}
}