import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cart/controllers/Admin_GetAllUserLengthController.dart';
import 'package:e_cart/models/user_model.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});
  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final GetUserLengthControlller _getUserLengthControlller = Get.put(GetUserLengthControlller());

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appsecondaycolor,
          title: Obx(() {
            return Text('users(${_getUserLengthControlller.userCollectionLength.toString()})');
          }),
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdOn',descending: true)
            .get(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('Erorr');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return CupertinoActivityIndicator();
              }
              if(snapshot.data!.docs.isEmpty){
                return Text('data not available');
              }
              if(snapshot.data != null){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                     physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index];
                    UserModel userModel = UserModel(
                        uID: data['uId'],
                        username: data['username'],
                        email: data['email'],
                        phone: data['phone'],
                        userImg: data['userImg'],
                        userDeviceToken: data['userDeviceToken'],
                        country: data['country'],
                        userAddress: data['userAddress'],
                        street: data['street'],
                        isAdmin: data['isAdmin'],
                        isActive: data['isActive'],
                        createdOn: data['createdOn']);
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              userModel.userImg,
                              errorListener: (err) {
                                print('error loding image');
                                Icon(Icons.error);
                              },
                            ),
                          ),
                          title: Text(userModel.username),
                          subtitle: Text(userModel.email),
                          trailing: Icon(Icons.edit),
                        ),
                      );
                    },);
              }
              return Container();
            },),
      ),
    );
  }
}
