import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/features/home/controller/home_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/subscription_details_model.dart';
import '../service/subscription_service.dart';

class SubscriptionDetailsController extends GetxController {

  bool isLoading = false;

  // DETAILS MODEL

  SubscriptionDetailsModel subscriptionDetails =
  SubscriptionDetailsModel();

  // CURRENT SUBSCRIPTION

  Data? subscription;

  // CALENDAR

  DateTime focusedDay = DateTime.now();

  DateTime? selectedDay;

  DateTime? rangeStart;

  DateTime? rangeEnd;

  RangeSelectionMode rangeSelectionMode =
      RangeSelectionMode.toggledOn;

  // ARGUMENT

  dynamic subscriptionId;

  // PAUSE CUT OFF TIME

  int pauseCutoffHour = 23;

  // MESSAGE

  String pauseInfoMessage =
      "Orders can only be paused before 11:00 PM for same day delivery. Requests after cutoff time may still be delivered because order processing may already be completed.";

  @override
  void onInit() {
    super.onInit();

    subscriptionId = Get.arguments;

    loadSubscriptionDetails();
  }

  // LOAD DETAILS

  void loadSubscriptionDetails() async {

    try {

      isLoading = true;

      update();

      subscriptionDetails =
      await SubscriptionServices()
          .getSubscriptionInfo(
        subscriptionId.toString(),
      );

      if (subscriptionDetails.data != null &&
          subscriptionDetails.data!.isNotEmpty) {

        subscription =
            subscriptionDetails.data!.first;

        focusedDay = DateTime.parse(
          subscription!.startAt.toString(),
        );
      }

    } catch (e) {

      debugPrint(
        "Subscription Details Error: $e",
      );

    } finally {

      isLoading = false;

      update();
    }
  }

  // FORMAT DATE

  String formatDate(DateTime date) {

    return "${date.day}/${date.month}/${date.year}";
  }

  // SAME DATE

