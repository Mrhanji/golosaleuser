import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/routes/app_routes.dart';
import 'package:golosaleuser/utils/end_points.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/order_controller.dart';
import '../model/order_history_model.dart';

class OrderHistoryScreen extends StatelessWidget {

  OrderHistoryScreen({super.key});

  final OrderHistoryController controller =
  Get.put(OrderHistoryController());

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
          "order_history".tr,

          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),

      body: GetBuilder<OrderHistoryController>(

        init: controller,

        builder: (_) {

          // LOADING

          if (controller.currentOrderHistoryState ==
              OrderHistoryState.loading &&
              controller.orderList.isEmpty) {

            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4FC83F),
              ),
            );
          }

          // EMPTY

          if (controller.currentOrderHistoryState ==
              OrderHistoryState.noItem) {

            return Center(

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Container(
                    height: 90,
                    width: 90,

                    decoration: BoxDecoration(
                      color: const Color(
                          0xFF4FC83F)
                          .withOpacity(.10),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.shopping_bag_outlined,

                      size: 42,

                      color: Color(0xFF4FC83F),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "no_orders_found".tr,

                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "your_orders_will_appear_here"
                        .tr,

                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(

            color: const Color(0xFF4FC83F),

            onRefresh: () async {
              controller.refreshOrders();
            },

            child: ListView.builder(

              controller:
              controller.scrollController,

              padding:
              const EdgeInsets.all(16),

              itemCount:
              controller.orderList.length +
                  1,

              itemBuilder: (_, index) {

                // PAGINATION LOADER

                if (index ==
                    controller.orderList.length) {

                  if (controller.hasMoreData) {

                    return const Padding(
                      padding:
                      EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      child: Center(
                        child:
                        CircularProgressIndicator(
                          color:
                          Color(0xFF4FC83F),
                        ),
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 30,
                  );
                }

                Orders order =
                controller.orderList[index];

                return _orderCard(order);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _orderCard(Orders order) {

    Color statusColor =
    controller.getStatusColor(
      order.orderStatus ?? '',
    );

    return InkWell(

      borderRadius:
      BorderRadius.circular(28),

      onTap: () {

        Get.toNamed(
          AppRoutes.orderDetailsScreen,
          arguments: order.orderId,
        );
      },

      child: Container(

        margin:
        const EdgeInsets.only(
          bottom: 18,
        ),

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

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // SUBSCRIPTION ORDER TAG

            if (order.isSubscriptionOrder == true)

              Container(

                margin:
                const EdgeInsets.only(
                  bottom: 14,
                ),

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

                  border: Border.all(
                    color:
                    const Color(0xFF4FC83F)
                        .withOpacity(.25),
                  ),
                ),

                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    const Icon(
                      Icons
                          .autorenew_rounded,

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

            // TOP SECTION

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // IMAGE

                ClipRRect(

                  borderRadius: BorderRadius.circular(18),

                  child: CachedNetworkImage(

                    imageUrl: EndPoints.mediaUrl(
                      order.orderItems
                          ?.first
                          .product
                          ?.productThumbnail
                          .toString() ??
                          '',
                    ),

                    height: 82,
                    width: 82,

                    fit: BoxFit.cover,

                    placeholder: (context, url) {

                      return Container(

                        height: 82,
                        width: 82,

                        color: Colors.grey.shade100,

                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    },

                    errorWidget:
                        (context, url, error) {

                      return Container(

                        height: 82,
                        width: 82,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(18),
                        ),

                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey.shade500,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 14),

                // DETAILS

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      // ORDER NUMBER + STATUS

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                Text(
                                  "order_no".tr,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize: 11,

                                    color: Colors
                                        .grey
                                        .shade500,

                                    fontWeight:
                                    FontWeight
                                        .w500,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                    2),

                                Text(
                                  "#ODR-${order.orderNumber}",

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize: 15,

                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(

                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration:
                            BoxDecoration(

                              color:
                              statusColor
                                  .withOpacity(
                                  .10),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  50),
                            ),

                            child: Text(

                              controller
                                  .getStatusText(
                                order.orderStatus
                                    .toString(),
                              ),

                              style:
                              GoogleFonts
                                  .poppins(
                                color:
                                statusColor,

                                fontWeight:
                                FontWeight
                                    .w600,

                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // PRODUCT TITLE

                      Text(

                        order.orderItems
                            ?.first
                            .product
                            ?.productTitle ??
                            '',

                        maxLines: 2,

                        overflow:
                        TextOverflow
                            .ellipsis,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 14,

                          height: 1.4,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ITEM COUNT

                      Container(

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.grey.shade100,

                          borderRadius:
                          BorderRadius.circular(
                              50),
                        ),

                        child: Text(

                          "${order.totalItems ?? 0} ${'items'.tr}",

                          style:
                          GoogleFonts.poppins(
                            fontSize: 11,

                            color:
                            Colors.grey.shade700,

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Divider(
              color:
              Colors.grey.shade200,
            ),

            const SizedBox(height: 14),

            // BOTTOM SECTION

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                // AMOUNT

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      "total_amount".tr,

                      style:
                      GoogleFonts.poppins(
                        fontSize: 11,

                        color:
                        Colors.grey.shade500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(

                      "₹${order.grandTotal ?? '0'}",

                      style:
                      GoogleFonts.poppins(
                        fontSize: 22,

                        color:
                        const Color(0xFF4FC83F),

                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                // DATE

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,

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

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // MORE ITEMS

            if ((order.orderItems?.length ?? 0) >
                1)

              Padding(
                padding:
                const EdgeInsets.only(
                    top: 16),

                child: Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(

                    color:
                    const Color(0xFF4FC83F)
                        .withOpacity(.06),

                    borderRadius:
                    BorderRadius.circular(
                        14),
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.add_box_outlined,

                        size: 18,

                        color:
                        Color(0xFF4FC83F),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(

                          "+${(order.orderItems?.length ?? 1) - 1} ${'more_items'.tr}",

                          style:
                          GoogleFonts.poppins(
                            color:
                            const Color(
                                0xFF4FC83F),

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}