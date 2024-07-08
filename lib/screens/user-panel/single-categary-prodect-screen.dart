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

class AllSingleCategaryProduct extends StatefulWidget {
  String categoryId ;
   AllSingleCategaryProduct({super.key , required this.categoryId});

  @override
  State<AllSingleCategaryProduct> createState() => _AllSingleCategaryProductState();
}

class _AllSingleCategaryProductState extends State<AllSingleCategaryProduct> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('product'),
          backgroundColor: AppConstant.appsecondaycolor,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('products').where('categoryId',isEqualTo: widget.categoryId).get(),
              builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('Error');
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
               return Text ('Product not found');
              }
              if(snapshot.data != null){
                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:2,
                    childAspectRatio: 0.85,
                      mainAxisSpacing: 4,
                      crossAxisSpacing:4,
                    ),
                    itemBuilder: (context, index) {
                      final product = snapshot.data!.docs[index];
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
                          onTap: () =>   Get.to(() => ProductDetailScreen(Productmodel: _productmodel)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0,top: 10.0),
                            child: Container(
                              height: 500,
                              child: FillImageCard(
                                borderRadius: 20,
                                  heightImage: 160,
                                  width:150,
                                  imageProvider: CachedNetworkImageProvider(_productmodel.productImages[0],),
                              title: Text(_productmodel.productName,overflow: TextOverflow.ellipsis,)),
                            ),
                          ),
                        )
                        ],
                      );
                    },);
              }
                return Container();
              }, ),
      ),
    );
  }
}
