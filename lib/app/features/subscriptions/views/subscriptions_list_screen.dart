import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/subscriptions_controller.dart';

class SubscriptionsListScreen extends StatelessWidget {
  const SubscriptionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionsController>(
      init: SubscriptionsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FFF6),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFF8FFF6),
            surfaceTintColor: Colors.transparent,
            centerTitle: true,

            title: Text(
              'my_subscriptions'.tr,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),

          body: controller.isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4FC83F),
            ),
          )
              : controller.subscriptions.data == null ||
              controller.subscriptions.data!.isEmpty
              ? Center(
            child: Text(
              'no_subscriptions_found'.tr,
              style: GoogleFonts.poppins(),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount:
            controller.subscriptions.data!.length,

            itemBuilder: (context, index) {

              final item =
              controller.subscriptions.data![index];

              return Container(
                margin:
                const EdgeInsets.only(bottom: 18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.04),

                      blurRadius: 18,

                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    // TOP HEADER

                    Container(
                      padding: const EdgeInsets.all(18),

                      child: Row(
                        children: [

                          Container(
                            height: 68,
                            width: 68,

                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(22),

                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,

                                colors: [
                                  const Color(0xFF4FC83F)
                                      .withOpacity(.15),

                                  const Color(0xFF4FC83F)
                                      .withOpacity(.05),
                                ],
                              ),
                            ),

                            child: const Icon(
                              Icons.subscriptions_rounded,

                              color:
                              Color(0xFF4FC83F),

                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                Text(
                                  '${item.planDuration} ${'days_plan'.tr}',

                                  style:
                                  GoogleFonts.poppins(
                                    fontWeight:
                                    FontWeight.w700,

                                    fontSize: 18,

                                    color:
                                    const Color(
                                        0xFF111827),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [

                                    // STATUS CHIP

                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 7,
                                      ),

                                      decoration:
                                      BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            50),

                                        color:
                                        _getStatusColor(
                                          item.status
                                              .toString(),
                                        ).withOpacity(.12),
                                      ),

                                      child: Row(
                                        mainAxisSize:
                                        MainAxisSize
                                            .min,

                                        children: [

                                          Icon(
                                            _getStatusIcon(
                                              item.status
                                                  .toString(),
                                            ),

                                            size: 14,

                                            color:
                                            _getStatusColor(
                                              item.status
                                                  .toString(),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 5),

                                          Text(
                                            controller
                                                .getStatusText(
                                              item.status
                                                  .toString(),
                                            ),

                                            style:
                                            GoogleFonts
                                                .poppins(
                                              color:
                                              _getStatusColor(
                                                item.status
                                                    .toString(),
                                              ),

                                              fontSize:
                                              11,

                                              fontWeight:
                                              FontWeight
                                                  .w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Text(
                                      '${'qty'.tr}: ${item.productQty}',

                                      style:
                                      GoogleFonts.poppins(
                                        fontSize: 13,

                                        color: Colors
                                            .grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,

                            children: [

                              Text(
                                '₹${item.totalBill}',

                                style:
                                GoogleFonts.poppins(
                                  fontSize: Get.height*0.02,

                                  fontWeight:
                                  FontWeight.w700,

                                  color:
                                  const Color(
                                      0xFF111827),
                                ),
                              ),

                              Text(
                                'total'.tr,

                                style:
                                GoogleFonts.poppins(
                                  fontSize: Get.height*0.017,

                                  color: Colors
                                      .grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,

                      color: Colors.grey
                          .withOpacity(.08),
                    ),

                    // DETAILS SECTION

                    Padding(
                      padding: const EdgeInsets.all(18),

                      child: Column(
                        children: [

                          _row(
                            'subscription_id'.tr,
                            '#${item.subscriptionId}',
                          ),

                          const SizedBox(height: 14),

                          _row(
                            'price'.tr,
                            '₹${item.productPrice}',
                          ),

                          const SizedBox(height: 14),

                          _row(
                            'payment_mode'.tr,
                            item.paymentMode
                                .toString()
                                .toUpperCase(),
                          ),

                          const SizedBox(height: 14),

                          _row(
                            'start_date'.tr,

                            controller.formatDate(
                              DateTime.parse(
                                item.startAt
                                    .toString(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          _row(
                            'end_date'.tr,

                            controller.formatDate(
                              DateTime.parse(
                                item.endAt
                                    .toString(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // INFO CARD

                          Container(
                            padding:
                            const EdgeInsets.all(14),

                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  18),

                              color:
                              const Color(0xFFF8FFF6),
                            ),

                            child: Row(
                              children: [

                                const Icon(
                                  Icons
                                      .calendar_month_rounded,

                                  color:
                                  Color(0xFF4FC83F),

                                  size: 20,
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    'manage_subscription_desc'
                                        .tr,

                                    style:
                                    GoogleFonts.poppins(
                                      fontSize: 12,

                                      height: 1.4,

                                      color: Colors
                                          .grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ACTION BUTTON

                          SizedBox(
                            width: double.infinity,
                            height: 52,

                            child: ElevatedButton(
                              onPressed: () {
                               Get.toNamed(AppRoutes.subscriptionsScreen,arguments: item.subscriptionId);
                              },

                              style:
                              ElevatedButton.styleFrom(
                                elevation: 0,

                                backgroundColor:
                                const Color(
                                    0xFF4FC83F),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(16),
                                ),
                              ),

                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                                children: [

                                  const Icon(
                                    Icons
                                        .manage_accounts_rounded,

                                    color: Colors.white,

                                    size: 20,
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    'manage_subscription'
                                        .tr,

                                    style:
                                    GoogleFonts.poppins(
                                      color: Colors.white,

                                      fontWeight:
                                      FontWeight.w600,

                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _row(String title, String value) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),

        Flexible(
          child: Text(
            value,

            textAlign: TextAlign.end,

            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,

              color: const Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  // STATUS COLORS

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {

      case 'scheduled':
        return const Color(0xFF4FC83F);

      case 'completed':
        return const Color(0xFF2563EB);

      case 'halt':
        return const Color(0xFFF59E0B);

      case 'canceled':
        return const Color(0xFFEF4444);

      default:
        return const Color(0xFF6B7280);
    }
  }

  // STATUS ICONS

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {

      case 'scheduled':
        return Icons.schedule_rounded;

      case 'completed':
        return Icons.check_circle_rounded;

      case 'halt':
        return Icons.pause_circle_rounded;

      case 'canceled':
        return Icons.cancel_rounded;

      default:
        return Icons.info_rounded;
    }
  }
}