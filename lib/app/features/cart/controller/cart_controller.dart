import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/features/home/controller/home_controller.dart';
import '../../home/service/home_service.dart';
import '/app/features/cart/model/cart_model.dart';

enum PaymentType { cod, online }

enum CartState { loading, noItem, error, itemFound }

class CartController extends GetxController {
  int quantity = 0;
  double subTotal = 0;
  int deliveryCharge = 0;
  double discount = 0;
  CartModel cartModel = CartModel();
  CartState currentCartState = CartState.loading;
  bool isCodAvailable = false;
  var userId;
  bool couponApplied = false;
  PaymentType paymentType = PaymentType.online;

  void incrementQty(cartId) {
    final item = cartModel.data!.firstWhere((element) => element.cartId == cartId);
    cartModel.data!.firstWhere((element) => element.cartId == cartId).productQty = item.productQty!+1;
    int? updatedQty=cartModel.data!.firstWhere((element)=>element.cartId==cartId).productQty;
    _saveCart(cartId, updatedQty!);
    update();
  }

 Future<void> decrementQty(String cartId) async {
      final item = cartModel.data!.firstWhere((element) => element.cartId == cartId);
      final currentQty = item.productQty ?? 0;

      if (currentQty > 1) {
        item.productQty = currentQty - 1;
        _saveCart(cartId, item.productQty!);
        update();
      } else {
        // remove item locally
        cartModel.data!.removeWhere((element) => element.cartId == cartId);

        // send update to server indicating removal (productQty = 0)
        try {
          await HomeServices().updateToCart({"cartId": cartId, "productQty": 0});
          await getCart();
        } catch (_) {
          // ignore errors for now
        }

        // update cart state if no items remain
        if (cartModel.data!.isEmpty) {
          currentCartState = CartState.noItem;
        }
        update();
      }
    }

  void applyCoupon() {
    discount = 10;
    couponApplied = true;
    update();
  }

  void selectPayment(PaymentType? type) {
    if (type == null) return;
    paymentType = type;
    update();
  }

  double get total => subTotal + deliveryCharge - discount;

  getCart() async {
    cartModel=CartModel();
    userId=Get.put(HomeController()).userModel.data!.userId.toString();
    deliveryCharge=Get.put(HomeController()).settingsModel.data!.first.deliveryFee??0;
    isCodAvailable=Get.put(HomeController()).settingsModel.data!.first.isCodEnable==1?true:false;
    cartModel = await HomeServices().getCart(userId);
    if (cartModel.data!.isEmpty) {
      currentCartState = CartState.noItem;
    } else {
      currentCartState = CartState.itemFound;
      //calculate total here
   final sum = cartModel.data!
       .fold<double>(0.0, (acc, e) {
         final price = double.tryParse(e.productDetails?.productPrice?.toString() ?? '0') ?? 0.0;
         final qty = e.productQty ?? 0;
         return acc + price * qty;
       });
   subTotal = double.parse(sum.toStringAsFixed(2));


    }
    update();
  }


  getAddress()async{

  }

  _saveCart(String cartId, int qty) async {
    /// update cart data to server after delay of 1 sec
    await Future.delayed(Duration(seconds: 1));

    Map<String, dynamic> newBody = {"cartId": cartId, "productQty": qty};
    await HomeServices().updateToCart(newBody);
    getCart();
  }




  placeOrder()async{
    Map<String,dynamic>orderBody={
      "userId": userId,
      "addressId": "addr-001",
      "isSubscriptionOrder": "no",
      "subTotal": subTotal,
      "grandTotal": total,
      "couponId":'',
      "couponPercent": 0,
      "deliveryFee": deliveryCharge,
      "paymentMode": paymentType.name.toString(),
      "paymentRefDetails": PaymentType.cod==paymentType?"Cash on delivery":"Online Payment"
    };

    print(jsonEncode(orderBody));

    var response=await HomeServices().placeOrder(orderBody);
    print("================================");
    print(response);
    Get.dialog(
      AlertDialog(
        title: Text("Order Placed"),
        content: Text("Your order has been placed successfully."),
      )
    );

    getCart();


  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCart();
  }
}
