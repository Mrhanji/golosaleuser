import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/utils/end_points.dart';
import '/app/routes/app_routes.dart';
import '/app/features/home/controller/home_controller.dart';
import '/app/features/home/widgets/category_card.dart';
import '/app/features/home/widgets/product_card.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class homeView extends StatelessWidget {
  final HomeController controller;
  const homeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header area - tappable to open address bottom sheet
          InkWell(
            onTap: ()=>controller.restCity(),
            child: Container(
              height: Get.height * 0.1,
              width: Get.width,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: Get.height * 0.04,
                    width: Get.height * 0.04,
                    decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.home, color: Colors.white),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Text("${controller.defaultCity.cityName}",style: GoogleFonts.poppins(fontSize: Get.height*0.02)),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  IconButton(onPressed: ()=>Get.toNamed(AppRoutes.searchScreen), icon: Icon(CupertinoIcons.search))
                ],
              ),
            ),
          ),

          // Carousel (unchanged)
          Obx(() {
            if (controller.isBannerLoading.value) {
              return SizedBox(
                height: Get.height * 0.3,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if(controller.bannerModel.data!.isEmpty){
              return SizedBox(
                height: Get.height * 0.3,
                child: const Center(child: Text("No banner found")),
              );
            }

            final items = List.generate(
              controller.bannerModel.data!.length,
                  (i) => CachedNetworkImage(
                imageUrl: EndPoints.mediaUrl(controller.bannerModel.data![i].bannerImageId.toString()),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      //  colorFilter:
                      //  ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );

            return SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider(
                  items: items,
                  options: CarouselOptions(
                    height: Get.height * 0.23,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                ),
              ),
            );
          }),

          // Category View
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("shop_by_category".tr +"🔥",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold,
                      fontSize: Get.height*0.02),),
                Text('- - - - - - - - - - - - - ',style: GoogleFonts.aBeeZee(color: Colors.grey.shade300),),
              ],
            ),
          ),

       Obx((){
         if(controller.isCategoryLoading.value){
           return CircularProgressIndicator();
         }
         if(controller.categoryModel.data!.isEmpty){
           return Text("No category found");
         }
         return    Container(
             height: Get.height*0.23,
             width: Get.width,
             padding: EdgeInsets.only(left: 5, right: 5),
             child:ListView.builder(
                 scrollDirection: Axis.horizontal,
                 shrinkWrap: true,
                 itemCount: controller.categoryModel.data?.length,
                 itemBuilder: (i,data)=> Padding(
                   padding: const EdgeInsets.only(right: 4.0,left: 4),
                   child: categoryCard(controller.categoryModel.data![data]),
                 )
             ));
       }),


          /// Popular items
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("popular_items".tr +"👏",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold,
                      fontSize: Get.height*0.02),),
                Text('- - - - - - - - - - - - - - - -',style: GoogleFonts.aBeeZee(color: Colors.grey.shade300),),
              ],
            ),
          ),

          Container(
              height: Get.height*0.26,
              width: Get.width,
              padding: EdgeInsets.only(left: 5, right: 5),
              child:ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 15,
                  itemBuilder: (i,data)=> Padding(
                    padding: const EdgeInsets.only(right: 4.0,left: 4),
                    child: productCard(data),
                  )
              )),


          Divider(),
          Text("Organic products, \ndelivered fresh...",
              textAlign: TextAlign.start,
              softWrap: true,
              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade200,
                  fontSize: Get.height*0.05)),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(AppConstants.appLogoOrganic),
          ),

          Text("Made with ❤️ by Golosale",
            textAlign: TextAlign.start,
            softWrap: true,
            style: GoogleFonts.b612(
                color: Colors.black38,
                fontSize: Get.height*0.015),
          )
        ],
      ),
    );
  }


}
