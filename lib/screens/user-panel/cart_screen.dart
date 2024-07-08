import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/controllers/cart-price-controller.dart';
import 'package:e_cart/models/Cart_model.dart';
import 'package:e_cart/screens/user-panel/checkout_screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
 final ProductPriceController productPriceController = Get.put(ProductPriceController());

 // for formate number 1,23,00
  var formmater = NumberFormat('#,##,000');
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
            title: Text(' My cart'),
          backgroundColor: AppConstant.appsecondaycolor,
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore
              .instance
            .collection('cart')
              .doc(user!.uid)
              .collection('cartOrders')
            .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
          if(snapshot.hasError){
            return Text('error');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return CupertinoActivityIndicator();
          }
          if(snapshot.data!.docs.isEmpty){
            return Center(child: Text('product not found!',style: TextStyle(fontWeight: FontWeight.w500),));
          }
          if(snapshot.data != null){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                var prodect = snapshot.data!.docs[index];
                CartModel cartModel = CartModel(
                    productId: prodect['productId'],
                    categoryId: prodect['categoryId'],
                    productName: prodect['productName'],
                    categoryName: prodect['categoryName'],
                    salePrice: prodect['salePrice'],
                    fullPrice: prodect['fullPrice'],
                    productImages: prodect['productImages'],
                    deliveryTime: prodect['deliveryTime'],
                    isSale: prodect['isSale'],
                    productDescription: prodect['productDescription'],
                    createdAt: prodect['createdAt'],
                    updatedAt: prodect['updatedAt'],
                    productQuantity: prodect['productQuantity'],
                    productTotalPrice: prodect['productTotalPrice']);


                productPriceController.fetchProductPrice();


                  return SwipeActionCell(
                    key:ObjectKey(cartModel.productId),
                      trailingActions: [
                        SwipeAction(
                          forceAlignmentToBoundary: true,
                          performsFirstActionWithFullSwipe: true,
                          title:'Delete',
                          color: Colors.red.shade800,
                          onTap: ( CompletionHandler handler) async{
                            await FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').doc(cartModel.productId).delete();
                        },)
                      ],
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      elevation: 5,
                      child: Column(
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height:130,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:  NetworkImage(cartModel.productImages[0]),fit: BoxFit.contain,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cartModel.productName, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22),overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 6),
                                    Text(cartModel.categoryName,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                                    SizedBox(height: 5,),
                                    Text('RS: ${cartModel.isSale?
                                    cartModel.salePrice:cartModel.fullPrice}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () async{
                                          if(cartModel.productQuantity>0){
                                            await FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(user!.uid)
                                                .collection('cartOrders')
                                                .doc(cartModel.productId).update({
                                              'productQuantity' : cartModel.productQuantity + 1,
                                              'productTotalPrice' : (double.parse
                                                (cartModel.isSale?cartModel.salePrice:cartModel.fullPrice) * (cartModel.productQuantity + 1)
                                              )});
                                          }
                                        }, icon: Icon(Icons.add) ,color: AppConstant.appsecondaycolor,iconSize: 30),

                                        Text(cartModel.productQuantity.toString(),style: TextStyle(color: Colors.black,fontSize: 20)),
                                        IconButton(onPressed: () async{
                                          if(cartModel.productQuantity>1){
                                            FirebaseFirestore.instance.collection('cart')
                                                .doc(user!.uid)
                                                .collection('cartOrders')
                                                .doc(cartModel.productId)
                                                .update({
                                              'productQuantity' : cartModel.productQuantity - 1,
                                              'productTotalPrice': (double.parse( cartModel.isSale?cartModel.salePrice:cartModel.fullPrice)*
                                                  (cartModel.productQuantity-1)),
                                            });
                                          }
                                        }, icon: Icon(Icons.remove),color: AppConstant.appsecondaycolor,iconSize: 30),


                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),


                          Divider(thickness: 1),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6,left: 8.0),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('Total Order'),
                                  SizedBox(width: 4),
                                  Text('(${cartModel.productQuantity})'),
                                  SizedBox(width:220),
                                  Text(
                                      formmater.format(cartModel.productTotalPrice),
                                      style: TextStyle(fontSize:15,fontWeight: FontWeight.w800)
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },);
          }
          return Container();

            },),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Total'),
                SizedBox(width: 30,),
                Obx(() =>  Text(
                  formmater.format( productPriceController.totalPrice.value),
                ),),
                SizedBox(width: 110),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    height: 40,
                   decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                     color: AppConstant.appsecondaycolor
                   ),
                    child: TextButton(
                      onPressed: () {
                           Get.to(() => CheckOutScreen() );
                      },
                        child: Text('CheckOut',style: TextStyle(color: AppConstant.apptextcolor),)),
                  ),
                )
              ],
            ),

          ),
        ),

      ),
    );
  }
}



/*ListTile(
leading: CircleAvatar(
radius: 35,
backgroundImage: NetworkImage(cartModel.productImages[0]),
),
title:
Text(cartModel.productName,style: TextStyle(fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding: const EdgeInsets.only(left: 8,top: 4),
child: Text(cartModel.categoryName,style: TextStyle(fontWeight: FontWeight.w400)),
),
Row(
children: [
IconButton(onPressed: () async{
if(cartModel.productQuantity>0){
await FirebaseFirestore.instance
    .collection('cart')
    .doc(user!.uid)
    .collection('cartOrders')
    .doc(cartModel.productId).update({
'productQuantity' : cartModel.productQuantity + 1,
'productTotalPrice' : (double.parse
(cartModel.isSale?cartModel.salePrice:cartModel.fullPrice) * (cartModel.productQuantity + 1)
)});
}
}, icon: Icon(Icons.add) ,color: AppConstant.appsecondaycolor),

Text(cartModel.productQuantity.toString(),style: TextStyle(color: Colors.black)),
IconButton(onPressed: () async{
if(cartModel.productQuantity>1){
FirebaseFirestore.instance.collection('cart')
    .doc(user!.uid)
    .collection('cartOrders')
    .doc(cartModel.productId)
    .update({
'productQuantity' : cartModel.productQuantity - 1,
'productTotalPrice': (double.parse( cartModel.isSale?cartModel.salePrice:cartModel.fullPrice)*
(cartModel.productQuantity-1)),
});
}
}, icon: Icon(Icons.remove),color: AppConstant.appsecondaycolor),


],
),
],
),
trailing: Container(
child: Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
Text(cartModel.isSale?
cartModel.salePrice:cartModel.fullPrice,style: TextStyle(fontSize: 10)),
Text(cartModel.productQuantity.toString(),style: TextStyle(fontSize: 10)),
SizedBox(height: 3),
Text(
formmater.format(cartModel.productTotalPrice),
style: TextStyle(fontSize:13,fontWeight: FontWeight.w500)
//cartModel.productTotalPrice.toString(),style: TextStyle(fontSize:13,fontWeight: FontWeight.w500)
),
],
),
),
),*/