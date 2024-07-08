import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/product_model.dart';
import 'package:e_cart/screens/user-panel/product_detail_screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';

class AllProducScreen extends StatefulWidget {
  const AllProducScreen({super.key});

  @override
  State<AllProducScreen> createState() => _AllProducScreenState();
}

class _AllProducScreenState extends State<AllProducScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Products'),
           backgroundColor: AppConstant.appsecondaycolor,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: false).get(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('Error');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
                return Text('Product is not available');
              }
              if (snapshot.data != null){
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                    crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 0.85,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var product = snapshot.data!.docs[index];
                      productmodel _productmodel = productmodel(
                          productId: product['productId'],
                          categoryId: product['categoryId'],
                          productName: product['productName'],
                          categoryName: product['categoryName'],
                          salePrice: product['salePrice'],
                          fullPrice: product['fullPrice'],
                          productImages: product['productImages'],
                          deliveryTime: product['deliveryTime'],
                          isSale: product['isSale'],
                          productDescription: product['productDescription'],
                          createdAt: product['createdAt'],
                          updatedAt: product['updatedAt']);
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ProductDetailScreen(Productmodel: _productmodel));

                              },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,top: 5),
                              child: Container(
                                height: 300,
                                child: FillImageCard(
                                   borderRadius: 19,
                                    heightImage: 160,
                                    width: 150,
                                    title: Text(_productmodel.productName,overflow: TextOverflow.ellipsis),
                                    footer: Text('MRP: '+_productmodel.fullPrice),
                                    imageProvider:CachedNetworkImageProvider(_productmodel.productImages[0])),
                              ),
                            ),
                          ),
                        ],
                      );
                    },);
              }
              return Container();
            },),
      ),
    );
  }
}
