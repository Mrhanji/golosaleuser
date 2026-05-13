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

          // BOTTOM BUTTON

          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),

            child: SafeArea(
              child: SizedBox(
                height: 56,

                child: ElevatedButton(
                  onPressed:
                  controller.rangeStart != null &&
                      controller.rangeEnd != null
                      ? () {

                    Get.dialog(

                      Dialog(

                        backgroundColor:
                        Colors.white,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(28),
                        ),

                        child: Padding(
                          padding:
                          const EdgeInsets.all(22),

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
                                      .withOpacity(.12),

                                  shape:
                                  BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.pause_circle_rounded,

                                  size: 38,

                                  color:
                                  Color(0xFFF59E0B),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Text(
                                "pause_subscription".tr,

                                style:
                                GoogleFonts.poppins(
                                  fontSize: 22,

                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "pause_subscription_confirmation_desc"
                                    .tr,

                                textAlign:
                                TextAlign.center,

                                style:
                                GoogleFonts.poppins(
                                  color: Colors
                                      .grey.shade700,

                                  height: 1.6,
                                ),
                              ),

                              const SizedBox(height: 22),

                              Container(
                                padding:
                                const EdgeInsets.all(
                                    16),

                                decoration:
                                BoxDecoration(
                                  color: const Color(
                                      0xFFF8FFF6),

                                  borderRadius:
                                  BorderRadius
                                      .circular(18),
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
                                        height: 12),

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

                              const SizedBox(height: 24),

                              Row(
                                children: [

                                  Expanded(
                                    child: SizedBox(
                                      height: 52,

                                      child:
                                      OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },

                                        style:
                                        OutlinedButton
                                            .styleFrom(
                                          side:
                                          const BorderSide(
                                            color: Color(
                                                0xFFE5E7EB),
                                          ),

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                16),
                                          ),
                                        ),

                                        child: Text(
                                          "cancel".tr,

                                          style:
                                          GoogleFonts
                                              .poppins(
                                            color: const Color(
                                                0xFF111827),

                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: SizedBox(
                                      height: 52,

                                      child:
                                      ElevatedButton(
                                        onPressed: () {

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
                                        ElevatedButton
                                            .styleFrom(
                                          elevation: 0,

                                          backgroundColor:
                                          const Color(
                                              0xFF4FC83F),

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                16),
                                          ),
                                        ),

                                        child: Text(
                                          "submit".tr,

                                          style:
                                          GoogleFonts
                                              .poppins(
                                            color:
                                            Colors.white,

                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
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
                      : null,

                  style:
                  ElevatedButton.styleFrom(
                    elevation: 0,

                    disabledBackgroundColor:
                    const Color(0xFF4FC83F)
                        .withOpacity(.35),

                    backgroundColor:
                    const Color(0xFF4FC83F),

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

                      const Icon(
                        Icons.pause_circle_outline,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        controller.rangeStart !=
                            null &&
                            controller.rangeEnd !=
                                null
                            ? "pause_selected_days"
                            .tr
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
                        Colors.black.withOpacity(.04),

                        blurRadius: 18,

                        offset:
                        const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      // PRODUCT IMAGE

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
                    BorderRadius.circular(
                        28),

                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(.04),

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

                      // CALENDAR

                      TableCalendar(

                        focusedDay:
                        controller.focusedDay,

                        firstDay: DateTime.parse(
                          item.startAt.toString(),
                        ),

                        // REMOVED +1

                        lastDay: DateTime.parse(
                          item.endAt.toString(),
                        ),

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
                              .withOpacity(.20),

                          rangeStartDecoration:
                          const BoxDecoration(
                            color:
                            Color(
                                0xFFF59E0B),

                            shape:
                            BoxShape.circle,
                          ),

                          rangeEndDecoration:
                          const BoxDecoration(
                            color:
                            Color(
                                0xFFEF4444),

                            shape:
                            BoxShape.circle,
                          ),

                          todayDecoration:
                          const BoxDecoration(
                            color:
                            Color(
                                0xFF111827),

                            shape:
                            BoxShape.circle,
                          ),
                        ),

                        calendarBuilders:
                        CalendarBuilders(

                          // DEFAULT

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

                            final lastPlanDay =
                            DateTime.parse(
                              item.endAt
                                  .toString(),
                            );

                            final isLastDay =
                            controller
                                .isSameDate(
                              day,
                              lastPlanDay,
                            );

                            // LAST DAY + PAUSED

                            if (isPaused &&
                                isLastDay) {

                              return Container(
                                margin:
                                const EdgeInsets
                                    .all(6),

                                decoration:
                                BoxDecoration(

                                  gradient:
                                  const LinearGradient(
                                    colors: [
                                      Color(
                                          0xFFF59E0B),
                                      Color(
                                          0xFFEF4444),
                                    ],
                                  ),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12),
                                ),

                                child: Center(
                                  child: Text(
                                    "${day.day}",

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      color: Colors
                                          .white,

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // LAST DAY

                            if (isLastDay) {

                              return Container(
                                margin:
                                const EdgeInsets
                                    .all(6),

                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                      0xFFEF4444)
                                      .withOpacity(
                                      .14),

                                  border:
                                  Border.all(
                                    color:
                                    const Color(
                                        0xFFEF4444),

                                    width:
                                    1.5,
                                  ),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12),
                                ),

                                child: Center(
                                  child: Text(
                                    "${day.day}",

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      color:
                                      const Color(
                                          0xFFEF4444),

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // PAUSED

                            if (isPaused) {

                              return Container(
                                margin:
                                const EdgeInsets
                                    .all(6),

                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                      0xFFF59E0B),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12),
                                ),

                                child: Center(
                                  child: Text(
                                    "${day.day}",

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      color:
                                      Colors
                                          .white,

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // DELIVERY

                            if (isDelivery) {

                              return Container(
                                margin:
                                const EdgeInsets
                                    .all(6),

                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                      0xFF4FC83F)
                                      .withOpacity(
                                      .15),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12),
                                ),

                                child: Center(
                                  child: Text(
                                    "${day.day}",

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      color:
                                      const Color(
                                          0xFF4FC83F),

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return null;
                          },

                          // RANGE START

                          rangeStartBuilder:
                              (
                              context,
                              day,
                              focusedDay,
                              ) {

                            return Container(
                              margin:
                              const EdgeInsets
                                  .all(6),

                              decoration:
                              BoxDecoration(
                                color:
                                const Color(
                                    0xFFF59E0B),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    12),
                              ),

                              child: Center(
                                child: Text(
                                  "${day.day}",

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ),
                            );
                          },

                          // RANGE END

                          rangeEndBuilder:
                              (
                              context,
                              day,
                              focusedDay,
                              ) {

                            return Container(
                              margin:
                              const EdgeInsets
                                  .all(6),

                              decoration:
                              BoxDecoration(
                                color:
                                const Color(
                                    0xFFEF4444),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    12),
                              ),

                              child: Center(
                                child: Text(
                                  "${day.day}",

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ),
                            );
                          },

                          // SINGLE DAY

                          selectedBuilder:
                              (
                              context,
                              day,
                              focusedDay,
                              ) {

                            return Container(
                              margin:
                              const EdgeInsets
                                  .all(6),

                              decoration:
                              BoxDecoration(
                                color:
                                const Color(
                                    0xFFF59E0B),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    12),
                              ),

                              child: Center(
                                child: Text(
                                  "${day.day}",

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // INFO BOXES

                      Column(
                        children: [

                          // SELECTED DATES

                          if (controller.rangeStart !=
                              null &&
                              controller.rangeEnd !=
                                  null)

                            Container(
                              width: double.infinity,

                              padding:
                              const EdgeInsets
                                  .all(16),

                              decoration:
                              BoxDecoration(
                                color:
                                const Color(
                                    0xFFF59E0B)
                                    .withOpacity(
                                    .08),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    18),

                                border:
                                Border.all(
                                  color:
                                  const Color(
                                      0xFFF59E0B)
                                      .withOpacity(
                                      .25),
                                ),
                              ),

                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  const Icon(
                                    Icons
                                        .pause_circle_outline,

                                    color:
                                    Color(
                                        0xFFF59E0B),
                                  ),

                                  const SizedBox(
                                      width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                      children: [

                                        Text(
                                          "selected_pause_dates"
                                              .tr,

                                          style:
                                          GoogleFonts
                                              .poppins(
                                            fontWeight:
                                            FontWeight
                                                .w700,

                                            color:
                                            const Color(
                                                0xFF92400E),
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                            6),

                                        Text(
                                          "${controller.formatDate(controller.rangeStart!)} - ${controller.formatDate(controller.rangeEnd!)}",

                                          style:
                                          GoogleFonts
                                              .poppins(
                                            color:
                                            const Color(
                                                0xFF92400E),

                                            height:
                                            1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 14),

                          // CUTOFF NOTE

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
                              BorderRadius
                                  .circular(
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

                                      height:
                                      1.6,

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

                      const SizedBox(height: 14),

                      // LEGENDS

                      Row(
                        children: [

                          _legend(
                            const Color(
                                0xFF4FC83F),

                            "delivery_day".tr,
                          ),

                          const SizedBox(width: 18),

                          _legend(
                            const Color(
                                0xFFF59E0B),

                            "paused_day".tr,
                          ),

                          const SizedBox(width: 18),

                          _legend(
                            const Color(
                                0xFFEF4444),

                            "last_day".tr,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ADDRESS CARD

                Container(
                  padding:
                  const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                        28),
                  ),

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Container(
                        height: 48,
                        width: 48,

                        decoration: BoxDecoration(
                          color:
                          const Color(
                              0xFF4FC83F)
                              .withOpacity(.12),

                          borderRadius:
                          BorderRadius.circular(
                              14),
                        ),

                        child: const Icon(
                          Icons.location_on_rounded,

                          color:
                          Color(0xFF4FC83F),
                        ),
                      ),

                      const SizedBox(width: 14),

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

                            const SizedBox(height: 5),

                            Text(
                              "${item.address?.building ?? ''}, ${item.address?.landmark ?? ''}",

                              style:
                              GoogleFonts
                                  .poppins(
                                color:
                                Colors.grey
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

  Widget _legend(
      Color color,
      String text,
      ) {

    return Row(
      children: [

        Container(
          height: 14,
          width: 14,

          decoration: BoxDecoration(
            color: color,

            borderRadius:
            BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          text,

          style: GoogleFonts.poppins(
            fontSize: 12,
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