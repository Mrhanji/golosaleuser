import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/utils/end_points.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/order_details_controller.dart';
import '../model/order_details_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key});

  final OrderDetailsController controller =
  Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF7FBF6),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        const Color(0xFFF7FBF6),

        surfaceTintColor:
        Colors.transparent,

        centerTitle: true,

        title: Text(
          "order_details".tr,

          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      body: GetBuilder<OrderDetailsController>(

        init: controller,

        builder: (_) {

          if (controller.isLoading) {

            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4FC83F),
              ),
            );
          }

          final Data? order =
              controller.orderDetailsModel.data;

          if (order == null) {

            return Center(
              child: Text(
                "no_order_found".tr,
              ),
            );
          }

          return SingleChildScrollView(

            padding:
            const EdgeInsets.all(16),

            physics:
            const BouncingScrollPhysics(),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // HEADER

                _headerCard(order),

                const SizedBox(height: 18),

                // TRACKING

                _trackingCard(order),

                const SizedBox(height: 18),

                // DELIVERY AGENT

                if (order.assignedDeliveryAgent !=
                    null)

                  _deliveryAgentCard(
                    order,
                  ),

                if (order.assignedDeliveryAgent !=
                    null)

                  const SizedBox(height: 18),

                // ADDRESS

                _addressCard(order),

                const SizedBox(height: 18),

                // ITEMS

                Text(
                  "ordered_items".tr,

                  style:
                  GoogleFonts.poppins(
                    fontWeight:
                    FontWeight.w700,

                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 14),

                ...order.orderItems!
                    .map(
                      (e) =>
                      _itemTile(e),
                )
                    .toList(),

                const SizedBox(height: 18),

                // BILL SUMMARY

                _billSection(order),

                const SizedBox(height: 18),

                /// CANCEL BUTTON

                if (order.orderStatus
                    .toString()
                    .toLowerCase() !=
                    "scheduled" &&
                    order.isSubscriptionOrder != true)

                  SizedBox(

                    width: double.infinity,
                    height: 56,

                    child: order.orderStatus
                        .toString()
                        .toLowerCase() ==
                        "cancelled"

                    /// CANCELLED UI
                        ? Container(

                      decoration: BoxDecoration(

                        color: Colors.red.withOpacity(.08),

                        borderRadius:
                        BorderRadius.circular(18),

                        border: Border.all(
                          color: Colors.red.withOpacity(.18),
                        ),
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Container(

                            padding:
                            const EdgeInsets.all(7),

                            decoration: BoxDecoration(
                              color: Colors.red
                                  .withOpacity(.10),

                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Text(
                            "order_cancelled".tr,

                            style:
                            GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight:
                              FontWeight.w700,

                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )

                    /// NORMAL CANCEL BUTTON
                        : ElevatedButton.icon(

                      onPressed: () {

                        Get.dialog(

                          AlertDialog(

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  24),
                            ),

                            title: Text(
                              "cancel_order".tr,

                              style:
                              GoogleFonts.poppins(
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            content: Text(
                              "cancel_order_confirmation"
                                  .tr,

                              style:
                              GoogleFonts.poppins(),
                            ),

                            actions: [

                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },

                                child: Text(
                                  "close".tr,
                                ),
                              ),

                              ElevatedButton(

                                onPressed: () {

                                  Get.back();

                                  controller.cancelOrder(
                                    order.orderId
                                        .toString(),
                                  );
                                },

                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors.red,
                                ),

                                child: Text(
                                  "cancel_order".tr,

                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ),

                      style: ElevatedButton.styleFrom(

                        elevation: 0,

                        backgroundColor:
                        Colors.red,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              18),
                        ),
                      ),

                      label: Text(
                        "cancel_order".tr,

                        style:
                        GoogleFonts.poppins(
                          color: Colors.white,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // SUBSCRIPTION ORDER NOTE

                if (order.isSubscriptionOrder == true)

                  Container(

                    width: double.infinity,

                    margin:
                    const EdgeInsets.only(
                        top: 10),

                    padding:
                    const EdgeInsets.all(
                        16),

                    decoration: BoxDecoration(

                      color:
                      const Color(0xFF4FC83F)
                          .withOpacity(.08),

                      borderRadius:
                      BorderRadius.circular(
                          18),

                      border: Border.all(
                        color:
                        const Color(
                            0xFF4FC83F)
                            .withOpacity(.18),
                      ),
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.autorenew_rounded,

                          color:
                          Color(0xFF4FC83F),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            "subscription_orders_cannot_be_cancelled"
                                .tr,

                            style:
                            GoogleFonts
                                .poppins(
                              color:
                              const Color(
                                  0xFF4FC83F),

                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // HEADER

  Widget _headerCard(Data order) {

    Color statusColor =
    controller.getStatusColor(
      order.orderStatus.toString(),
    );

    return Container(

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

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          if (order.isSubscriptionOrder ==
              true)

            Container(

              margin:
              const EdgeInsets.only(
                  bottom: 14),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              decoration: BoxDecoration(

                color:
                const Color(0xFF4FC83F)
                    .withOpacity(.10),

                borderRadius:
                BorderRadius.circular(
                    50),
              ),

              child: Row(
                mainAxisSize:
                MainAxisSize.min,

                children: [

                  const Icon(
                    Icons.autorenew_rounded,

                    size: 18,

                    color:
                    Color(0xFF4FC83F),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "subscription_order".tr,

                    style:
                    GoogleFonts.poppins(
                      color:
                      const Color(
                          0xFF4FC83F),

                      fontWeight:
                      FontWeight.w600,

                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "order_no".tr,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 11,

                      color:
                      Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "#ODR-${order.orderNumber}",

                    style:
                    GoogleFonts.poppins(
                      fontSize: 18,

                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),

              Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(

                  color:
                  statusColor.withOpacity(
                      .10),

                  borderRadius:
                  BorderRadius.circular(
                      50),
                ),

                child: Text(

                  controller.getStatusText(
                    order.orderStatus
                        .toString(),
                  ),

                  style:
                  GoogleFonts.poppins(
                    color: statusColor,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "ordered_on".tr,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 11,

                      color:
                      Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    controller.formatDateTime(
                      order.createdOn
                          .toString(),
                    ),

                    style:
                    GoogleFonts.poppins(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,

                children: [

                  Text(
                    "payment_mode".tr,

                    style:
                    GoogleFonts.poppins(
                      fontSize: 11,

                      color:
                      Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    order.paymentMode
                        .toString(),

                    style:
                    GoogleFonts.poppins(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TRACKING

  Widget _trackingCard(Data order) {

    final updates = order.orderUpdates ?? [];

    final List<Map<String, dynamic>> trackingSteps = [

      {
        "key": "pending",
        "title": "Pending",
        "icon": Icons.receipt_long_rounded,
      },

      {
        "key": "confirmed",
        "title": "Confirmed",
        "icon": Icons.check_circle_outline_rounded,
      },

      {
        "key": "preparing",
        "title": "Preparing",
        "icon": Icons.inventory_2_rounded,
      },

      {
        "key": "otw",
        "title": "On Way",
        "icon": Icons.local_shipping_rounded,
      },

      {
        "key": "delivered",
        "title": "Delivered",
        "icon": Icons.home_rounded,
      },
    ];

    final currentStatus =
    order.orderStatus
        .toString()
        .toLowerCase();

    // CANCELLED

    if (currentStatus == "cancelled") {

      return Container(

        width: Get.width,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          children: [

            Container(
              height: 62,
              width: 62,

              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.10),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 30,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              "order_cancelled".tr,

              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "this_order_has_been_cancelled".tr,

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // CURRENT INDEX

    int currentIndex = trackingSteps.indexWhere(
          (e) => e["key"] == currentStatus,
    );

    if (currentIndex == -1) {
      currentIndex = 0;
    }

    return Container(

      width: Get.width,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            "order_tracking".tr,

            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 24),

          Row(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: List.generate(
              trackingSteps.length,

                  (index) {

                final step =
                trackingSteps[index];

                final bool isCompleted =
                    index < currentIndex;

                final bool isCurrent =
                    index == currentIndex;

                final bool isPending =
                    index > currentIndex;

                // FIND UPDATE

                final update =
                updates.firstWhereOrNull(

                      (e) =>
                  e.updateType
                      .toString()
                      .toLowerCase() ==
                      step["key"],
                );

                final time =
                update != null

                    ? controller
                    .formatDateTime(
                  update.createdOn
                      .toString(),
                )

                    : "--";

                return Expanded(

                  child: Column(
                    children: [

                      // TOP TRACK

                      Row(
                        children: [

                          // LEFT LINE

                          if (index != 0)

                            Expanded(
                              child: Container(
                                height: 2.5,

                                color:
                                isCompleted ||
                                    isCurrent

                                    ? const Color(
                                    0xFF4FC83F)

                                    : Colors.grey
                                    .shade200,
                              ),
                            ),

                          // ICON

                          AnimatedContainer(

                            duration:
                            const Duration(
                                milliseconds:
                                250),

                            height: 38,
                            width: 38,

                            decoration: BoxDecoration(

                              shape: BoxShape.circle,

                              color: isCompleted
                                  ? const Color(
                                  0xFF4FC83F)

                                  : isCurrent

                                  ? const Color(
                                  0xFF4FC83F)

                                  : Colors.grey
                                  .shade100,

                              boxShadow: isCurrent
                                  ? [
                                BoxShadow(
                                  color: const Color(
                                      0xFF4FC83F)
                                      .withOpacity(
                                      .25),

                                  blurRadius: 12,
                                ),
                              ]
                                  : [],
                            ),

                            child: Icon(

                              isCompleted
                                  ? Icons.check_rounded
                                  : step["icon"],

                              color: isCompleted ||
                                  isCurrent
                                  ? Colors.white
                                  : Colors.grey
                                  .shade500,

                              size: 17,
                            ),
                          ),

                          // RIGHT LINE

                          if (index !=
                              trackingSteps.length -
                                  1)

                            Expanded(
                              child: Container(
                                height: 2.5,

                                color: index <
                                    currentIndex

                                    ? const Color(
                                    0xFF4FC83F)

                                    : Colors.grey
                                    .shade200,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // TITLE

                      Text(
                        step["title"],

                        textAlign:
                        TextAlign.center,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 9,

                          fontWeight:
                          FontWeight.w700,

                          color: isPending
                              ? Colors
                              .grey
                              .shade500
                              : Colors.black,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // TIME

                      Text(
                        time,

                        textAlign:
                        TextAlign.center,

                        maxLines: 2,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 7.5,

                          height: 1.4,

                          color:
                          Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // DELIVERY AGENT

  Widget _deliveryAgentCard(Data order) {

    final agent =
    order.assignedDeliveryAgent!;

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(28),
      ),

      child: Row(
        children: [

          Container(

            height: 62,
            width: 62,

            decoration: BoxDecoration(

              color:
              const Color(0xFF4FC83F)
                  .withOpacity(.12),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.delivery_dining_rounded,

              size: 30,

              color: Color(0xFF4FC83F),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "${agent.firstName ?? ''} ${agent.lastName ?? ''}",

                  style:
                  GoogleFonts.poppins(
                    fontWeight:
                    FontWeight.w700,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  agent.mobile.toString(),

                  style:
                  GoogleFonts.poppins(
                    color:
                    Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color:
              agent.isOnline == 1
                  ? Colors.green
                  .withOpacity(.10)
                  : Colors.grey
                  .withOpacity(.10),

              borderRadius:
              BorderRadius.circular(
                  50),
            ),

            child: Text(

              agent.isOnline == 1
                  ? "online".tr
                  : "offline".tr,

              style:
              GoogleFonts.poppins(
                color:
                agent.isOnline == 1
                    ? Colors.green
                    : Colors.grey,

                fontWeight:
                FontWeight.w600,

                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ADDRESS

  Widget _addressCard(Data order) {

    final address = order.address;

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: address == null

          ? Center(
            child: Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

            Container(

              height: 68,
              width: 68,

              decoration: BoxDecoration(

                color: const Color(0xFF4FC83F)
                    .withOpacity(.10),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.location_off_rounded,
                color: Color(0xFF4FC83F),
                size: 32,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              "no_address_found".tr,

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "address_not_available_for_this_order".tr,

              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
                    ],
                  ),
          )

          : Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(

            height: 48,
            width: 48,

            decoration: BoxDecoration(

              color:
              const Color(0xFF4FC83F)
                  .withOpacity(.10),

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF4FC83F),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  address.holderName ?? '',

                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${address.building ?? ''}, ${address.landmark ?? ''}",

                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.grey.shade100,

                    borderRadius:
                    BorderRadius.circular(50),
                  ),

                  child: Text(
                    address.addressType ?? '',

                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ITEM

  Widget _itemTile(OrderItems item) {

    return Container(

      margin:
      const EdgeInsets.only(
          bottom: 14),

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),
      ),

      child: Row(
        children: [

          ClipRRect(

            borderRadius:
            BorderRadius.circular(
                18),

            child:
            CachedNetworkImage(

              imageUrl:
              EndPoints.mediaUrl(
                item.product
                    ?.productThumbnail
                    .toString() ??
                    '',
              ),

              height: 78,
              width: 78,

              fit: BoxFit.cover,

              placeholder:
                  (_, __) {

                return Container(
                  color:
                  Colors.grey.shade100,
                );
              },

              errorWidget:
                  (_, __, ___) {

                return Container(

                  color:
                  Colors.grey.shade100,

                  child: const Icon(
                    Icons
                        .image_not_supported_outlined,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  item.product
                      ?.productTitle ??
                      '',

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  GoogleFonts.poppins(
                    fontWeight:
                    FontWeight.w600,

                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "${item.product?.productUnitTag ?? ''} × ${item.qty ?? 0}",

                  style:
                  GoogleFonts.poppins(
                    color:
                    Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "₹${item.product?.productPrice ?? '0'}",

            style:
            GoogleFonts.poppins(
              fontWeight:
              FontWeight.w700,

              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // BILL

  Widget _billSection(Data order) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(28),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            "bill_summary".tr,

            style:
            GoogleFonts.poppins(
              fontWeight:
              FontWeight.w700,

              fontSize: 18,
            ),
          ),

          const SizedBox(height: 18),

          _billRow(
            "item_total".tr,

            "₹${order.subTotal ?? '0'}",
          ),

          const SizedBox(height: 12),

          _billRow(
            "delivery_fee".tr,

            "₹${order.deliveryFee ?? 0}",
          ),

          const SizedBox(height: 12),

          _billRow(
            "discount".tr,

            "-${order.couponPercent ?? 0}%",

            green: true,
          ),

          const Padding(
            padding:
            EdgeInsets.symmetric(
                vertical: 16),

            child: Divider(),
          ),

          _billRow(
            "total_paid".tr,

            "₹${order.grandTotal ?? '0'}",

            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _billRow(
      String title,
      String value, {
        bool bold = false,
        bool green = false,
      }) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style:
          GoogleFonts.poppins(
            fontWeight:
            bold
                ? FontWeight.w700
                : FontWeight.w500,

            color:
            Colors.grey.shade700,
          ),
        ),

        Text(
          value,

          style:
          GoogleFonts.poppins(
            fontWeight:
            bold
                ? FontWeight.w700
                : FontWeight.w600,

            color:
            green
                ? Colors.green
                : Colors.black,
          ),
        ),
      ],
    );
  }
}