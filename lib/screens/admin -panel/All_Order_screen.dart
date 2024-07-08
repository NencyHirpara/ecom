import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Specific_customer_order_screen.dart';

class AllOrderScreen extends StatelessWidget {
  const AllOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Orders'),
          backgroundColor: AppConstant.appsecondaycolor,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('orders')
            .orderBy('createdAt',descending: true)
            .get(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('error');
              }
              if(snapshot.connectionState== ConnectionState.waiting){
                return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
                return Text('No Order found');
              }
              if(snapshot.data != null){
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,

                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                     return Card(
                       elevation: 5,
                       child: ListTile(
                         onTap: () => Get.to(() => SpecificCustomerOrderScreen(

                           docId : snapshot.data!.docs[index]['uid'],
                           customerName : snapshot.data!.docs[index]['customerName']
                         ) ),
                         leading: CircleAvatar(
                           backgroundColor: AppConstant.appsecondaycolor,
                         ),
                         title: Text(data['customerName']),
                         subtitle: Text(data['customerPhone']),
                       ),
                     ) ;
                    },
                );
              }
              return Container();
            },
        ),
      ),
    );
  }
}
