import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/app/routes/app_routes.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

Widget productCard(data){
  return Container(
    height: Get.height*0.25,
    width: Get.width*0.37,
    //color: Colors.red,
      decoration: BoxDecoration(
        //border: BoxBorder.all(color: Colors.black38)
      ),
    child:Column(
      children: [

        Container(
          height: Get.height*0.15,
          width: Get.width,
          decoration: BoxDecoration(
            //color: Colors.green
          ),
          child: Stack(
            children: [
              Positioned(child: InkWell(
                onTap: ()=>Get.toNamed(AppRoutes.productScreen,arguments: "Product Name"),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CachedNetworkImage(
                    imageUrl: "https://milma.com/storage/products//April2023//OcDXueDoR1F5XgXwaUkT.png",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
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
              ),),



              // Plus button Add to cart
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                height: Get.height*0.05,
                width: Get.height*0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: BoxBorder.all(
                      color: HexColor(AppConstants.primaryColor),
                      style: BorderStyle.solid,width: 2)
                ),
                    child: Icon(CupertinoIcons.add,color: HexColor(AppConstants.primaryColor),),
              ))
            ],
          ),
        ),


        Row(
          children: [
            SizedBox(width: Get.width*0.02,),
            Container(
              height: Get.height*0.03,
                width: Get.width*0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HexColor(AppConstants.primaryColor),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3)
                  ),
                ]
              ),
                child: Text('${AppConstants.currencySymbol}'+"77",
                style: GoogleFonts.aBeeZee(color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: Get.height*0.018
                ),)),
            SizedBox(width: Get.width*0.02,),
            Text("${AppConstants.currencySymbol}88",style: GoogleFonts.poppins(decoration: TextDecoration.lineThrough,
            fontSize: Get.height*0.015),)
          ],
        ),

        InkWell(
          onTap: ()=>Get.toNamed(AppRoutes.productScreen,arguments: "Product Name"),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0,top: 5),
            child: Text("Product Name here with extra details & some",
              style: GoogleFonts.poppins(fontSize: Get.height*0.015,fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text("1 pc (500ml)",style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: Get.height*0.012
              ),),
            ],
          ),
        )
      ],
    )
  );
}