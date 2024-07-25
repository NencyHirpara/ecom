import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImageProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/models/Categories-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-panel/single-categary-prodect-screen.dart';

class categoryWidget extends StatelessWidget {
  const categoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text('error'),
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              height: Get.height / 5,
               child: Center(
                 child: CupertinoActivityIndicator(),
               ),
            );
          }
          if(snapshot.data!.docs.isEmpty){
            return Center(
              child: Text('No category found!'),
            );
          }
          if(snapshot.data != null){
            return Container(
            //  padding: EdgeInsets.only(top: 20,bottom: 20),
             height: 150,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                  CategoriesModel categoriesModel = CategoriesModel(
                      categoryId: snapshot.data!.docs[index]['categoryId'],
                      categoryImg: snapshot.data!.docs[index]['categoryImg'],
                      categoryName: snapshot.data!.docs[index]['categoryName'],
                      createdAt: snapshot.data!.docs[index]['createdAt'],
                      updatedAt: snapshot.data!.docs[index]['updatedAt']);
                    return Row(
                     children: [
                       GestureDetector(
                         onTap: () {
                           Get.to(() =>AllSingleCategaryProduct(categoryId: categoriesModel.categoryId));

                         },
                         child: SizedBox(
                           width: 120,
                           child: TransparentImageCard(
                             borderRadius: 15.0,
                             width: 100,
                             height:150,
                             tagSpacing: 10,
                             contentMarginTop: 90,
                             imageProvider:CachedNetworkImageProvider(
                               categoriesModel.categoryImg,
                             ),
                             title: Center(child: Text(categoriesModel.categoryName,overflow: TextOverflow.ellipsis,
                             style: TextStyle(color:Colors.white),)),
                           ),
                         ),
                       )
                     ],
                    );
                  },
              ),
            );
          }
          return Container();
        },
    );
  }
}
