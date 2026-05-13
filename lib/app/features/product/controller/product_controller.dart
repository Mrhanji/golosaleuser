import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/routes/app_routes.dart';
import '/app/features/cart/controller/cart_controller.dart';
import '/app/features/home/controller/home_controller.dart';
import '../../home/service/home_service.dart';
import '/app/features/search/model/products_model.dart';

/// ================= CONTROLLER =================

class ProductController extends GetxController {
  ProductsModel productsModel=ProductsModel();
  RxBool isProductLoading=true.obs;
  int quantity = 1;
  bool isSubscription = false,isAddedIntoCart=false;
  int selectedPlan = 7;
  DateTime? selectedStartDate=DateTime.now();
  DateTime? selectedEndDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+7);
  int subscriptionDays=0;
  double total=0;

  void increment() {
    quantity++;
    if(isSubscription){
      double price = double.parse(productsModel.data!.first.productPrice.toString());
      total = price * subscriptionDays * quantity;
    }
    update();
  }

  void decrement() {
    if (quantity > 1) quantity--;
    if(isSubscription){
      double price = double.parse(productsModel.data!.first.productPrice.toString());
      total = price * subscriptionDays * quantity;
    }
    update();
  }

  void toggleSubscription(bool value) {
    isSubscription = value;
    selectedPlan = 7;
    if(isSubscription){
      selectedStartDate=DateTime.now();
      selectedEndDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+7);
      subscriptionDays=7;
      total=double.parse(productsModel.data!.first.productPrice.toString()) * subscriptionDays;
    }
    update();
  }


  selectPlan(int plan) {

    selectedPlan = plan;

    subscriptionDays = plan;

    /// PRODUCT PRICE
    double price = double.parse(productsModel.data!.first.productPrice.toString(),);

    /// TOTAL
    total = price * subscriptionDays * quantity;

    /// START DATE
    selectedStartDate =
        DateTime.now();

    /// END DATE
    selectedEndDate = selectedStartDate!.add(Duration(days: plan),);

    update();
  }


  selectStartDate()async{
    // pick start date with datepicker
    DateTime? pickedDate=await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if(pickedDate!=null){
      selectedStartDate=pickedDate;
      selectedEndDate=pickedDate.add(Duration(days: 7));
      subscriptionDays=7;
      // Calculate total price based on subscription days
      double price = double.parse(productsModel.data!.first.productPrice.toString());
      total = price * subscriptionDays * quantity;
      update();
    }
  }


  selectEndDate()async{
    // pick end date with datepicker
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)), // tomorrow
      lastDate: DateTime(2100),
    );
    if(pickedDate!=null){
      selectedEndDate=pickedDate;
      subscriptionDays=pickedDate.difference(selectedStartDate!).inDays;
      // calculate total price based on subscription days wth quantity
      /// ✅ Get price
      double price = double.parse(
          productsModel.data!.first.productPrice.toString());


      /// ✅ Final total = price × days × quantity
      total = price * subscriptionDays * quantity;
      update();
    }

  }


  navigateToSubscribe()async{
    Map<String,dynamic>body={
      'productId':productsModel.data!.first.productId,
      'userId':Get.put(HomeController()).userModel.data?.userId,
      'productQty':quantity,
      'startDate':selectedStartDate,
      'endDate':selectedEndDate,
      'subscriptionDays':subscriptionDays,
      'total':total,
      'productTitle':productsModel.data!.first.productTitle,
      'productThumbnail':productsModel.data!.first.productThumbnail,
      'productUnitTag':productsModel.data!.first.productUnitTag,
      'productPrice':productsModel.data!.first.productPrice,
    };

    Get.toNamed(AppRoutes.subscribeCartScreen,arguments: body);
  }


  getProductInfo()async{
    productsModel=await HomeServices().getSingleProductById(Get.arguments);
    await Get.put(CartController()).getCart();
    isAddedIntoCart=Get.put(CartController()).cartModel.data!.where((product)=> product.productId==productsModel.data!.first.productId).isNotEmpty;
    isProductLoading.value=false;
    update();
  }


  addToCart()async{
    Map<String,dynamic>body={
      'productId':productsModel.data!.first.productId,
      'userId':Get.put(HomeController()).userModel.data?.userId,
      'productQty':quantity,
    };
    isAddedIntoCart=true;
    update();
    print(body);
    var response=await HomeServices().addToCart(body);
    Get.put(CartController()).getCart();
    print(response);
    Get.snackbar("cart_added".tr, '${response['message']}');

  }

  /// init

  @override
  void onInit() {
    super.onInit();
    getProductInfo();
  }

}
