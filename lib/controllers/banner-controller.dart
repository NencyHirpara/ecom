import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class bannercontroller extends GetxController{
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit(){
    super.onInit();
    fetchBannerUels();
  }
  Future<void> fetchBannerUels()async {
    try{
      QuerySnapshot bannersSnapshot =
         await FirebaseFirestore.instance.collection('banners').get();

      if(bannersSnapshot.docs.isNotEmpty){
        bannerUrls.value = bannersSnapshot.docs.map((doc) => doc['imageUrl']as String).toList();
      }
    }catch(e){
      print( "error:$e");
    }
  }

}