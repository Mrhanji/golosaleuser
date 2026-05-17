import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// BACKGROUND HANDLER
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("Background Message: ${message.messageId}");
}

/// Notification Service
class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
  NotificationService._privateConstructor();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Android Notification Channel
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.max,
  );

  /// INIT
  Future<void> init() async {
    /// Firebase Background Handler
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    /// Notification Permission
    await _requestPermission();

    /// Local Notification Init
    await _initializeLocalNotification();

    /// Foreground Listener
    _listenForegroundMessages();

    /// Notification Click Listener
    _handleNotificationTap();

    /// Get Device Token
    await getDeviceToken();
  }

  /// REQUEST PERMISSION
  Future<void> _requestPermission() async {
    NotificationSettings settings =
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint(
      "Notification Permission: ${settings.authorizationStatus}",
    );
  }

  /// LOCAL NOTIFICATION INIT
  Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notification Clicked");
      }, settings: settings,
    );

    /// Android Channel Create
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// FOREGROUND MESSAGE
  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground Message Received");

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        _showLocalNotification(
          title: notification.title ?? "",
          body: notification.body ?? "",
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  /// HANDLE TAP
  void _handleNotificationTap() {
    /// App Open From Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification Opened From Background");

      debugPrint("DATA: ${message.data}");
    });

    /// App Open From Kill State
    _checkInitialMessage();
  }

  /// CHECK INITIAL MESSAGE
  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint("App Opened From Kill State");

      debugPrint("DATA: ${initialMessage.data}");
    }
  }

  /// SHOW LOCAL NOTIFICATION
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      title: title,
      body:body,
      notificationDetails: details,
      payload: payload, id: 0,
    );
  }

  /// GET DEVICE TOKEN
  Future<String?> getDeviceToken() async {
    String? token = await _messaging.getToken();

    debugPrint("FCM TOKEN => $token");

    return token;
  }

  /// REFRESH TOKEN
  void listenTokenRefresh() async{
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("NEW TOKEN => $newToken");

      /// SEND UPDATED TOKEN TO SERVER
    });
  }
}