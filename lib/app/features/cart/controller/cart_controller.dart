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
  String couponErrorMessage = '';
  CouponModel couponModel = CouponModel();
  TextEditingController couponController = TextEditingController();
  List<Data> availableCoupons = [];
  bool loadingAvailableCoupons = false;

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

  Future<void> applyCoupon([String? code]) async {
    final couponCode = (code ?? couponController.text).trim().toUpperCase();
    if (couponCode.isEmpty) {
      couponErrorMessage = "Please enter a coupon code";
      update();
      Get.snackbar(
        "Coupon Required",
        "Please enter a coupon code",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    couponController.text = couponCode;
    couponSearching = true;
    couponErrorMessage = '';
    update();

    await fetchCouponInfo(couponCode);
  }

  Future<void> fetchCouponInfo(String code) async {
    try {
      final currentUserId = userId?.toString() ?? home.userModel.data?.userId?.toString() ?? '';
      final response = await HomeServices().validateCoupon(
        couponCode: code,
        userId: currentUserId,
        orderAmount: subTotal,
      );

      couponSearching = false;

      if (response.status == "success" && response.data != null && response.data!.isNotEmpty) {
        couponModel = response;
        couponApplied = true;
        couponErrorMessage = '';
        final validated = response.data![0];

        // Backend returns exact calculated discount amount!
        discount = validated.discount ?? (validated.discountAmount ?? 0.0);

        couponController.text = validated.couponCode ?? code;

        Get.snackbar(
          "Coupon Applied 🎉",
          validated.message ?? response.message ?? "Coupon applied successfully! You saved ₹${discount.toStringAsFixed(discount % 1 == 0 ? 0 : 2)}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        _resetCoupon();
        couponErrorMessage = response.message ?? "Invalid or expired coupon code";
        Get.snackbar(
          "Coupon Not Applicable",
          couponErrorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      _resetCoupon();
      couponErrorMessage = "Failed to validate coupon. Please try again.";
      Get.snackbar(
        "Error",
        couponErrorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  Future<void> _revalidateAppliedCoupon() async {
    if (!couponApplied || couponModel.data == null || couponModel.data!.isEmpty) return;

    final code = couponModel.data![0].couponCode;
    if (code == null || code.isEmpty) return;

    try {
      final currentUserId = userId?.toString() ?? home.userModel.data?.userId?.toString() ?? '';
      final response = await HomeServices().validateCoupon(
        couponCode: code,
        userId: currentUserId,
        orderAmount: subTotal,
      );

      if (response.status == "success" && response.data != null && response.data!.isNotEmpty) {
        couponModel = response;
        final validated = response.data![0];
        discount = validated.discount ?? (validated.discountAmount ?? 0.0);
      } else {
        // Order subtotal changed and coupon is no longer applicable
        _resetCoupon();
        couponController.clear();
        couponErrorMessage = response.message ?? "Coupon no longer meets requirements.";
        Get.snackbar(
          "Coupon Removed",
          couponErrorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (_) {}
  }

  Future<void> fetchAvailableCoupons() async {
    final currentUserId = userId?.toString() ?? home.userModel.data?.userId?.toString() ?? '';
    if (currentUserId.isEmpty) return;

    loadingAvailableCoupons = true;
    update();

    try {
      final response = await HomeServices().getAvailableCoupons(
        userId: currentUserId,
        orderAmount: subTotal,
      );

      if (response.status == "success" && response.data != null) {
        availableCoupons = response.data!;
      } else {
        availableCoupons = [];
      }
    } catch (e) {
      availableCoupons = [];
    } finally {
      loadingAvailableCoupons = false;
      update();
    }
  }

  void removeCoupon() {
    _resetCoupon();
    couponController.clear();
    couponErrorMessage = '';
    Get.snackbar(
      "Coupon Removed",
      "Coupon has been removed from your cart",
      snackPosition: SnackPosition.BOTTOM,
    );
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

  double get total {
    final t = subTotal + deliveryCharge - discount;
    return t < 0 ? 0.0 : double.parse(t.toStringAsFixed(2));
  }

  bool get hasInsufficientBalanceForOnlinePayment =>
      userCurrentBalance != 0 &&
      paymentType == PaymentType.online &&
      userCurrentBalance < total;

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
      _resetCoupon();
      couponController.clear();
      availableCoupons = [];
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

      if (couponApplied) {
        await _revalidateAppliedCoupon();
      }
      fetchAvailableCoupons();
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
      "couponId": couponApplied && couponModel.data != null && couponModel.data!.isNotEmpty
          ? couponModel.data![0].couponId ?? ''
          : '',
      "couponPercent": couponApplied && couponModel.data != null && couponModel.data!.isNotEmpty
          ? (couponModel.data![0].discountPercentage?.round() ?? 0)
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

    /// 🔄 Refresh data & reset coupon
    _resetCoupon();
    couponController.clear();
    couponErrorMessage = '';
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