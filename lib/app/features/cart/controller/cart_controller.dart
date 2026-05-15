import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_constants.dart';
import '/app/features/cart/model/coupon_model.dart';
import '/app/routes/app_routes.dart';
import 'package:lottie/lottie.dart';
import '/app/features/address/model/address_model.dart';
import '/app/features/address/service/address_service.dart';
import '/app/features/home/controller/home_controller.dart';
import '../../home/service/home_service.dart';
import '/app/features/cart/model/cart_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum PaymentType { cod, online }
enum CartState { loading, noItem, error, itemFound }

class CartController extends GetxController {
  int quantity = 0;
  double subTotal = 0;
  int deliveryCharge = 0;
  double discount = 0;
  late Razorpay razorpay;
  CartModel cartModel = CartModel();
  CartState currentCartState = CartState.loading;
  HomeController home=HomeController();
  bool isCodAvailable = false;
  var userId;

  /// ✅ Coupon
  bool couponApplied = false;
  bool couponSearching = false;
  CouponModel couponModel = CouponModel();
  TextEditingController couponController = TextEditingController();

  PaymentType paymentType = PaymentType.online;

  double userCurrentBalance = 0.0;

  AddressHistoryModel addressHistoryModel = AddressHistoryModel();
  bool addressLoading = true;
  String selectedAddressId = "";

  /// ---------------- QTY ----------------

  void incrementQty(cartId) {
    final item = cartModel.data!
        .firstWhere((element) => element.cartId == cartId);

    item.productQty = item.productQty! + 1;

    _saveCart(cartId, item.productQty!);
    update();
  }

  Future<void> decrementQty(String cartId) async {
    final item = cartModel.data!
        .firstWhere((element) => element.cartId == cartId);

    final currentQty = item.productQty ?? 0;

    if (currentQty > 1) {
      item.productQty = currentQty - 1;
      _saveCart(cartId, item.productQty!);
      update();
    } else {
      cartModel.data!.removeWhere((e) => e.cartId == cartId);

      try {
        await HomeServices()
            .updateToCart({"cartId": cartId, "productQty": 0});
        await getCart();
      } catch (_) {}

      if (cartModel.data!.isEmpty) {
        currentCartState = CartState.noItem;
      }
      update();
    }
  }

  /// ---------------- COUPON ----------------

  Future<void> applyCoupon() async {
    if (couponController.text.trim().isEmpty) return;

    couponSearching = true;
    update();

    await fetchCouponInfo();
  }

