import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';

import '../models/product_model.dart';
import '../screens/user-panel/product_detail_screen.dart';

class AllProductWidget extends StatelessWidget {
  const AllProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: false).get(),
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
          return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            physics:BouncingScrollPhysics() ,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:2 ,
              crossAxisSpacing: 3,
              mainAxisSpacing:3 ,
              childAspectRatio: 0.85,
            ),
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
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailScreen(Productmodel: _productmodel));
                        },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,left: 15),
                        child: Container(
                          child: FillImageCard(
                            imageProvider: CachedNetworkImageProvider(_productmodel.productImages[0]),
                            width:160,
                            heightImage:150,
                            borderRadius: 20,
                            title: Center(child: Text(_productmodel.productName,overflow: TextOverflow.ellipsis,)),
                            footer: Center(
                              child: Text(
                                 "MRP:" +_productmodel.fullPrice,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },);
        }
        return Container();
      },);
  }
}


