import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum NotificationType {
  text,
  textWithImage,
  imageOnly,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final String? imageUrl;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.imageUrl,
    required this.type,
    this.isRead = false,
  });
}

// ================= CONTROLLER =================

class NotificationController extends GetxController {
  var notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    notifications.value = [
      AppNotification(
        id: '1',
        title: 'Milk Delivered 🥛',
        message: 'Your morning milk has been delivered successfully.',
        time: 'Today • 7:15 AM',
        type: NotificationType.text,
      ),
      AppNotification(
        id: '2',
        title: 'Fresh Curd Available',
        message: 'Order fresh curd & butter today with 10% off.',
        time: 'Yesterday • 6:40 PM',
        imageUrl:
        'https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API/Using_the_Notifications_API/desktop-notification.png',
        type: NotificationType.textWithImage,
      ),
      AppNotification(
        id: '3',
        title: 'New Dairy Products',
        message: '',
        time: 'Yesterday • 9:10 AM',
        imageUrl:
        'https://teamtweaks1-blog.s3.us-east-2.amazonaws.com/blog/wp-content/uploads/2023/08/23133246/MILK-Delivery-App-banner-Image.jpg',
        type: NotificationType.imageOnly,
      ),
    ];
  }

  void markAllRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void markRead(String id) {
    final index = notifications.indexWhere((e) => e.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  void deleteNotification(String id) {
    notifications.removeWhere((e) => e.id == id);
  }
}

// ================= SCREEN =================

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller =
  Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: Text(
              "Read all",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              "No notifications",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _notificationTile(notification);
          },
        );
      }),
    );
  }

  // ================= NOTIFICATION TILE =================

  Widget _notificationTile(AppNotification notification) {
    return Dismissible(
      key: ValueKey(notification.id),
      background: _swipeRightBg(),
      secondaryBackground: _swipeLeftBg(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          controller.markRead(notification.id);
          return false;
        } else {
          controller.deleteNotification(notification.id);
          return true;
        }
      },
      child: InkWell(
        onTap: () {
          controller.markRead(notification.id);
          // Navigate if needed
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xffEEF2FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerRow(notification),
              const SizedBox(height: 8),

              if (notification.type != NotificationType.imageOnly)
                Text(
                  notification.message,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

              if (notification.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      notification.imageUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerRow(AppNotification n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.notifications,
          color: n.isRead ? Colors.grey : Colors.indigo,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                n.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                n.time,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (!n.isRead)
          Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  // ================= SWIPE BACKGROUNDS =================

  Widget _swipeRightBg() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.done, color: Colors.white),
          SizedBox(width: 8),
          Text("Mark Read", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _swipeLeftBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text("Delete", style: TextStyle(color: Colors.white)),
          SizedBox(width: 8),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }
}
