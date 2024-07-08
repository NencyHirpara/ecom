import 'package:e_cart/models/order-model.dart';
import 'package:e_cart/models/user_model.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckSingleOrder extends StatelessWidget {
  String docId;
  OrderModel orderModel;
   CheckSingleOrder({
    super.key,
    required this. docId,
    required this. orderModel});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(orderModel.customerName),
          backgroundColor: AppConstant.appsecondaycolor,
          elevation: 0,
        ),
        body:
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Center(child: Text(orderModel.productName,style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),)),
              SizedBox(height: 10,),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(orderModel.productImages[0]),),
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Details :',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      SizedBox(height: 10,),
                      Text('categoryName:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      Text(orderModel.categoryName,style: TextStyle(fontSize: 15)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          orderModel.isSale == true &&
                              orderModel.salePrice != ' '
                              ? Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'RS: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,fontSize: 16),
                                  ),
                                  Text(orderModel.salePrice,style: TextStyle(fontSize: 15)),
                                ],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                orderModel.fullPrice,
                                style: TextStyle(
                                    fontSize: 15,
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
                                      fontSize: 16
                                  )),
                              Text(orderModel.fullPrice),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text('productQuantity :',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      Text(orderModel.productQuantity.toString(),style: TextStyle(fontSize: 15)),
                      SizedBox(height: 10,),
                      Text('Total price:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      Text(orderModel.productTotalPrice.toString(),style: TextStyle(fontSize: 15),),
                      SizedBox(height: 10,),
                      Text('Discription :',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      Text(orderModel.productDescription,style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Details :',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10,),
                        Text('Customer Name:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                        Text(orderModel.customerName,style: TextStyle(fontSize: 15)),
                        SizedBox(height: 10,),
                        Text('customer phone number:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                        Text(orderModel.customerPhone,style: TextStyle(fontSize: 15)),
                        SizedBox(height: 10,),
                        Text('Category name: ',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                        Text(orderModel.categoryName,style: TextStyle(fontSize: 15)),
                        Text('Customer Address:'),
                        Text(orderModel.customerAddress,style: TextStyle(fontSize: 15),)

                      ],
                    )),
              ),],
          ),
        ),
      ),
    );
  }
}