  Future<void> fetchCouponInfo() async {
    try {
      couponModel =
      await HomeServices().getCoupon(couponController.text.trim());

      if (couponModel.data != null && couponModel.data!.isNotEmpty) {
        final coupon = couponModel.data![0];

        couponSearching = false;

        /// ✅ Min Cap Check
        if (coupon.minCap != null && subTotal < coupon.minCap!) {
          print("Subtotal is less than MinCap");

          Get.snackbar(
            "Coupon Not Applicable",
            "Minimum order should be ₹${coupon.minCap}",
            snackPosition: SnackPosition.BOTTOM,
          );

          _resetCoupon();
          return;
        }

        /// ✅ Max Cap Check
        if (coupon.maxCap != null && subTotal > coupon.maxCap!) {
          print("Subtotal is greater than MaxCap");

          Get.snackbar(
            "Coupon Not Applicable",
            "Coupon valid only up to ₹${coupon.maxCap}",
            snackPosition: SnackPosition.BOTTOM,
          );

          _resetCoupon();
          return;
        }

        /// ✅ Apply only if valid
        couponApplied = true;

        discount =
            double.tryParse(coupon.discountPercentage.toString()) ?? 0;

        /// show coupon code back in field
        couponController.text = coupon.couponCode ?? '';

        /// ✅ Success Snackbar
        Get.snackbar(
          "Success",
          "Coupon applied successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

      } else {
        _resetCoupon();

        Get.snackbar(
          "Invalid Coupon",
          "Please enter a valid coupon code",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      _resetCoupon();

      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  void removeCoupon() {
    _resetCoupon();
    couponController.clear();
    update();
  }

  void _resetCoupon() {
    couponModel = CouponModel();
    couponApplied = false;
    couponSearching = false;
    discount = 0;
    update();
  }

  /// ---------------- PAYMENT ----------------

  void selectPayment(PaymentType? type) {
    if (type == null) return;
    paymentType = type;
    update();
  }

  double get total => subTotal + deliveryCharge - discount;

  /// ---------------- CART ----------------

  getCart() async {
    cartModel = CartModel();
     home = Get.put(HomeController());

    userId = home.userModel.data!.userId.toString();

    userCurrentBalance =
        double.tryParse(home.userModel.data!.walletAmount.toString()) ?? 0.0;

    deliveryCharge =
        home.settingsModel.data!.first.deliveryFee ?? 0;

    isCodAvailable =
        home.settingsModel.data!.first.isCodEnable == 1;

    cartModel = await HomeServices().getCart(userId);

    if (cartModel.data!.isEmpty) {
      currentCartState = CartState.noItem;
    } else {
      currentCartState = CartState.itemFound;

      final sum = cartModel.data!.fold<double>(0.0, (acc, e) {
        final price = double.tryParse(
            e.productDetails?.productPrice?.toString() ?? '0') ??
            0.0;

        final qty = e.productQty ?? 0;

        return acc + price * qty;
      });

      subTotal = double.parse(sum.toStringAsFixed(2));
    }

    update();
  }

  /// ---------------- ADDRESS ----------------

  getAddress() async {
    addressHistoryModel = await AddressService().getAddress(userId);

    addressLoading = false;

    if (addressHistoryModel.data!.isNotEmpty) {
      selectedAddressId = addressHistoryModel.data!.firstWhere((e) => e.setAsDefault == 1).addressId.toString();
    }

    update();
  }

  /// ---------------- SAVE CART ----------------

  _saveCart(String cartId, int qty) async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> body = {
      "cartId": cartId,
      "productQty": qty
    };

    await HomeServices().updateToCart(body);
    getCart();
  }

  /// ---------------- ORDER ----------------


  placeOrder()async{
    if(selectedAddressId==''){
      showDialogBox(
        "address_required".tr,
        "please_select_address".tr,
      );
    }else{
    if(paymentType==PaymentType.cod){
      await _orderPlaced();
    }else{
      /// 👉 Razorpay integration here
      openRazorPay();
    }
  }
  }


 void openRazorPay() {

    try {

      final options = {

        'key': AppConstants.razorpayKey,

        'amount':
        ((total) * 100).toInt(),

        'name':
        AppConstants.appName,

        'description':
        'Product Purchase',

        /// APP LOGO
        'image':
        'https://golosale.com/golo-icon.png',

        'retry': {
          'enabled': true,
          'max_count': 1,
        },

        'send_sms_hash': true,

        /// USER DETAILS
        'prefill': {

          'name':
          home.userModel.data?.firstName ??
              'Customer',

          'contact':
          home.userModel.data?.userMobile ??
              '',

          'email':
          home.userModel.data?.userEmail ??
              '',
        },

        /// THEME
        'theme': {
          'color': '#4FC83F',
        }
      };

      Future.delayed(
        const Duration(
            milliseconds: 300),
            () {

          razorpay.open(options);
        },
      );

    } catch (e) {

      showDialogBox(
        "Error",
        e.toString(),
      );
    }
  }






  _orderPlaced() async {
    Map<String, dynamic> orderBody = {
      "userId": userId,
      "addressId": selectedAddressId,
      "isSubscriptionOrder": "no",
      "subTotal": subTotal,
      "grandTotal": total,
      "couponId": couponApplied
          ? couponModel.data![0].couponId ?? ''
          : '',
      "couponPercent": couponApplied
          ? couponModel.data![0].discountPercentage ?? 0
          : 0,
      "deliveryFee": deliveryCharge,
      "paymentMode": paymentType.name,
      "paymentRefDetails": paymentType == PaymentType.cod
          ? "Cash on delivery"
          : "Online Payment"
    };

    var response = await HomeServices().placeOrder(orderBody);

    /// ✅ Extract data safely
    final orderData = response["data"][0];
    final orderId = orderData["orderId"];
    final createdOn = DateTime.parse(orderData["createdOn"]);

    /// ✅ Format date nicely
    final formattedDate =
        "${createdOn.day}/${createdOn.month}/${createdOn.year} • "
        "${createdOn.hour}:${createdOn.minute.toString().padLeft(2, '0')}";

    /// ✅ Full Screen Dialog
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              /// ❌ Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ),

              const Spacer(),

              /// 🎉 Lottie Animation
              SizedBox(
                height: 180,
                child: Lottie.asset(
                  "assets/animations/success.json", // 👈 your file
                  repeat: false,
                ),
              ),

              const SizedBox(height: 20),

              /// ✅ Success Text
              Text("order_placed".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// 🧾 Order ID
              Text(
                "order_id".tr,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                orderId,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              /// 🕒 Date
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey),
              ),

              const Spacer(),

              /// 🔘 Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// Go to Orders
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(AppRoutes.orderHistoryScreen); // 👈 update route if needed
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child:  Text("view_orders".tr),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Continue Shopping
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child:  Text("continue_shopping".tr),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    /// 🔄 Refresh data
    getCart();
    Get.put(HomeController()).getUser();
  }

  /// ---------------- INIT ----------------

  @override
  void onInit() {
    super.onInit();
    getCart();
    getAddress();

    // Razorpay
    razorpay = Razorpay();

    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );

  }

  // ================= DISPOSE =================

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }



  // ================= SUCCESS =================

  void _handlePaymentSuccess(
      PaymentSuccessResponse response,
      )async {
   await _orderPlaced();
    print(response.paymentId);

    // CALL SUCCESS API HERE
  }

  // ================= ERROR =================

  void _handlePaymentError(
      PaymentFailureResponse response,
      ) {
    showDialogBox(
      "Payment Failed",
      response.message ?? "Transaction failed",
    );
  }

  // ================= EXTERNAL WALLET =================

  void _handleExternalWallet(
      ExternalWalletResponse response,
      ) {
    showDialogBox(
      "External Wallet",
      response.walletName ?? '',
    );
  }


  void showDialogBox(
      String title,
      String message,
      ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}