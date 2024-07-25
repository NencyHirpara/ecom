import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/Categories-model.dart';
import 'package:e_cart/screens/user-panel/single-categary-prodect-screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';

import '../auth-ui/sign-in-screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Categories'),
          elevation: 0,
          backgroundColor: AppConstant.appsecondaycolor
          ,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('categories').get(),
            builder: ( BuildContextcontext, AsyncSnapshot<QuerySnapshot>snapshot) {
              if(snapshot.hasError){
                return Text('Error');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
                return Text('No categorie availabel');
              }
              if(snapshot.data != null){
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                crossAxisSpacing: 2,
                  mainAxisSpacing: 3,
                  childAspectRatio: 0.85),
                  shrinkWrap: true,
                 itemCount: snapshot.data!.docs.length,
                  physics: BouncingScrollPhysics(),

                  itemBuilder:(context, index) {
                    var product = snapshot.data!.docs[index];
                    CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: product['categoryId'],
                        categoryImg: product['categoryImg'],
                        categoryName: product['categoryName'],
                        createdAt: product['createdAt'],
                        updatedAt: product['updatedAt']);
                    return GestureDetector(
                      onTap:() {
                        Get.to(() =>AllSingleCategaryProduct(categoryId: categoriesModel.categoryId));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Apply border radius here
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: FillImageCard(
                            color: Colors.black12,
                            borderRadius: 20,
                            width: double.infinity ,
                            heightImage:160 ,
                            imageProvider: CachedNetworkImageProvider(categoriesModel.categoryImg),
                            title: Text(categoriesModel.categoryName),
                          ),
                        ),
                      ),
                    );
                  }, );
              }
              return Container();
            },),
      ),
    );
  }
}
