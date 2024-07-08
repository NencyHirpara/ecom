import 'package:e_cart/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingtitle;
  final String headingsubtitle;
  final  VoidCallback onTap;
  final String buttonText;

   HeadingWidget({super.key,
     required this.headingtitle,
     required this.headingsubtitle,
     required this. onTap,
     required this.buttonText,
   });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headingtitle, style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold,fontSize: 17),),
                    SizedBox(height: 5),
                    Text(headingsubtitle,style: TextStyle(color: Colors.grey,),),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppConstant.appsecondaycolor ,width: 1.5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(buttonText,
                        style: TextStyle(fontWeight: FontWeight.w500,color: AppConstant.appsecondaycolor,fontSize: 12.5)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
