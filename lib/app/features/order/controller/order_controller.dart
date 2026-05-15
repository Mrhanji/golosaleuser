import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/features/home/controller/home_controller.dart';
import '/app/features/home/service/home_service.dart';
import '../model/order_history_model.dart';

enum OrderHistoryState {
  loading,
  noItem,
  error,
  itemFound
}

class OrderHistoryController
    extends GetxController {

  OrderHistoryState currentOrderHistoryState =  OrderHistoryState.loading;

  OrderHistoryModel orderHistoryModel =
  OrderHistoryModel();

  List<Orders> orderList = [];

  ScrollController scrollController =
  ScrollController();

  int currentPage = 1;

  bool hasMoreData = true;

  bool isPaginationLoading = false;

  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();

    getHistory();

    scrollController.addListener(() {

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {

        if (!isPaginationLoading &&
            hasMoreData) {

          getHistory(isPagination: true);
        }
      }
    });
  }

  // GET HISTORY

  Future<void> getHistory({
    bool isPagination = false,
  }) async {

    try {

      if (!isPagination) {

        currentOrderHistoryState =
            OrderHistoryState.loading;

        update();
      }

      isPaginationLoading = true;

      final userId =
      Get.put(HomeController())
          .userModel
          .data!
          .userId
          .toString();

      orderHistoryModel =
      await HomeServices()
          .getOrderHistory(
        userId,
         currentPage,
        pageSize,
      );

      final newOrders =
          orderHistoryModel
              .data
              ?.orders ??
              [];

      if (!isPagination) {

        orderList = newOrders;

      } else {

        orderList.addAll(newOrders);
      }

      // CHECK MORE DATA

      if (newOrders.length < pageSize) {

        hasMoreData = false;

      } else {

        currentPage++;
      }

      // STATE

      if (orderList.isEmpty) {

        currentOrderHistoryState =
            OrderHistoryState.noItem;

      } else {

        currentOrderHistoryState =
            OrderHistoryState.itemFound;
      }

    } catch (e) {

      currentOrderHistoryState =
          OrderHistoryState.error;

    } finally {

      isPaginationLoading = false;

      update();
    }
  }

  // REFRESH

  Future<void> refreshOrders() async {

    currentPage = 1;

    hasMoreData = true;

    orderList.clear();

    await getHistory();
  }

  // STATUS TEXT

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

        case 'scheduled':
          return 'scheduled'.tr;

      case 'delivered':
        return 'delivered'.tr;

      case 'cancelled':
        return 'cancelled'.tr;

      default:
        return status.tr;
    }
  }

  // STATUS COLOR

  Color getStatusColor(
      String status,
      ) {

    switch (status.toLowerCase()) {

      case 'pending':
        return const Color(0xFFF59E0B);

      case 'confirmed':
        return const Color(0xFF56AB3E);

      case 'processing':
        return const Color(0xFF8B5CF6);

      case 'delivered':
        return const Color(0xFF4FC83F);

      case 'cancelled':
        return const Color(0xFFEF4444);

        case 'scheduled':
          return const Color(0xFF2563EB);


      default:
        return Colors.grey;
    }
  }

  // FORMAT DATE

  String formatDateTime(String date) {

    try {

      final parsed =
      DateTime.parse(date).toLocal();

      final day =
      parsed.day.toString().padLeft(2, '0');

      final month =
      parsed.month.toString().padLeft(2, '0');

      final year =
      parsed.year.toString();

      int hour =
          parsed.hour;

      final minute =
      parsed.minute.toString().padLeft(2, '0');

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
}