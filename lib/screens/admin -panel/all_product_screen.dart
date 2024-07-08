import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/product_model.dart';
import 'package:e_cart/screens/admin%20-panel/add_product_screen.dart';
import 'package:e_cart/screens/admin%20-panel/single_product_detail_screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'alluserscreen.dart';

class AllProductScreen2 extends StatefulWidget {
  const AllProductScreen2({super.key});

  @override
  State<AllProductScreen2> createState() => _AllProductScreen2State();
}

class _AllProductScreen2State extends State<AllProductScreen2> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Product'),
          backgroundColor: AppConstant.appsecondaycolor,
          actions: [
            IconButton(
                onPressed: () => Get.to(() => AddProducScreen() ),
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt',descending: true)
            .get(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('Error');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
               return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
               return Text('Product not available');
              }
              if(snapshot.data != null ){
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      productmodel productModel = productmodel(
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
                          updatedAt: data['updatedAt']
                      ) ;
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () => Get.to(() =>SingleProductDetailScreen2 (
                            productModel:productModel,
                          ) ),
                          leading: CircleAvatar(backgroundImage: NetworkImage(productModel.productImages[0])),
                          title: Text(productModel.productName),
                          subtitle: Text(productModel.categoryName),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },);
              }
              return Container();
            },),
      ),
    );
  }
}
