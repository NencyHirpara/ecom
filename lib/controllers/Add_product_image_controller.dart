
import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class addProductImageController extends GetxController{
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<String> arrImagesUrl = <String>[].obs;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagePikerDialog() async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    if(androidDeviceInfo.version.sdkInt <= 32){
      status = await Permission.storage.request();
    }
    else{
      status = await Permission.mediaLibrary.request();
    }
    if(status == PermissionStatus.granted){
      Get.defaultDialog(
        title: 'Choose image',
        middleText: 'Pick an image from the camera or gallary',
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppConstant.appsecondaycolor)
            ),
              onPressed: () {
              selectImages('camera');
              },
              child: Text('Camera')),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppConstant.appsecondaycolor)
              ),
              onPressed: () {
                selectImages('gallary');
          }, child: Text('Gallary')),
        ]
      );
    }
    if(status == PermissionStatus.denied){
      Get.snackbar('allow permission', 'please allow permission to further useges');
      openAppSettings();
    }
    if(status == PermissionStatus.permanentlyDenied){
      Get.snackbar('allow permission', 'please allow permission to further useges');
      openAppSettings();
    }
  }

  Future<void> selectImages(String type) async {
    List<XFile> imgs =[];
    if(type == 'gallary'){
      try{
        imgs = await _picker.pickMultiImage(imageQuality: 80);
        update();
      }catch(e){
        print('error$e');
      } 
    }
    else{
      final img = await _picker.pickImage(source: ImageSource.camera,imageQuality: 80);
      if(img != null){
        imgs.add(img);
        update();
      }
    }
    if(imgs.isNotEmpty){
      selectedImages.addAll(imgs);
      update();
      print(selectedImages.length);
    }

  }
  void removeImages(int index){
    selectedImages.removeAt(index);
    update();
  }

}