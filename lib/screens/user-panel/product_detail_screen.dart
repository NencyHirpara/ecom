import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/Cart_model.dart';
import 'package:e_cart/models/product_model.dart';
import 'package:e_cart/screens/auth-ui/splash_screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  productmodel Productmodel;

  ProductDetailScreen({super.key, required this.Productmodel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.Productmodel.productName),
          backgroundColor: AppConstant.appsecondaycolor,
          elevation: 0,
          actions: [IconButton(
              onPressed: () {
                Get.to(() => CartScreen());

              }, icon: Icon(Icons.shopping_cart))],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                    items: widget.Productmodel.productImages
                        .map(
                          (imageurls) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: imageurls,
                              fit: BoxFit.cover,
                              width: 380,
                              placeholder: (context, url) => ColoredBox(
                                  color: Colors.white,
                                  child: Center(
                                      child: CupertinoActivityIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 1,
                        aspectRatio: 2.5,
                        autoPlay: true,
                        height: 400)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(widget.Productmodel.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                widget.Productmodel.isSale == true &&
                                        widget.Productmodel.salePrice != ' '
                                    ? Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'RS: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              Text(widget.Productmodel.salePrice),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            widget.Productmodel.fullPrice,
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.red),
                                          )
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text('RS: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(widget.Productmodel.fullPrice),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Text('Category: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(widget.Productmodel.categoryName),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(widget.Productmodel.productDescription),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppConstant.appsecondaycolor,
                                ),
                                child: TextButton(
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    Get.snackbar('${widget.Productmodel.productName} added to cart','',
                                      backgroundColor: AppConstant.appsecondaycolor,
                                      colorText: AppConstant.apptextcolor,
                                      duration: Duration(seconds: 5),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );

                                    await CheckproductExistance(uId: user!.uid);

                                    Get.to(() => CartScreen());

                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 50,
                                width: 170,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppConstant.appsecondaycolor),
                                child: TextButton(
                                    onPressed: () {

                                    },
                                    child: Text(
                                      'share',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  //check prouduct exist or not
 Future<void> CheckproductExistance({
    required String uId,
    int quntityincrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.Productmodel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updateQuantity = currentQuantity + quntityincrement;

      double totalPrice = double.parse(widget.Productmodel.isSale
              ? widget.Productmodel.salePrice
              : widget.Productmodel.fullPrice) *
          updateQuantity;


      await documentReference.update({
        'productQuantity': updateQuantity,
        'productTotalPrice': totalPrice,
      });
      print('product exist');
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });
      CartModel cartModel = CartModel(
          productId: widget.Productmodel.productId,
          categoryId: widget.Productmodel.categoryId,
          productName: widget.Productmodel.productName,
          categoryName: widget.Productmodel.categoryName,
          salePrice: widget.Productmodel.salePrice,
          fullPrice: widget.Productmodel.fullPrice,
          productImages: widget.Productmodel.productImages,
          deliveryTime: widget.Productmodel.deliveryTime,
          isSale: widget.Productmodel.isSale,
          productDescription: widget.Productmodel.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: 1,
          productTotalPrice: double.parse(widget.Productmodel.isSale
              ? widget.Productmodel.salePrice
              : widget.Productmodel.fullPrice));

      await documentReference.set(cartModel.toMap());
      print('product added');
    }
  }
}
