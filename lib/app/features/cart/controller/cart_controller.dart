import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import '../../home/service/home_service.dart';
import '/app/features/cart/model/cart_model.dart';

enum PaymentType { cod, online }

enum CartState { loading, noItem, error, itemFound }

class CartController extends GetxController {
  int quantity = 2;
  double subTotal = 0;
  double deliveryCharge = 45;
  double discount = 0;
  CartModel cartModel = CartModel();
  CartState currentCartState = CartState.loading;

  bool couponApplied = false;
  PaymentType paymentType = PaymentType.cod;

  void incrementQty(cartId) {
    quantity++;
    // update quantity on cart model where cartId match
    cartModel.data!
            .firstWhere((element) => element.cartId == cartId)
            .productQty =
        quantity;
    int? updatedQty=cartModel.data!.firstWhere((element)=>element.cartId==cartId).productQty;
    _saveCart(cartId, updatedQty!);
    update();
  }

  void decrementQty(cartId) {
    if (quantity > 1) {
      quantity--;
      cartModel.data!
              .firstWhere((element) => element.cartId == cartId)
              .productQty =
          quantity;
      int? updatedQty=cartModel.data!.firstWhere((element)=>element.cartId==cartId).productQty;
      _saveCart(cartId, updatedQty!);
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
    cartModel = await HomeServices().getCart(
      Get.put(HomeController()).userModel.data!.userId.toString(),
    );
    if (cartModel.data!.isEmpty) {
      currentCartState = CartState.noItem;
    } else {
      currentCartState = CartState.itemFound;
    }
    update();
  }

  _saveCart(String cartId, int qty) async {
    /// update cart data to server after delay of 3 sec
    await Future.delayed(Duration(seconds: 3));

    Map<String, dynamic> newBody = {"cartId": cartId, "productQty": qty};
    await HomeServices().updateToCart(newBody);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCart();
  }
}
