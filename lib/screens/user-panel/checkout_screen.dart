import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/controllers/get-customer-device-token-controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../controllers/cart-price-controller.dart';
import '../../models/Cart_model.dart';
import '../../services/place-order-services.dart';
import '../../utils/app_constant.dart';
import '../auth-ui/splash_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController = Get.put(ProductPriceController());
  // for formate number 1,23,00
  var formmater = NumberFormat('#,##,000');
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

 Razorpay _razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return  MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('CheckOut'),
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
              return Text('product not found');
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
                                height:100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:  NetworkImage(cartModel.productImages[0]),)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cartModel.productName,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22)),
                                    SizedBox(height: 6,),
                                    Text(cartModel.categoryName,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                                    SizedBox(height: 6,),
                                    Text('RS: ${cartModel.isSale?
                                    cartModel.salePrice:cartModel.fullPrice}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),


                          Divider(thickness: 1),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,bottom: 5),
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
          child: Card(
            child: Container(
              height: 90,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 5,),
                        Text('Total',style: TextStyle(
                            fontWeight: FontWeight.w800
                        ),),
                        SizedBox(width: 280),
                        Obx(() =>  Text(
                          '\u20B9${ formmater.format( productPriceController.totalPrice.value)}',style: TextStyle(
                            fontWeight: FontWeight.w800
                        ),
                        ),),
                      ],
                    ),

                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        //   height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppConstant.appsecondaycolor
                        ),
                        child:TextButton(
                            onPressed: () {ShowCustomBottalSheet();},
                            child: Text('Confirm Order',style: TextStyle(color: AppConstant.apptextcolor),)),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Text('Total'),
        //         SizedBox(width: 30,),
        //         Obx(() =>  Text(
        //           formmater.format( productPriceController.totalPrice.value),
        //         ),),
        //         SizedBox(width: 110),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Container(
        //             width: 150,
        //             height: 40,
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //                 color: AppConstant.appsecondaycolor
        //             ),
        //             child: TextButton(
        //                 onPressed: () {
        //                   ShowCustomBottalSheet();
        //                 },
        //                 child: Text('Confirm Order',style: TextStyle(color: AppConstant.apptextcolor),)),
        //           ),
        //         )
        //       ],
        //     ),
        //
        //   ),
        // ),

      ),
    );
  }
  void ShowCustomBottalSheet(){
    Get.bottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 6,
        isDismissible: true,
        enableDrag: true,
        Container(
          height: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              color: Colors.white
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Container(
                    child: TextFormField(
                      controller:nameController ,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(

                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintStyle: TextStyle(
                            fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Container(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(

                        labelText: 'Phone',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintStyle: TextStyle(
                            fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Container(
                    child: TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(

                        labelText: 'Adress',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintStyle: TextStyle(
                            fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppConstant.appsecondaycolor,
                  ),
                  height: 50,
                  width: 200,
                  child: TextButton(
                      onPressed: () async{
                        if(nameController.text != ''
                            && phoneController.text != ''
                            && addressController.text != ''){
                          String name = nameController.text.trim();
                          String phone = phoneController.text.trim();
                          String address = addressController.text.trim();

                          String customerToken = await getCustomerDeviceToken();

                    //  String  amount =   formmater.format( productPriceController.totalPrice.value*100) as String;
                         // int amount = productPriceController.totalPrice.value * 100; // Razorpay expects amount in paise
                          int amount = (productPriceController.totalPrice.value * 100).toInt(); // Convert to int


                          var options = {
                            'key': 'rzp_test_YghCO1so2pwPnx',
                            'amount': amount,
                            'name': 'ECart',
                            'description': 'Fine T-Shirt',
                            'prefill': {
                              'contact': '8888888888',
                              'email': 'test@razorpay.com'
                            }
                          };

                          _razorpay.open(options);
                          // placeOrder(
                          //   context:context,
                          //   customerName : name,
                          //   customerPhone : phone,
                          //   customerAddress : address,
                          //   customerDeviceToken:customerToken,
                          // );

                        }else{
                          print('please fill all detail');
                          Get.snackbar('Error' , 'First fill the all details');
                        }
                      },
                      child: Text('Place Order',style: TextStyle(color: AppConstant.apptextcolor),)),
                )
              ],

            ),
          ),
        )
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Get user details for the order placement
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();
    String customerToken = await getCustomerDeviceToken();

    // Place the order
    placeOrder(
      context: context,
      customerName: name,
      customerPhone: phone,
      customerAddress: address,
      customerDeviceToken: customerToken,
    );

    // Delete the cart items after placing the order
    var cartCollection = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders');

    var snapshots = await cartCollection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    Get.snackbar('Success', 'Payment successful ');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    Get.snackbar('Error', 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
}
