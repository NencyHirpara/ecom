import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_cart/controllers/banner-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerWidger extends StatefulWidget {
  const BannerWidger({super.key});

  @override
  State<BannerWidger> createState() => _BannerWidgerState();
}

class _BannerWidgerState extends State<BannerWidger> {
  final CarouselController carouselController = CarouselController();
  final bannercontroller _bannerController = Get.put(bannercontroller());
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        child: Obx(() {
          return CarouselSlider(items: _bannerController.bannerUrls.map((imageUrls) =>
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
          child:CachedNetworkImage(
            imageUrl:imageUrls,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width/1.05,
          placeholder: (context, url) => ColoredBox(color: Colors.white,
              child: Center(
            child: CupertinoActivityIndicator(),
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),)
          )).toList(),
              options: CarouselOptions(
                 scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.3,
                viewportFraction: 1,
              ),);
        }),
      ),
    );
  }
}
