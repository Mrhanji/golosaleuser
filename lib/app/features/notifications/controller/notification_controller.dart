import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controller/home_controller.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final Dio dio = Dio();

  /// Home Controller
  final HomeController homeController =
  Get.find<HomeController>();

  /// Notifications
  final notifications = <AppNotification>[].obs;

  /// Loading States
  final isLoading = false.obs;
  final isPaginationLoading = false.obs;
  final hasMore = true.obs;

  /// Filters
  final selectedFilter = "All".obs;

  /// Pagination
  final page = 1.obs;
  final int limit = 10;

  /// Scroll Controller
  final ScrollController scrollController =
  ScrollController();

  /// Current User Id
  String get userId =>
      homeController.userModel.data?.userId ?? "";

  @override
  void onInit() {
    super.onInit();

    fetchNotifications();

    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Pagination Listener
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      loadMore();
    }
  }

  /// Refresh Notifications
  Future<void> refreshNotifications() async {
    page.value = 1;
    hasMore.value = true;

    notifications.clear();

    await fetchNotifications();
  }

  /// Load More Notifications
  Future<void> loadMore() async {
    if (isLoading.value ||
        isPaginationLoading.value ||
        !hasMore.value) {
      return;
    }

    page.value++;

    await fetchNotifications(
      pagination: true,
    );
  }

  /// API Call
  Future<void> fetchNotifications({
    bool pagination = false,
  }) async {
    if (userId.isEmpty) {
      return;
    }

    try {
      if (pagination) {
        isPaginationLoading.value = true;
      } else {
        isLoading.value = true;
      }

      final response = await dio.get(
        "https://api.golosale.com/notifications/list",
        queryParameters: {
          "userId": userId,
          "page": page.value,
          "limit": limit,
        },
      );

      final result =
      NotificationResponse.fromJson(
        response.data,
      );

      if (result.notifications.length < limit) {
        hasMore.value = false;
      }

      notifications.addAll(
        result.notifications,
      );
    } catch (e) {
      debugPrint(
        "Notification Error => $e",
      );

      Get.snackbar(
        "Error",
        "Failed to load notifications",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  /// Filtered Notifications
  List<AppNotification> get filteredNotifications {
    final filter = selectedFilter.value;

    switch (filter) {
      case "Orders":
        return notifications
            .where((e) =>
        e.notificationType ==
            NotificationType.orders)
            .toList();

      case "Offers":
        return notifications
            .where((e) =>
        e.notificationType ==
            NotificationType.offer)
            .toList();

      case "Updates":
        return notifications
            .where((e) =>
        e.notificationType ==
            NotificationType.basic)
            .toList();

      default:
        return notifications.toList();
    }
  }

  /// Unread Count
  int get unreadCount =>
      notifications
          .where((e) => !e.isRead)
          .length;

  /// Mark Single Read
  void markRead(int id) {
    final index = notifications.indexWhere(
          (e) => e.id == id,
    );

    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  /// Mark All Read
  void markAllRead() {
    for (final notification in notifications) {
      notification.isRead = true;
    }

    notifications.refresh();
  }

  /// Delete Notification
  void deleteNotification(int id) {
    notifications.removeWhere(
          (e) => e.id == id,
    );
  }
}