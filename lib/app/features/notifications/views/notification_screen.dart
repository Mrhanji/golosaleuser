import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controller/notification_controller.dart';
import '../model/notification_model.dart';


// ================= SCREEN =================

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          "notifications".tr,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

      ),

      body: Column(
        children: [

          const SizedBox(height: 12),

          _filterSection(),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() {

              if (controller.notifications.isEmpty) {
                return _emptyView();
              }

              return RefreshIndicator(
                onRefresh: () async {},
                child: ListView.builder(
                  controller:
                  controller.scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount:
                  controller.filteredNotifications.length +
                      1,
                  itemBuilder: (context, index) {

                    if (index == controller.filteredNotifications.length) {

                      return Obx(() {
                        if (!controller.isPaginationLoading.value) {
                          return const SizedBox();
                        }

                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                        );
                      });
                    }

                    final notification = controller.filteredNotifications[index];

                    return _notificationTile(
                      notification,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  Widget _filterSection() {
    final filters = [
      "All",
      "Orders",
      "Offers",
      "Updates",
    ];

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: filters.length,
        itemBuilder: (_, index) {
          final filter = filters[index];

          return Obx(() {
            final selected =
                controller.selectedFilter.value == filter;

            return Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: ChoiceChip(
                label: Text(filter),

                selected: selected,

                showCheckmark: false,

                selectedColor: HexColor(AppConstants.primaryColor),

                labelStyle: GoogleFonts.poppins(
                  color: selected
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),

                onSelected: (_) {
                  controller.selectedFilter.value =
                      filter;
                },
              ),
            );
          });
        },
      ),
    );
  }


  Widget _notificationTile(
      AppNotification notification) {
    return Dismissible(
      key: ValueKey(notification.id),

    //  background: _swipeRightBg(),

     // secondaryBackground: _swipeLeftBg(),

      confirmDismiss: (direction) async {

        if (direction ==
            DismissDirection.startToEnd) {

          controller.markRead(
            notification.id,
          );

          return false;
        }

        controller.deleteNotification(
          notification.id,
        );

        return true;
      },

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: () {
          controller.markRead(
            notification.id,
          );
        },

        child: Container(
          margin: const EdgeInsets.only(
            bottom: 14,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              if (notification.imageUrl != null)
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),

                  child: CachedNetworkImage(
                    imageUrl:
                    notification.imageUrl!,

                    height: 170,

                    width: double.infinity,

                    fit: BoxFit.cover,

                    placeholder:
                        (_, __) => const SizedBox(
                      height: 170,
                      child: Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    ),

                    errorWidget:
                        (_, __, ___) => Container(
                      height: 170,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                        ),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding:
                const EdgeInsets.all(16),

                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Container(
                      height: 50,
                      width: 50,

                      decoration: BoxDecoration(
                        color: notification.isRead
                            ? Colors.grey.shade200
                            : Colors.indigo.shade50,

                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),

                      child: Icon(
                        notification.notificationType ==
                            NotificationType
                                .orders
                            ? Icons.shopping_bag_rounded
                            : notification
                            .notificationType ==
                            NotificationType
                                .offer
                            ? Icons.local_offer
                            : Icons
                            .notifications_active,

                        color: notification.isRead
                            ? Colors.grey
                            :  HexColor(AppConstants.primaryColor),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Row(
                            children: [

                              Expanded(
                                child: Text(
                                  notification.title,

                                  style:
                                  GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),

                              if (!notification.isRead)
                                Container(
                                  width: 10,
                                  height: 10,

                                  decoration:
                                   BoxDecoration(
                                    color:  HexColor(AppConstants.primaryColor),
                                    shape:
                                    BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            notification.description,

                            style:
                            GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            notification.createdAt.toString(),

                            style:
                            GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [

          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 16),

          Text(
            "No Notifications Yet",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "We'll notify you when something arrives",
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
