import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_constants.dart';
import '/app/features/wallet/service/wallet_service.dart';
import '/app/features/auth/model/user_model.dart';
import '/app/features/home/controller/home_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RechargeController extends GetxController {

  ////////////////////////////////////////////
  /// 🔑 CONFIG
  ////////////////////////////////////////////



  final Map<String, dynamic> razorpayPrefill = {
    "contact": "9999999999",
    "email": "test@gmail.com",
  };

  final String appName = "GoloSale";
  final String paymentDescription = "Wallet Recharge";

  ////////////////////////////////////////////
  /// STATE
  ////////////////////////////////////////////

  final TextEditingController amountController = TextEditingController();

  final RxInt selectedAmount = 0.obs;
  final RxDouble walletBalance = 0.0.obs;

  UserModel userModel = UserModel();

  final List<int> quickAmounts = [100, 300, 500, 1000];

  var isProcessing = false.obs;

  Razorpay? _razorpay;

  ////////////////////////////////////////////
  /// INIT
  ////////////////////////////////////////////

  @override
  void onInit() {
    super.onInit();

    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    fetchUser();
  }

  ////////////////////////////////////////////
  /// FETCH USER
  ////////////////////////////////////////////

  fetchUser() async {
    userModel = Get.put(HomeController()).userModel;

    walletBalance.value =
        double.parse(userModel.data!.walletAmount.toString());

    razorpayPrefill["contact"] = userModel.data!.userMobile;
    razorpayPrefill["email"] = userModel.data!.userEmail;
  }

  ////////////////////////////////////////////
  /// SELECT AMOUNT
  ////////////////////////////////////////////

  void selectAmount(int amount) {
    selectedAmount.value = amount;
    amountController.text = amount.toString();
  }

  ////////////////////////////////////////////
  /// 💳 START PAYMENT (FIXED)
  ////////////////////////////////////////////

  Future<void> startPayment() async {
    int amount = int.tryParse(amountController.text) ?? 0;

    if (amount < 100) {
      _showSnackbar("Minimum recharge is ₹100");
      return;
    }

    if (amount > 5000) {
      _showSnackbar("Maximum recharge is ₹5000");
      return;
    }

    try {
      isProcessing.value = true;

      ////////////////////////////////////////////
      /// ✅ NO ORDER ID (TEMP FIX)
      ////////////////////////////////////////////

      final options = {
        "key": AppConstants.razorpayKey,
        "amount": amount * 100,
        "name": appName,
        "description": paymentDescription,
        "prefill": razorpayPrefill,
        "timeout": 120,
      };

      _razorpay!.open(options);
    } catch (e) {
      print("RAZORPAY ERROR: $e");
      _showSnackbar("Something went wrong");
    } finally {
      isProcessing.value = false;
    }
  }

  ////////////////////////////////////////////
  /// ✅ PAYMENT SUCCESS
  ////////////////////////////////////////////

  Future<void> _handlePaymentSuccess(
      PaymentSuccessResponse response) async {

    print("SUCCESS: ${response.paymentId}");

    walletBalance.value += int.parse(amountController.text);
    Map<String,dynamic>dataBody={
      'userId':userModel.data!.userId,
      'amount':int.parse(amountController.text),
      'transType':'credit',
      'message':response.paymentId
    };
    print(dataBody);
    var apiResponse=await WalletService().addAmount(dataBody);
    print(apiResponse);
    Get.put(HomeController()).getUser();
    Get.put(HomeController()).update();

    _showResultDialog(
      success: true,
      message: "Recharge successful! Wallet updated.",
    );
  }

  ////////////////////////////////////////////
  /// ❌ PAYMENT FAILED
  ////////////////////////////////////////////

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: ${response.code} ${response.message}");

    _showResultDialog(
      success: false,
      message: response.message ?? "Payment failed",
    );
  }

  ////////////////////////////////////////////
  /// 👛 EXTERNAL WALLET
  ////////////////////////////////////////////

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackbar("External wallet selected");
  }

  ////////////////////////////////////////////
  /// UI HELPERS
  ////////////////////////////////////////////

  void _showSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showResultDialog({
    required bool success,
    required String message,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.cancel,
                size: 70,
                color: success ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                success ? "Success" : "Failed",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("OK"),
              )
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////
  /// CLEANUP
  ////////////////////////////////////////////

  @override
  void onClose() {
    _razorpay?.clear();
    amountController.dispose();
    super.onClose();
  }
}