  bool isSameDate(
      DateTime a,
      DateTime b,
      ) {

    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  // TODAY CHECK

  bool isToday(DateTime date) {

    final now = DateTime.now();

    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  // FUTURE DATE CHECK

  bool isFutureOrToday(
      DateTime date,
      ) {

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return !selected.isBefore(today);
  }

  // PAST DATE CHECK

  bool isPastDate(
      DateTime date,
      ) {

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return selected.isBefore(today);
  }

  // CUTOFF CHECK

  bool isPauseAllowedForToday() {

    final now = DateTime.now();

    return now.hour < pauseCutoffHour;
  }

  // VALIDATE PAUSE

  bool validatePauseSelection(
      DateTime start,
      DateTime end,
      ) {

    // PAST DATE BLOCK

    if (isPastDate(start) ||
        isPastDate(end)) {

      Get.snackbar(

        "invalid_selection".tr,

        "past_dates_not_allowed".tr,

        snackPosition:
        SnackPosition.BOTTOM,

        backgroundColor:
        const Color(0xFFEF4444),

        colorText: Colors.white,

        margin:
        const EdgeInsets.all(16),
      );

      return false;
    }

    // TODAY CUT OFF CHECK

    if (isToday(start)) {

      if (!isPauseAllowedForToday()) {

        Get.snackbar(

          "pause_not_allowed".tr,

          "pause_after_cutoff_message"
              .tr,

          snackPosition:
          SnackPosition.BOTTOM,

          backgroundColor:
          const Color(0xFFEF4444),

          colorText: Colors.white,

          margin:
          const EdgeInsets.all(16),
        );

        return false;
      }
    }

    return true;
  }

  // RANGE SELECT

  void onRangeSelected(
      DateTime? start,
      DateTime? end,
      DateTime focused,
      ) {

    if (start == null) return;

    // SINGLE DAY SUPPORT

    end ??= start;

    // VALIDATE

    final valid =
    validatePauseSelection(
      start,
      end,
    );

    if (!valid) {
      return;
    }

    focusedDay = focused;

    rangeStart = start;

    rangeEnd = end;

    rangeSelectionMode =
        RangeSelectionMode.toggledOn;

    update();
  }

  // CLEAR SELECTION

  void clearSelection() {

    rangeStart = null;

    rangeEnd = null;

    update();
  }

  // ACTIVE DELIVERY DAYS

  List<DateTime> getActiveDays() {

    final List<DateTime> activeDays = [];

    if (subscription == null) {
      return activeDays;
    }

    if (subscription!.startAt == null ||
        subscription!.endAt == null) {
      return activeDays;
    }

    final start =
    DateTime.parse(
      subscription!.startAt.toString(),
    );

    final end =
    DateTime.parse(
      subscription!.endAt.toString(),
    );

    for (int i = 0;
    i <= end.difference(start).inDays;
    i++) {

      activeDays.add(
        DateTime(
          start.year,
          start.month,
          start.day + i,
        ),
      );
    }

    return activeDays;
  }

  // PAUSED DAYS

  List<DateTime> getPausedDays() {

    final List<DateTime> pausedDays = [];

    if (subscription == null ||
        subscription!.days == null) {
      return pausedDays;
    }

    for (var pause in subscription!.days!) {

      if (pause.pauseAt == null ||
          pause.reStartAt == null) {
        continue;
      }

      final start =
      DateTime.parse(
        pause.pauseAt.toString(),
      );

      final end =
      DateTime.parse(
        pause.reStartAt.toString(),
      );

      for (int i = 0;
      i <= end.difference(start).inDays;
      i++) {

        pausedDays.add(
          DateTime(
            start.year,
            start.month,
            start.day + i,
          ),
        );
      }
    }

    return pausedDays;
  }

  // DELIVERY DAY

  bool isDeliveryDay(
      DateTime day,
      ) {

    final activeDays =
    getActiveDays();

    final pausedDays =
    getPausedDays();

    final isActive =
    activeDays.any(
          (e) => isSameDate(e, day),
    );

    final isPaused =
    pausedDays.any(
          (e) => isSameDate(e, day),
    );

    return isActive && !isPaused;
  }

  // PAUSED DAY

  bool isPausedDay(
      DateTime day,
      ) {

    final pausedDays =
    getPausedDays();

    return pausedDays.any(
          (e) => isSameDate(e, day),
    );
  }

  // SELECTED DATE IS PAUSED

  bool isSelectedPausedDate() {

    if (rangeStart == null ||
        rangeEnd == null) {
      return false;
    }

    // PAST DATE BLOCK

    if (isPastDate(rangeStart!) ||
        isPastDate(rangeEnd!)) {
      return false;
    }

    final pausedDays =
    getPausedDays();

    return pausedDays.any(
          (e) =>
          isSameDate(
            e,
            rangeStart!,
          ),
    );
  }

  // PAUSE PLAN

  Future<void> pausedPlan(
      DateTime start,
      DateTime end,
      ) async {

    try {
      Map<String,dynamic>dataBody={
        "subscriptionId": subscriptionId,
        "userId": Get.put(HomeController()).userModel.data!.userId.toString(),
        "pauseAt": start.toString(),
        "reStartAt": end.toString()
      };

      var response=await SubscriptionServices().updateSubscriptionStatus(dataBody);
      print("Response $response");
      debugPrint(
        "Pause Plan => $start - $end",
      );

      // CALL API HERE

      Get.snackbar(

        "success".tr,

        "subscription_paused_successfully"
            .tr,

        snackPosition:
        SnackPosition.BOTTOM,

        backgroundColor:
        const Color(0xFF4FC83F),

        colorText: Colors.white,

        margin:
        const EdgeInsets.all(16),
      );

      clearSelection();

      loadSubscriptionDetails();

    } catch (e) {

      debugPrint(
        "Pause Plan Error => $e",
      );
    }
  }

  // RESUME PLAN

  Future<void> resumePausedPlan(DateTime start, DateTime end,) async {

    try {

      List<int> dateIds = [];

      final cleanStart = DateTime(
        start.year,
        start.month,
        start.day,
      );

      final cleanEnd = DateTime(
        end.year,
        end.month,
        end.day,
      );

      for (int i = 0; i < subscription!.days!.length; i++) {

        final pauseDate =
        DateTime.parse(
          subscription!.days![i]
              .pauseAt
              .toString(),
        );

        final restartDate =
        DateTime.parse(
          subscription!.days![i]
              .reStartAt
              .toString(),
        );

        final cleanPauseDate =
        DateTime(
          pauseDate.year,
          pauseDate.month,
          pauseDate.day,
        );

        final cleanRestartDate =
        DateTime(
          restartDate.year,
          restartDate.month,
          restartDate.day,
        );

        print(
            "Days id-> ${subscription!.days![i].id}"
                " - pause:$cleanPauseDate"
                " - restart:$cleanRestartDate"
        );

        // NORMAL RANGE

        final isPauseInRange =
            !cleanPauseDate.isBefore(cleanStart) &&
                !cleanPauseDate.isAfter(cleanEnd);

        // IMPORTANT
        // INCLUDE LAST DAY USING restartAt

        final isLastDay =
            cleanRestartDate == cleanEnd;

        if (isPauseInRange || isLastDay) {

          dateIds.add(
            subscription!.days![i].id!,
          );
        }
      }

      print("dateIds => $dateIds");

      debugPrint(
        "Resume Plan => $start - $end",
      );



      Map<String, dynamic> dataBody = {
        "subscriptionId": subscriptionId,
        "statusIds": dateIds,
      };

      print("dataBody => ${jsonEncode(dataBody)}");
      var response=await SubscriptionServices().removeSubscriptionsStatus(dataBody);
      print("Response ${response}");
      // CALL API HERE

      Get.snackbar(

        "success".tr,

        "subscription_resumed_successfully"
            .tr,

        snackPosition:
        SnackPosition.BOTTOM,

        backgroundColor:
        const Color(0xFF2563EB),

        colorText: Colors.white,

        margin:
        const EdgeInsets.all(16),
      );

      clearSelection();

      loadSubscriptionDetails();

    } catch (e) {

      debugPrint(
        "Resume Plan Error => $e",
      );
    }
  }

  // TOTAL PAUSED DAYS

  int getTotalPausedDays() {

    return getPausedDays().length;
  }

  // TOTAL DELIVERY DAYS

  int getTotalDeliveryDays() {

    return getActiveDays()
        .where(
          (day) =>
      !isPausedDay(day),
    )
        .length;
  }

  // TOTAL PLAN DAYS

  int getTotalPlanDays() {

    return getActiveDays().length;
  }

  // PROGRESS

  double getProgress() {

    final total =
    getTotalPlanDays();

    final delivered =
    getTotalDeliveryDays();

    if (total == 0) return 0;

    return delivered / total;
  }

  // STATUS TEXT

  String getStatusText(
      String status,
      ) {

    switch (status.toLowerCase()) {

      case 'scheduled':
        return 'scheduled'.tr;

      case 'completed':
        return 'completed'.tr;

      case 'canceled':
        return 'canceled'.tr;

      case 'halt':
        return 'halt'.tr;

      default:
        return status.tr;
    }
  }

  // STATUS COLOR

  int getStatusColor(
      String status,
      ) {

    switch (status.toLowerCase()) {

      case 'scheduled':
        return 0xFF4FC83F;

      case 'completed':
        return 0xFF2563EB;

      case 'halt':
        return 0xFFF59E0B;

      case 'canceled':
        return 0xFFEF4444;

      default:
        return 0xFF6B7280;
    }
  }
}