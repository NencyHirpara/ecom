import 'package:e_cart/models/product_model.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleProductDetailScreen2 extends StatelessWidget {
  productmodel productModel;
   SingleProductDetailScreen2({
    super.key,
 required this.productModel,
   });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
            title: Text(productModel.productName),
           backgroundColor: AppConstant.appsecondaycolor,
        ),
        body:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Center(child: Text(productModel.productName,style: TextStyle(fontSize:20,fontWeight: FontWeight.w600),)),
              SizedBox(height: 10,),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(productModel.productImages[0]),),
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
                      Text(productModel.categoryName,style: TextStyle(fontSize: 15)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          productModel.isSale == true &&
                              productModel.salePrice != ' '
                              ? Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'RS: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,fontSize: 16),
                                  ),
                                  Text(productModel.salePrice,style: TextStyle(fontSize: 15)),
                                ],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                productModel.fullPrice,
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
                              Text(productModel.fullPrice),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text('Discription :',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      Text(productModel.productDescription,style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
