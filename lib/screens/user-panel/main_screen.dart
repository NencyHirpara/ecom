import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_cart/controllers/google-sign-in-controller.dart';
import 'package:e_cart/controllers/sign-in-controller.dart';
import 'package:e_cart/models/user_model.dart';
import 'package:e_cart/screens/auth-ui/welcome_scrreen.dart';
import 'package:e_cart/screens/user-panel/All-product_screen.dart';
import 'package:e_cart/screens/user-panel/all_categories.screen.dart';
import 'package:e_cart/screens/user-panel/all_flash_sale_product.dart';
import 'package:e_cart/screens/user-panel/cart_screen.dart';
import 'package:e_cart/utils/app_constant.dart';
import 'package:e_cart/widgets/All_product_widget.dart';
import 'package:e_cart/widgets/Flash_sale_widget.dart';
import 'package:e_cart/widgets/banner_widget.dart';
import 'package:e_cart/widgets/category_widget.dart';
import 'package:e_cart/widgets/category_widget.dart';
import 'package:e_cart/widgets/drawer%20widget.dart';
import 'package:e_cart/widgets/heading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appsecondaycolor,
          title:Text(AppConstant.appmainname),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => CartScreen());

              },
                icon: Icon(Icons.shopping_cart)),
          ],
        ),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 6),
                BannerWidger(),
                HeadingWidget(headingtitle:'categories',
                    headingsubtitle:'According to your budget' ,
                    onTap: () {
                      Get.to(() => AllCategoriesScreen() );

                    },
                    buttonText: 'see more >'),
                categoryWidget(),
                HeadingWidget(
                    headingtitle: 'Flash Sale',
                    headingsubtitle: 'According to your budget',
                    onTap: () {
                      Get.to(() =>AllFlashSaleProduct());

                    },
                    buttonText: 'See more >'),
                FlashSaleWidget(),
                HeadingWidget(headingtitle: 'All Product',
                    headingsubtitle:'According to your budget' ,
                    onTap: () {
                      Get.to(() =>AllProducScreen() );

                    },
                    buttonText: 'see more >'),
                AllProductWidget(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
