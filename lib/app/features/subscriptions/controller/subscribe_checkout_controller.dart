import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/SubscriptionSuccessSheet.dart';
import '/app/features/subscriptions/service/subscription_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '/utils/app_constants.dart';
import '/app/features/home/controller/home_controller.dart';
import '../../address/model/address_model.dart';
import '/app/features/address/service/address_service.dart';

class SubscribeController extends GetxController {
  int selectedAddress = 0;
  int selectedPayment = 0;

  PlanDetails planDetails = PlanDetails();
  AddressHistoryModel addressHistoryModel = AddressHistoryModel();

  RxBool addressLoading = true.obs;
  RxBool thumbnailLoading = true.obs;
  double walletBalance = 0.0;
  double perDayBill = 0.0;

  bool isWalletEnabled = false;

  late Razorpay razorpay;

  final HomeController homeController = Get.find<HomeController>();

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    print(arguments);

    planDetails = PlanDetails.fromJson(arguments);

    walletBalance = double.tryParse(
      homeController.userModel.data?.walletAmount.toString() ?? "0",
    ) ??
        0;

    perDayBill = (planDetails.productQty ?? 0) *
        (double.tryParse(planDetails.productPrice ?? "0") ?? 0);

    isWalletEnabled = walletBalance >= (planDetails.total ?? 0);

    if (!isWalletEnabled) {
      selectedPayment = 1;
    }

    getAddress();
    thumbnailLoading.value=false;
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

  // ================= ADDRESS =================

  Future<void> getAddress() async {
    try {
      addressLoading.value = true;

      addressHistoryModel =
      await AddressService().getAddress(planDetails.userId);

      addressLoading.value = false;
    } catch (e) {
      addressLoading.value = false;

      showDialogBox(
        "Error",
        "Failed to load address",
      );
    }
  }

  // ================= PAYMENT METHOD =================

  void changePaymentMethod(int method) {
    selectedPayment = method;
    update();
  }

  // ================= SUBSCRIBE =================

  Future<void> subScribe() async {
    if (selectedPayment == 0) {
      // Wallet Payment

      if (walletBalance >= (planDetails.total ?? 0)) {
        showDialogBox(
          "Success",
          "Wallet payment completed successfully.",
        );

        // CALL API HERE
      } else {
        showDialogBox(
          "Insufficient Balance",
          "Wallet balance is low.",
        );
      }
    } else {
      openRazorPay();
    }
  }

  // ================= OPEN RAZORPAY =================

  void openRazorPay() {
    try {
      final options = {
        'key': AppConstants.razorpayKey,
        'amount': ((planDetails.total ?? 0) * 100).toInt(),
        'name': AppConstants.appName,
        'description': planDetails.productTitle ?? '',
        'image': 'https://golosale.com/golo-icon.png',
        'retry': {
          'enabled': true,
          'max_count': 1,
        },
        'send_sms_hash': true,
        'prefill': {
          'contact': homeController.userModel.data?.userMobile ?? '',
          'email': '',
          'name': homeController.userModel.data?.firstName ?? 'Customer',

        },
        'theme': {
          'color': '#4FC83F',
        }
      };

      Future.delayed(
        const Duration(milliseconds: 300),
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

  // ================= SUCCESS =================

  // ─── In your payment screen ───────────────────────────────────────────────────

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Map<String, dynamic> dataBody = {
      "userId": homeController.userModel.data!.userId,
      "productId": planDetails.productId,
      "productQty": planDetails.productQty,
      "productPrice": planDetails.productPrice,
      "startAt": planDetails.startDate.toString(),
      "endAt": planDetails.endDate.toString(),
      "planDuration": planDetails.subscriptionDays,
      "totalBill": planDetails.total,
      "addressId": addressHistoryModel.data![selectedAddress].addressId,
      "paymentMode": "online",
      "status": "scheduled",
    };

    final apiResponse = await SubscriptionServices().subscribeSubscription(dataBody);

    // Parse the 'data' field from your API response
    // e.g. apiResponse.data is a Map<String, dynamic>
    final successData = SubscriptionSuccessData.fromJson(apiResponse['data']);

    // Show the beautiful success sheet 🎉
    showSubscriptionSuccess(successData);

    print(response.paymentId);
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

  // ================= DIALOG =================

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

  // ================= DISPOSE =================

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}

class PlanDetails {
  String? productId;
  String? userId;
  int? productQty;
  DateTime? startDate;
  DateTime? endDate;
  int? subscriptionDays;
  double? total;
  String? productTitle;
  String? productThumbnail;
  String? productUnitTag;
  String? productPrice;

  PlanDetails({
    this.productId,
    this.userId,
    this.productQty,
    this.startDate,
    this.endDate,
    this.subscriptionDays,
    this.total,
    this.productTitle,
    this.productThumbnail,
    this.productUnitTag,
    this.productPrice,
  });

  factory PlanDetails.fromJson(
      Map<String, dynamic> json,
      ) {
    return PlanDetails(
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      productQty: json['productQty'] ?? 0,
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      subscriptionDays: json['subscriptionDays'] ?? 0,
      total: (json['total'] is int)
          ? (json['total'] as int).toDouble()
          : json['total'] ?? 0.0,
      productTitle: json['productTitle'] ?? '',
      productThumbnail: json['productThumbnail'] ?? '',
      productUnitTag: json['productUnitTag'] ?? '',
      productPrice: json['productPrice'] ?? '',
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is DateTime) return value;

    return DateTime.tryParse(value.toString()) ??
        DateTime.now();
  }
}