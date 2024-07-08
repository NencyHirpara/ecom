import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/order-model.dart';
import 'package:e_cart/screens/admin%20-panel/Check_single_order_screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SpecificCustomerOrderScreen extends StatelessWidget {
  String customerName;
  String docId;

   SpecificCustomerOrderScreen({
    super.key,
    required this.docId,
    required this.customerName
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appsecondaycolor,
          title: Text(customerName),
        ),
        body:FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('orders')
                .doc(docId)
                .collection('confirmOrders')
                .orderBy('createdAt',descending: true)
            .get(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return  Text('Error');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
                return Text('order not available');
              }
              if(snapshot.data != null){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      String orderDocId = data.id;
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
                          createdAt: data['createdAt'],
                          updatedAt: data['updatedAt'],
                          productQuantity: data['productQuantity'],
                          productTotalPrice: data['productTotalPrice'],
                          customerId: data['customerId'],
                          status: data['status'],
                          customerName: customerName,
                          customerPhone: data['customerPhone'],
                          customerAddress: data['customerAddress'],
                          customerDeviceToken: data['customerDeviceToken']
                      );
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () => Get.to(() => CheckSingleOrder(

                              docId : snapshot.data!.docs[index].id,
                              orderModel : orderModel
                              //customerName : snapshot.data!.docs[index]['customerName']
                          ) ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(orderModel.productImages[0]),
                            //backgroundColor: AppConstant.appsecondaycolor,
                           //child: Text(customerName),
                          ),
                          title: Text(orderModel.productName),
                          trailing: IconButton(
                              onPressed: () {
                                ShowBottomSheet(
                                  userDocId : docId,
                                  orderModel:orderModel,
                                  orderDocId:orderDocId,
                                );
                              },
                              icon: Icon(Icons.more_vert_outlined),
                          ),
                          subtitle: Text('Total price: ${orderModel.productTotalPrice.toString()}'),
                        ),
                      );
                    },);

              }
              return Container();
            },) ,
      ),
    );
  }
}

void ShowBottomSheet({
  required String orderDocId,
  required String userDocId,
  required OrderModel orderModel}){
  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                FirebaseFirestore.instance
                 .collection('orders')
                  .doc(userDocId)
                  .collection('confirmOrders')
                   .doc(orderDocId)
                   .update({
      'status': false,
    });
              }, child: Text('panding')),
              ElevatedButton(
                  onPressed:() {
                    FirebaseFirestore.instance
                        .collection('orders')
                        .doc(userDocId)
                        .collection('confirmOrders')
                        .doc(orderDocId)
                        .update({
                      'status' : true ,
                    });
                  },
                  child: Text('Deliverder'))
            ],
          )
        ],
      ),
    )
  );
}