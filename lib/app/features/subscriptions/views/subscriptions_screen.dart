import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/utils/end_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/SubscriptionDetailsController.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SubscriptionDetailsController>(

      init: SubscriptionDetailsController(),

      builder: (controller) {

        // LOADER

        if (controller.isLoading) {

          return Scaffold(

            backgroundColor:
            const Color(0xFFF8FFF6),

            appBar: AppBar(
              elevation: 0,
              backgroundColor:
              const Color(0xFFF8FFF6),
            ),

            body: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4FC83F),
              ),
            ),
          );
        }

        // EMPTY

        if (controller.subscription == null) {

          return Scaffold(

            backgroundColor:
            const Color(0xFFF8FFF6),

            appBar: AppBar(
              elevation: 0,
              backgroundColor:
              const Color(0xFFF8FFF6),
            ),

            body: Center(
              child: Text(
                "no_subscription_found".tr,

                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        final item = controller.subscription!;

        // Parse plan start and end dates once
        final planStartDay = DateTime.parse(item.startAt.toString());
        final planEndDay   = DateTime.parse(item.endAt.toString());

        return Scaffold(

          backgroundColor:
          const Color(0xFFF8FFF6),

          appBar: AppBar(
            elevation: 0,

            backgroundColor:
            const Color(0xFFF8FFF6),

            surfaceTintColor:
            Colors.transparent,

            title: Text(
              "subscription_details".tr,

              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          // BUTTON

          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),

            child: SafeArea(
              child: SizedBox(
                height: 56,

                child: ElevatedButton(

                  // ENABLE ONLY WHEN DATE SELECTED

                  onPressed:
                  controller.rangeStart != null &&
                      controller.rangeEnd != null
                      ? () {

                    // RESUME FLOW

                    if (controller.isSelectedPausedDate()) {

                      Get.dialog(

                        Dialog(

                          backgroundColor:
                          Colors.white,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                28),
                          ),

                          child: Padding(
                            padding:
                            const EdgeInsets.all(
                                22),

                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,

                              children: [

                                Container(
                                  height: 72,
                                  width: 72,

                                  decoration:
                                  BoxDecoration(
                                    color: const Color(
                                        0xFF4FC83F)
                                        .withOpacity(
                                        .12),

                                    shape:
                                    BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.play_arrow_rounded,

                                    size: 38,

                                    color: Color(
                                        0xFF4FC83F),
                                  ),
                                ),

                                const SizedBox(
                                    height: 18),

                                Text(
                                  "resume_subscription"
                                      .tr,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize: 22,

                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),

                                const SizedBox(
                                    height: 10),

                                Text(
                                  "resume_subscription_desc"
                                      .tr,

                                  textAlign:
                                  TextAlign.center,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color: Colors
                                        .grey
                                        .shade700,

                                    height: 1.6,
                                  ),
                                ),

                                const SizedBox(
                                    height: 24),

                                Row(
                                  children: [

                                    Expanded(
                                      child:
                                      SizedBox(
                                        height:
                                        52,

                                        child:
                                        OutlinedButton(
                                          onPressed:
                                              () {
                                            Get.back();
                                          },

                                          child:
                                          Text(
                                            "cancel"
                                                .tr,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width:
                                        12),

                                    Expanded(
                                      child:
                                      SizedBox(
                                        height:
                                        52,

                                        child:
                                        ElevatedButton(
                                          onPressed:
                                              () {

                                            Get.back();

                                            controller.resumePausedPlan(controller.rangeStart!,
                                              controller
                                                  .rangeEnd!,
                                            );
                                          },

                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            const Color(
                                                0xFF4FC83F),
                                          ),

                                          child:
                                          Text(
                                            "resume"
                                                .tr,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    } else {

                      // PAUSE FLOW

                      Get.dialog(

                        Dialog(

                          backgroundColor:
                          Colors.white,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                28),
                          ),

                          child: Padding(
                            padding:
                            const EdgeInsets.all(
                                22),

                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,

                              children: [

                                Container(
                                  height: 72,
                                  width: 72,

                                  decoration:
                                  BoxDecoration(
                                    color: const Color(
                                        0xFFF59E0B)
                                        .withOpacity(
                                        .12),

                                    shape:
                                    BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons
                                        .pause_circle_rounded,

                                    size: 38,

                                    color: Color(
                                        0xFFF59E0B),
                                  ),
                                ),

                                const SizedBox(
                                    height: 18),

                                Text(
                                  "pause_subscription"
                                      .tr,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize: 22,

                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),

                                const SizedBox(
                                    height: 10),

                                Text(
                                  "pause_subscription_confirmation_desc"
                                      .tr,

                                  textAlign:
                                  TextAlign.center,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color: Colors
                                        .grey
                                        .shade700,

                                    height: 1.6,
                                  ),
                                ),

                                const SizedBox(
                                    height: 22),

                                Container(
                                  padding:
                                  const EdgeInsets
                                      .all(16),

                                  decoration:
                                  BoxDecoration(
                                    color: const Color(
                                        0xFFF8FFF6),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        18),
                                  ),

                                  child: Column(
                                    children: [

                                      _billRow(
                                        "pause_start_date"
                                            .tr,

                                        controller
                                            .formatDate(
                                          controller
                                              .rangeStart!,
                                        ),
                                      ),

                                      const SizedBox(
                                          height:
                                          12),

                                      _billRow(
                                        "pause_end_date"
                                            .tr,

                                        controller
                                            .formatDate(
                                          controller
                                              .rangeEnd!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                    height: 24),

                                Row(
                                  children: [

                                    Expanded(
                                      child:
                                      SizedBox(
                                        height:
                                        52,

                                        child:
                                        OutlinedButton(
                                          onPressed:
                                              () {
                                            Get.back();
                                          },

                                          child:
                                          Text(
                                            "cancel"
                                                .tr,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width:
                                        12),

                                    Expanded(
                                      child:
                                      SizedBox(
                                        height:
                                        52,

                                        child:
                                        ElevatedButton(
                                          onPressed:
                                              () {

                                            Get.back();

                                            controller
                                                .pausedPlan(
                                              controller
                                                  .rangeStart!,
                                              controller
                                                  .rangeEnd!,
                                            );
                                          },

                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            const Color(
                                                0xFF4FC83F),
                                          ),

                                          child:
                                          Text(
                                            "submit"
                                                .tr,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                      : null,

                  style:
                  ElevatedButton.styleFrom(
                    elevation: 0,

                    disabledBackgroundColor:
                    const Color(0xFF4FC83F)
                        .withOpacity(.35),

                    backgroundColor:
                    controller
                        .isSelectedPausedDate()
                        ? const Color(
                        0xFF2563EB)
                        : const Color(
                        0xFF4FC83F),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(
                        controller
                            .isSelectedPausedDate()
                            ? Icons.play_arrow_rounded
                            : Icons
                            .pause_circle_outline,

                        color: Colors.white,
                      ),

                      const SizedBox(width: 10),

                      Text(

                        controller
                            .isSelectedPausedDate()

                            ? "resume_subscription".tr

                            : controller.rangeStart !=
                            null &&
                            controller.rangeEnd !=
                                null

                            ? "pause_selected_days".tr

                            : "select_pause_dates"
                            .tr,

                        style:
                        GoogleFonts.poppins(
                          color: Colors.white,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(

            physics:
            const BouncingScrollPhysics(),

            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                // PRODUCT CARD

                Container(
                  padding:
                  const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(28),

                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(
                            .04),

                        blurRadius: 18,

                        offset:
                        const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            20),

                        child: Image.network(

                          EndPoints.mediaUrl(
                            item.productInfo
                                ?.productThumbnail
                                .toString() ??
                                '',
                          ),

                          height: 95,
                          width: 95,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (_, __, ___) {

                            return Container(
                              height: 95,
                              width: 95,

                              color:
                              Colors.grey.shade200,

                              child: const Icon(
                                Icons
                                    .image_not_supported,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              item.productInfo
                                  ?.productTitle ??
                                  '',

                              maxLines: 2,

                              overflow:
                              TextOverflow.ellipsis,

                              style:
                              GoogleFonts
                                  .poppins(
                                fontSize: 18,

                                fontWeight:
                                FontWeight
                                    .w700,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${item.productQty ?? 0} x ${item.productInfo?.productUnitTag ?? ''}",

                              style:
                              GoogleFonts
                                  .poppins(
                                color:
                                Colors.grey
                                    .shade700,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "₹${item.totalBill ?? '0'}",

                              style:
                              GoogleFonts
                                  .poppins(
                                color:
                                const Color(
                                    0xFF4FC83F),

                                fontSize: 24,

                                fontWeight:
                                FontWeight
                                    .w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // CALENDAR

                Container(
                  padding:
                  const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(28),

                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(
                            .04),

                        blurRadius: 18,

                        offset:
                        const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        "delivery_schedule".tr,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 18,

                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification:
                            (overscroll) {

                          overscroll
                              .disallowIndicator();

                          return true;
                        },

                        child: TableCalendar(

                          availableGestures:
                          AvailableGestures
                              .horizontalSwipe,

                          focusedDay:
                          controller.focusedDay,

                          firstDay: planStartDay,

                          lastDay: planEndDay,

                          rangeStartDay:
                          controller.rangeStart,

                          rangeEndDay:
                          controller.rangeEnd,

                          rangeSelectionMode:
                          RangeSelectionMode
                              .toggledOn,

                          onRangeSelected:
                              (
                              start,
                              end,
                              focusedDay,
                              ) {

                            controller
                                .onRangeSelected(
                              start,
                              end,
                              focusedDay,
                            );
                          },

                          onDaySelected:
                              (
                              selectedDay,
                              focusedDay,
                              ) {

                            // PAST DATE BLOCK

                            final today =
                            DateTime.now();

                            final cleanToday =
                            DateTime(
                              today.year,
                              today.month,
                              today.day,
                            );

                            final cleanDay =
                            DateTime(
                              selectedDay.year,
                              selectedDay.month,
                              selectedDay.day,
                            );

                            if (cleanDay
                                .isBefore(
                                cleanToday)) {
                              return;
                            }

                            // SELECT SINGLE DAY

                            controller
                                .onRangeSelected(
                              selectedDay,
                              selectedDay,
                              focusedDay,
                            );
                          },

                          headerStyle:
                          HeaderStyle(

                            formatButtonVisible:
                            false,

                            titleCentered:
                            true,

                            titleTextStyle:
                            GoogleFonts
                                .poppins(
                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),

                          calendarStyle:
                          CalendarStyle(

                            outsideDaysVisible:
                            false,

                            rangeHighlightColor:
                            const Color(
                                0xFFF59E0B)
                                .withOpacity(
                                .20),

                            rangeStartDecoration:
                            const BoxDecoration(
                              color: Color(
                                  0xFFF59E0B),

                              shape:
                              BoxShape.circle,
                            ),

                            rangeEndDecoration:
                            const BoxDecoration(
                              color: Color(
                                  0xFFEF4444),

                              shape:
                              BoxShape.circle,
                            ),

                            todayDecoration:
                            const BoxDecoration(
                              color: Color(
                                  0xFF111827),

                              shape:
                              BoxShape.circle,
                            ),
                          ),

                          calendarBuilders:
                          CalendarBuilders(

                            defaultBuilder:
                                (
                                context,
                                day,
                                _,
                                ) {

                              final isPaused =
                              controller
                                  .isPausedDay(
                                day,
                              );

                              final isDelivery =
                              controller
                                  .isDeliveryDay(
                                day,
                              );

                              final isLastDay =
                              controller
                                  .isSameDate(
                                day,
                                planEndDay,
                              );

                              // ── NEW: plan start date check ──
                              final isStartDay =
                              controller.isSameDate(
                                day,
                                planStartDay,
                              );

                              final today =
                              DateTime.now();

                              final cleanToday =
                              DateTime(
                                today.year,
                                today.month,
                                today.day,
                              );

                              final cleanDay =
                              DateTime(
                                day.year,
                                day.month,
                                day.day,
                              );

                              final isPast =
                              cleanDay
                                  .isBefore(
                                  cleanToday);

                              // ── Helper: day cell with label ──
                              Widget _dayCell({
                                required String dayNum,
                                required Color bgColor,
                                required Color textColor,
                                required String label,
                                required Color labelColor,
                                Border? border,
                                Gradient? gradient,
                                double borderRadius = 12,
                              }) {
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: gradient == null ? bgColor : null,
                                    gradient: gradient,
                                    border: border,
                                    borderRadius: BorderRadius.circular(borderRadius),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayNum,
                                        style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          height: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        label,
                                        style: GoogleFonts.poppins(
                                          color: labelColor,
                                          fontSize: 7,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // ── PAST + PAUSED (show paused even in past) ──
                              if (isPast && isPaused) {
                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: const Color(0xFFF59E0B),
                                  textColor: Colors.white,
                                  label: "paused".tr,
                                  labelColor: Colors.white.withOpacity(0.85),
                                );
                              }

                              // ── PAST DAY (not paused) ──
                              if (isPast) {
                                // Show start label on past start date if it falls in past
                                if (isStartDay) {
                                  return _dayCell(
                                    dayNum: "${day.day}",
                                    bgColor: Colors.blueGrey,
                                    textColor: Colors.white,
                                    label: "start".tr,
                                    labelColor: Colors.white,
                                  );
                                }

                                return Container(
                                  margin: const EdgeInsets
                                      .all(
                                      6),

                                  decoration:
                                  BoxDecoration(
                                    color: Colors
                                        .grey
                                        .shade100,

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        12),
                                  ),

                                  child: Center(
                                    child: Text(
                                      "${day.day}",

                                      style:
                                      GoogleFonts.poppins(
                                        color: Colors
                                            .grey
                                            .shade400,

                                        fontWeight:
                                        FontWeight
                                            .w600,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // ── LAST DAY + PAUSED ──

                              if (isPaused &&
                                  isLastDay) {

                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: Colors.transparent,
                                  textColor: Colors.white,
                                  label: "paused".tr,
                                  labelColor: Colors.white.withOpacity(0.85),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF59E0B),
                                      Color(0xFFEF4444),
                                    ],
                                  ),
                                );
                              }

                              // ── START DAY + PAUSED ──
                              if (isPaused && isStartDay) {
                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: Colors.transparent,
                                  textColor: Colors.white,
                                  label: "paused".tr,
                                  labelColor: Colors.white.withOpacity(0.85),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4FC83F),
                                      Color(0xFFF59E0B),
                                    ],
                                  ),
                                );
                              }

                              // ── LAST DAY ──

                              if (isLastDay) {
                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: const Color(0xFFEF4444).withOpacity(.14),
                                  textColor: const Color(0xFFEF4444),
                                  label: "end".tr,
                                  labelColor: const Color(0xFFEF4444),
                                  border: Border.all(
                                    color: const Color(0xFFEF4444),
                                    width: 1.5,
                                  ),
                                );
                              }

                              // ── START DAY (new highlight) ──
                              if (isStartDay) {
                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: const Color(0xFF4FC83F).withOpacity(.15),
                                  textColor: const Color(0xFF4FC83F),
                                  label: "start".tr,
                                  labelColor: const Color(0xFF4FC83F),
                                  border: Border.all(
                                    color: const Color(0xFF4FC83F),
                                    width: 1.5,
                                  ),
                                );
                              }

                              // ── PAUSED ──

                              if (isPaused) {
                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: const Color(0xFFF59E0B),
                                  textColor: Colors.white,
                                  label: "paused".tr,
                                  labelColor: Colors.white.withOpacity(0.85),
                                );
                              }

                              // ── DELIVERY ──

                              if (isDelivery) {
                                return _dayCell(
                                  dayNum: "${day.day}",
                                  bgColor: const Color(0xFF4FC83F).withOpacity(.15),
                                  textColor: const Color(0xFF4FC83F),
                                  label: "delivery".tr,
                                  labelColor: const Color(0xFF4FC83F),
                                );
                              }

                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // LEGEND ROW

                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _legendDot(
                            color: const Color(0xFF4FC83F),
                            label: "start".tr+' / ' +"scheduled".tr,
                          ),
                          _legendDot(
                            color: const Color(0xFFEF4444),
                            label: "end".tr,
                          ),
                          _legendDot(
                            color: const Color(0xFFF59E0B),
                            label: "paused".tr,
                          ),
                          _legendDot(
                            color: const Color(0xFF111827),
                            label: "today".tr,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ADDRESS ISSUE MESSAGE

                      if (item.address == null)

                        Container(
                          width: double.infinity,

                          padding:
                          const EdgeInsets.all(
                              16),

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                                0xFFEF4444)
                                .withOpacity(
                                .08),

                            borderRadius:
                            BorderRadius
                                .circular(
                                18),

                            border: Border.all(
                              color:
                              const Color(
                                  0xFFEF4444)
                                  .withOpacity(
                                  .20),
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              const Icon(
                                Icons.warning_amber_rounded,

                                color: Color(
                                    0xFFEF4444),
                              ),

                              const SizedBox(
                                  width: 12),

                              Expanded(
                                child: Text(
                                  "address_deleted_message"
                                      .tr,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color:
                                    const Color(
                                        0xFF991B1B),

                                    height:
                                    1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 14),

                      // NOTE

                      Container(
                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(
                            14),

                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                              0xFF111827)
                              .withOpacity(
                              .04),

                          borderRadius:
                          BorderRadius.circular(
                              16),
                        ),

                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            const Icon(
                              Icons
                                  .info_outline_rounded,

                              size: 18,

                              color:
                              Color(
                                  0xFF111827),
                            ),

                            const SizedBox(
                                width: 10),

                            Expanded(
                              child: Text(
                                "pause_cutoff_note"
                                    .tr,

                                style:
                                GoogleFonts
                                    .poppins(
                                  fontSize: 12,

                                  height: 1.6,

                                  color: Colors
                                      .grey
                                      .shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ADDRESS CARD

                if (item.address != null)

                  Container(
                    padding:
                    const EdgeInsets.all(18),

                    decoration:
                    BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                          28),
                    ),

                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Container(
                          height: 48,
                          width: 48,

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                                0xFF4FC83F)
                                .withOpacity(
                                .12),

                            borderRadius:
                            BorderRadius
                                .circular(
                                14),
                          ),

                          child: const Icon(
                            Icons
                                .location_on_rounded,

                            color:
                            Color(
                                0xFF4FC83F),
                          ),
                        ),

                        const SizedBox(
                            width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Text(
                                item.address
                                    ?.holderName ??
                                    '',

                                style:
                                GoogleFonts
                                    .poppins(
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                "${item.address?.building ?? ''}, ${item.address?.landmark ?? ''}",

                                style:
                                GoogleFonts
                                    .poppins(
                                  color: Colors
                                      .grey
                                      .shade700,

                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 18),

                // BILL SUMMARY

                Container(
                  padding:
                  const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                        28),
                  ),

                  child: Column(
                    children: [

                      _billRow(
                        "subscription_amount"
                            .tr,

                        "₹${item.totalBill ?? '0'}",
                      ),

                      const SizedBox(height: 14),

                      _billRow(
                        "payment_mode".tr,

                        item.paymentMode ?? '',
                      ),

                      const SizedBox(height: 14),

                      _billRow(
                        "plan_duration".tr,

                        "${item.planDuration ?? 0} ${'days'.tr}",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Small colored dot + label for the legend row
  Widget _legendDot({
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _billRow(
      String title,
      String value,
      ) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style: GoogleFonts.poppins(
            color:
            Colors.grey.shade700,
          ),
        ),

        Text(
          value,

          style: GoogleFonts.poppins(
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ],
    );
  }
}