import 'package:e_cart/widgets/Admin_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_constant.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: AppConstant.appsecondaycolor,
          title: Text('admin screen'),
        ),
        drawer: adminDrawer(),
      ),
    );
  }
}
