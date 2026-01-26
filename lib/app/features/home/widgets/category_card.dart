import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';


Widget categoryCard(data){
  return Container(
    height: Get.height*0.2,
    width: Get.width*0.37,
    child: Card(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: CachedNetworkImage(
              imageUrl: "https://5.imimg.com/data5/GLADMIN/Default/2022/6/GK/VL/KG/76773753/shree-all-diary-product-500x500.jpeg",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                      colorFilter:
                      ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                ),
              ),
              height: Get.height*0.15,
              placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text("Category Title ${data}",style: GoogleFonts.poppins(
              fontSize: Get.height*0.015,
              fontWeight: FontWeight.w500,
            ),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text("Category info ${(data/5)}",style: GoogleFonts.poppins(
              fontSize: Get.height*0.012,
            ),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    ),
  );
}