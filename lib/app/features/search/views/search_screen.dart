import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/search/model/products_model.dart';
import '../controller/search_controller.dart';
import '/app/features/home/widgets/product_card.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  ProductSearchController searchController = Get.put(ProductSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("search".tr), centerTitle: true),
      body: GetBuilder(
        init: searchController,
        builder: (context) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.01),
                  Container(
                    height: Get.height * 0.07,
                    width: Get.width,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: TextEditingController(),
                      onSubmitted: (value) =>
                          searchController.startSearching(value),
                      keyboardType: TextInputType.webSearch,
                      decoration: InputDecoration(
                        icon: Icon(CupertinoIcons.search),
                        hintText: "search_for_product".tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// Recent Searches
                  // SizedBox(height: Get.height * 0.01),
                  // Text(
                  //   "recent_search".tr,
                  //   style: GoogleFonts.aBeeZee(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: Get.height * 0.02,
                  //   ),
                  // ),
                  // Container(
                  //   height: Get.height * 0.07,
                  //   width: Get.width,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     children: [
                  //       Chip(
                  //         label: Text("Milk"),
                  //         backgroundColor: Colors.grey.shade200,
                  //       ),
                  //       Chip(
                  //         label: Text("Crud"),
                  //         backgroundColor: Colors.grey.shade200,
                  //       ),
                  //       Chip(
                  //         label: Text("Soap"),
                  //         backgroundColor: Colors.grey.shade200,
                  //       ),
                  //       Chip(
                  //         label: Text("Soap"),
                  //         backgroundColor: Colors.grey.shade200,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  /// Search Items in grid view
                  searchController.searchStatus == SearchStatus.isSearching
                      ? Center(child: CircularProgressIndicator())
                      : searchController.searchStatus == SearchStatus.notFound
                      ? Center(child: Text("not_found".tr))
                      : searchController.searchStatus == SearchStatus.ideal
                      ? Center(child: Text("search_something".tr))
                      : Expanded(child: GridView.builder(
                            itemCount:
                                searchController.productsModel.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.83,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 15,
                                ),
                            itemBuilder: (context, index) {
                              ProductData product= searchController.productsModel.data![index];
                              return productCard(product);
                            },
                          )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
