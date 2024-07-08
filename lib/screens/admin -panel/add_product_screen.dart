import 'dart:io';

import 'package:e_cart/controllers/Add_product_image_controller.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProducScreen extends StatelessWidget {
   AddProducScreen({super.key});
addProductImageController _addProductImageController = Get.put(addProductImageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstant.appsecondaycolor,
        title: Text('Add Product'),
      ),
      body: Container(
        child: Column(
            children: [
          Row(
            children: [
              Text('Select image'),
              ElevatedButton(
                  onPressed: () {
                _addProductImageController.showImagePikerDialog();
              }, child: Text('Select image')),
            ],
          ),
              GetBuilder<addProductImageController>(
                init: addProductImageController(),
                builder: (imagecontroller) {
                  return imagecontroller.selectedImages.length>0
                      ?Container(
                    height: 400,
                    width: 350,
                    child: GridView.builder(
                      itemCount: imagecontroller.selectedImages.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder:(BuildContext context,int index) {
                        return Stack(
                          children: [
                            Image.file(File(imagecontroller.selectedImages[index].path),
                              fit: BoxFit.cover,
                              height: 400,
                            ),
                            Positioned(
                                right: 10,
                                top: 0,
                                child: CircleAvatar(
                                  backgroundColor: AppConstant.appsecondaycolor,
                                  child: InkWell(
                                    onTap:(){
                          imagecontroller.removeImages(index);
                        },
                                      child: Icon(Icons.close_rounded)),
                                ),),
                          ],);
                      }, ),
                  ):SizedBox();
                },)
        ]),
      ),
    );
  }
}
