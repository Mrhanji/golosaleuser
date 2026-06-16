import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/language/language.dart';
import 'app/routes/app_routes.dart';
import 'core/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase Init
  await Firebase.initializeApp();

  /// Notification Init
  await NotificationService.instance.init();
  String? token =
  await NotificationService.instance.getDeviceToken();

  print("FCM Token :--  $token");
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: Locales.en,
      fallbackLocale: Locales.en,
    );
  }
}