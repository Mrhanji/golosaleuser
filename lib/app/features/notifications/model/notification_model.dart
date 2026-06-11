import 'package:golosaleuser/utils/end_points.dart';

class NotificationResponse {
  final int count;
  final List<AppNotification> notifications;

  NotificationResponse({
    required this.count,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'] ?? {};

    return NotificationResponse(
      count: data['count'] ?? 0,
      notifications: (data['rows'] as List? ?? [])
          .map(
            (e) => AppNotification.fromJson(
          e,
        ),
      )
          .toList(),
    );
  }
}



enum NotificationType {
  orders,
  offer,
  basic,
}

class AppNotification {
  final int id;
  final String userId;
  final String deviceId;
  final String categoryType;
  final String title;
  final String description;
  final String? mediaId;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool isRead;

  AppNotification({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.categoryType,
    required this.title,
    required this.description,
    required this.mediaId,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
  });

  NotificationType get notificationType {
    switch (categoryType.toLowerCase()) {
      case 'orders':
        return NotificationType.orders;

      case 'offer':
        return NotificationType.offer;

      default:
        return NotificationType.basic;
    }
  }

  String? get imageUrl {
    if (mediaId == null || mediaId!.isEmpty) {
      return null;
    }

    return EndPoints.mediaUrl(mediaId.toString());
  }

  factory AppNotification.fromJson(
      Map<String, dynamic> json,
      ) {
    return AppNotification(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      deviceId: json['deviceId'] ?? '',
      categoryType: json['categoryType'] ?? 'basic',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mediaId: json['mediaId'],
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'deviceId': deviceId,
      'categoryType': categoryType,
      'title': title,
      'description': description,
      'mediaId': mediaId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}