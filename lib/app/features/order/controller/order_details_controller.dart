import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/order/service/order_service.dart';

import '/app/features/home/service/home_service.dart';
import '../model/order_details_model.dart';

class OrderDetailsController extends GetxController {

  String? orderId;

  bool isLoading = true;

  OrderDetailsModel orderDetailsModel =
  OrderDetailsModel();

  // =========================
  // GET ORDER DETAILS
  // =========================

  Future<void> getOrderDetails() async {

    try {

      isLoading = true;
      update();

      orderDetailsModel =
      await HomeServices()
          .getOrderDetails(
        orderId!,
      );

    } catch (e) {

      debugPrint(
        "Order Details Error => $e",
      );

    } finally {

      isLoading = false;
      update();
    }
  }

  // =========================
  // CANCEL ORDER
  // =========================

  Future<void> cancelOrder(
      String orderId,
      ) async {

    try {

      Get.dialog(

        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4FC83F),
          ),
        ),

        barrierDismissible: false,
      );

      // TODO:
      // ADD YOUR API HERE

      Map<String,dynamic>dataBody={
        "orderId":orderId,
        "orderStatus":"cancelled",
      };
    var response=await OrderService().updateOrderStatus(dataBody);
print("Out put -> ${response}");
      await Future.delayed(
        const Duration(seconds: 1),
      );

      Get.back();

      Get.snackbar(

        "success".tr,

        "order_cancelled_successfully"
            .tr,

        backgroundColor:
        const Color(0xFF4FC83F),

        colorText: Colors.white,

        snackPosition:
        SnackPosition.BOTTOM,
      );

      getOrderDetails();

    } catch (e) {

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(

        "error".tr,

        "something_went_wrong".tr,

        backgroundColor: Colors.red,

        colorText: Colors.white,

        snackPosition:
        SnackPosition.BOTTOM,
      );
    }
  }

  // =========================
  // STATUS TEXT
  // =========================

  String getStatusText(
      String status,
      ) {

    switch (status.toLowerCase()) {

      case 'pending':
        return 'pending'.tr;

      case 'confirmed':
        return 'confirmed'.tr;

      case 'processing':
        return 'processing'.tr;

      case 'packed':
        return 'packed'.tr;

      case 'out_for_delivery':
        return 'out_for_delivery'.tr;

      case 'delivered':
        return 'delivered'.tr;

      case 'cancelled':
        return 'cancelled'.tr;

      case 'scheduled':
        return 'scheduled'.tr;

      default:
        return status.tr;
    }
  }

  // =========================
  // STATUS COLOR
  // =========================

  Color getStatusColor(
      String status,
      ) {

    switch (status.toLowerCase()) {

      case 'pending':
        return const Color(0xFFF59E0B);

      case 'confirmed':
        return const Color(0xFF2563EB);

      case 'processing':
        return const Color(0xFF8B5CF6);

      case 'packed':
        return const Color(0xFF0EA5E9);

      case 'out_for_delivery':
        return const Color(0xFFEC4899);

      case 'delivered':
        return const Color(0xFF4FC83F);

      case 'cancelled':
        return Colors.red;

      case 'scheduled':
        return const Color(0xFF6366F1);

      default:
        return Colors.grey;
    }
  }

  // =========================
  // DATE FORMAT
  // =========================

  String formatDateTime(
      String date,
      ) {

    try {

      final parsed =
      DateTime.parse(date)
          .toLocal();

      final day =
      parsed.day
          .toString()
          .padLeft(2, '0');

      final month =
      parsed.month
          .toString()
          .padLeft(2, '0');

      final year =
      parsed.year.toString();

      int hour =
          parsed.hour;

      final minute =
      parsed.minute
          .toString()
          .padLeft(2, '0');

      String period = "AM";

      if (hour >= 12) {
        period = "PM";
      }

      if (hour > 12) {
        hour -= 12;
      }

      if (hour == 0) {
        hour = 12;
      }

      final formattedHour =
      hour.toString().padLeft(2, '0');

      return
        "$day-$month-$year "
            "$formattedHour:$minute${period.toLowerCase()}";

    } catch (e) {

      return date;
    }
  }

  // =========================
  // INIT
  // =========================

  @override
  void onInit() {

    super.onInit();

    orderId = Get.arguments;

    getOrderDetails();
  }
}