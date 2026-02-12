import 'package:flutter/material.dart';
import '/app/features/home/controller/home_controller.dart';
import '/app/features/search/model/products_model.dart';
import '../widgets/product_card.dart';
import '/app/features/home/model/CategoryModel.dart';
import '/utils/end_points.dart';
import 'package:get/get.dart';

class CategoryProductsScreen extends StatelessWidget {
   CategoryProductsScreen({super.key});
   HomeController homeController=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    CategoryData categoryData=Get.arguments;
    homeController.getCategoryItem(categoryData.categoryId);
    return Scaffold(
      appBar: AppBar(
        title: Text("${categoryData.categoryTitle}"),
        centerTitle: true,
      ),

      body: GetBuilder(
        init:  homeController,
        builder: (context) {
          if(homeController.isCategoryItemLoading==true){
            return Center(child: CircularProgressIndicator(),);
          }else if(homeController.productsModel.data!.isEmpty){
            return Center(child: Text("No product found"),);
          }else
          return GridView.builder(
            itemCount: homeController.productsModel.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.83,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15
              ),
              itemBuilder: (context,index){
                ProductData productData=homeController.productsModel.data![index];

                return productCard(productData);
              });
        }
      )
      );

  }
}
