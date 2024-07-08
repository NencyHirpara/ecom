import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-panel/product_detail_screen.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: true).get(),
      builder: ( BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
        if(snapshot.hasError){
          return Center(child: Text('Error'));
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return CupertinoActivityIndicator();
        }
        if(snapshot.data!.docs.isEmpty){
          return Text('NO product available');
        }
        if(snapshot.data != null){
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

            child: Container(
              height: 250,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.horizontal,
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
                      updatedAt: product['createdAt']);
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () =>   Get.to(() => ProductDetailScreen(Productmodel: _productmodel)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 20,
                                width: 150,
                                heightImage:180,
                                imageProvider: CachedNetworkImageProvider(_productmodel.productImages[0]),
                            title: Text(_productmodel.productName,overflow: TextOverflow.ellipsis),
                              footer: Row(
                                children: [
                                   Text('RS:${_productmodel.salePrice}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500),),
                                  SizedBox(width: 4),
                                  Text('${_productmodel.fullPrice}',
                                    style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 10, color: Colors.red),)
                                ],
                              ),
                            ),

                          ),
                        ),
                      ),
                    ],
                  );
                },),
            ),
          );
        }
        return Container();
      },);
  }
}

