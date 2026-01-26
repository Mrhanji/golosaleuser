import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/end_points.dart';


class CitySelectionScreen extends StatelessWidget {
   CitySelectionScreen({super.key});
   HomeController homeController=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_city'.tr,)
      ),

      body: Obx((){
        if(homeController.isCityLoading.value){
          return Center(child: CircularProgressIndicator());
        }else{
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                childAspectRatio: (Get.width / 2) / (Get.height * 0.28),
              ),
              itemCount: homeController.cityModel.data!.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: ()=>homeController.setCity(index),
                    child: Container(
                      //height: Get.height*0.2,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.1,
                            blurRadius: 3,
                          )
                        ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CachedNetworkImage(
                            imageUrl: EndPoints.mediaUrl(homeController.cityModel.data![index].cityImageId.toString()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                          ),

                          Text("${homeController.cityModel.data![index].cityName}",
                          style: GoogleFonts.poppins(fontSize: Get.height*0.02,fontWeight: FontWeight.w600),
                          )


                          ]
                      ),
                    ),
                  ),
                );
              });
        }

      })
    );
  }
}
