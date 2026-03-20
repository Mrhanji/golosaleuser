import 'package:get/get.dart';
import '/app/features/home/controller/home_controller.dart';
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
  var userId;
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
    userId=Get.put(HomeController()).userModel.data!.userId.toString();

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
