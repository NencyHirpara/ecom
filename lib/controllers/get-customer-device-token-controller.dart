import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getCustomerDeviceToken() async{
  try{
    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      return token;
    }else{
      throw Exception('error');
    }
  }catch(e){
    print('error $e');
    throw Exception('error');
  }
}