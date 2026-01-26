import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/features/home/widgets/product_card.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search".tr,),
        centerTitle: true,
      ),
      body: SafeArea(child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height*0.01,),
            Container(
              height: Get.height*0.07,
              width: Get.width,
              padding: EdgeInsets.only(left: 10,right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                decoration: InputDecoration(
                    icon:Icon(CupertinoIcons.search),
                    hintText: "search_for_product".tr,
                    border: InputBorder.none
                ),
              ),

            ),


            /// Recent Searches
            SizedBox(height: Get.height*0.01,),
            Text("recent_search".tr,style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: Get.height*0.02)),
            Container(
              height: Get.height*0.07,
              width: Get.width,
              child: Wrap(
                spacing: 10,
                children: [
                  Chip(label: Text("Milk"),backgroundColor: Colors.grey.shade200,),
                  Chip(label: Text("Crud"),backgroundColor: Colors.grey.shade200,),
                  Chip(label: Text("Soap"),backgroundColor: Colors.grey.shade200,),
                  Chip(label: Text("Soap"),backgroundColor: Colors.grey.shade200,),

                ],
              ),
            ),


            /// Search Items in grid view

            Expanded(
                child: GridView.builder(
                    itemCount: 3,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.83,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15
                    ),
                    itemBuilder: (context,index){
                      return productCard(index);
                    }))
          ],),
      )),
    );
  }
}
