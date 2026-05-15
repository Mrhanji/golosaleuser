import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/routes/app_routes.dart';
import '/app/features/cart/controller/cart_controller.dart';
import '/app/features/home/controller/home_controller.dart';
import '../../home/service/home_service.dart';
import '/app/features/search/model/products_model.dart';

/// ================= CONTROLLER =================

class ProductController extends GetxController {
  ProductsModel productsModel = ProductsModel();

  RxBool isProductLoading = true.obs;

  int quantity = 1;

  bool isSubscription = false, isAddedIntoCart = false;

  int selectedPlan = 7;

  DateTime? selectedStartDate = DateTime.now();

  DateTime? selectedEndDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day + 7,
  );

  int subscriptionDays = 0;

  double total = 0;

  /// ---- Slot: morning / evening ----
  String selectedSlot = '';

  /// ================= SLOT =================

  void initializeDefaultSlot() {
    final product = productsModel.data!.first;

    if (product.availableInMorningSlot == true) {
      selectedSlot = 'morning';
    } else if (product.availableInEveningSlot == true) {
      selectedSlot = 'evening';
    } else {
      selectedSlot = '';
    }
  }

  void selectSlot(String slot) {
    final product = productsModel.data!.first;

    /// Prevent invalid selection
    if (slot == "morning" && product.availableInMorningSlot != true) {
      return;
    }

    if (slot == "evening" && product.availableInEveningSlot != true) {
      return;
    }

    selectedSlot = slot;

    update();
  }

  // =========================================

  void increment() {
    quantity++;

    if (isSubscription) {
      double price = double.parse(
        productsModel.data!.first.productPrice.toString(),
      );

      total = price * subscriptionDays * quantity;
    }

    update();
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }

    if (isSubscription) {
      double price = double.parse(
        productsModel.data!.first.productPrice.toString(),
      );

      total = price * subscriptionDays * quantity;
    }

    update();
  }

  /// ================= SUBSCRIPTION =================

  void toggleSubscription(bool value) {
    isSubscription = value;

    selectedPlan = 7;

    initializeDefaultSlot();

    if (isSubscription) {
      selectedStartDate = DateTime.now();

      selectedEndDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 7,
      );

      subscriptionDays = 7;

      total =
          double.parse(productsModel.data!.first.productPrice.toString()) *
          subscriptionDays *
          quantity;
    }

    update();
  }

  void selectPlan(int plan) {
    selectedPlan = plan;

    subscriptionDays = plan;

    double price = double.parse(
      productsModel.data!.first.productPrice.toString(),
    );

    total = price * subscriptionDays * quantity;

    selectedStartDate = DateTime.now();

    selectedEndDate = selectedStartDate!.add(Duration(days: plan));

    update();
  }

  /// ================= START DATE =================

  selectStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedStartDate = pickedDate;

      selectedEndDate = pickedDate.add(const Duration(days: 7));

      subscriptionDays = 7;

      double price = double.parse(
        productsModel.data!.first.productPrice.toString(),
      );

      total = price * subscriptionDays * quantity;

      update();
    }
  }

  /// ================= END DATE =================

  selectEndDate() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,

      initialDate: now.add(const Duration(days: 1)),

      firstDate: now.add(const Duration(days: 1)),

      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedEndDate = pickedDate;

      subscriptionDays = pickedDate.difference(selectedStartDate!).inDays;

      double price = double.parse(
        productsModel.data!.first.productPrice.toString(),
      );

      total = price * subscriptionDays * quantity;

      update();
    }
  }

  /// ================= NAVIGATE =================

  navigateToSubscribe() async {
    Map<String, dynamic> body = {
      'productId': productsModel.data!.first.productId,

      'userId': Get.put(HomeController()).userModel.data?.userId,

      'productQty': quantity,

      'startDate': selectedStartDate!.add(const Duration(days: 1)),

      'endDate': selectedEndDate,

      'subscriptionDays': subscriptionDays,

      'total': total,

      'productTitle': productsModel.data!.first.productTitle,

      'productThumbnail': productsModel.data!.first.productThumbnail,

      'productUnitTag': productsModel.data!.first.productUnitTag,

      'productPrice': productsModel.data!.first.productPrice,

      'selectedSlot': selectedSlot,
    };

    Get.toNamed(AppRoutes.subscribeCartScreen, arguments: body);
  }

  /// ================= PRODUCT =================

  getProductInfo() async {
    productsModel = await HomeServices().getSingleProductById(Get.arguments);

    initializeDefaultSlot();

    await Get.put(CartController()).getCart();

    isAddedIntoCart = Get.put(CartController()).cartModel.data!
        .where(
          (product) => product.productId == productsModel.data!.first.productId,
        )
        .isNotEmpty;

    isProductLoading.value = false;

    update();
  }

  /// ================= CART =================

  addToCart() async {
    Map<String, dynamic> body = {
      'productId': productsModel.data!.first.productId,

      'userId': Get.put(HomeController()).userModel.data?.userId,

      'productQty': quantity,
    };

    isAddedIntoCart = true;

    update();

    var response = await HomeServices().addToCart(body);

    Get.put(CartController()).getCart();

    Get.snackbar("cart_added".tr, '${response['message']}');
  }

  /// ================= INIT =================

  @override
  void onInit() {
    super.onInit();

    getProductInfo();
  }
}
