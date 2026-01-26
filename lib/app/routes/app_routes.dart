import 'package:get/get.dart';
import '../features/order/views/order_details_screen.dart';
import '../features/order/views/order_history_screen.dart';
import '/app/features/notifications/views/notification_screen.dart';
import '/app/features/profile/views/edit_profile_screen.dart';
import '/app/features/search/views/search_screen.dart';
import '/app/features/refer/views/refer_screen.dart';
import '/app/features/auth/views/otp_screen.dart';
import '/app/features/home/views/home_screen.dart';
import '/app/features/product/views/product_screen.dart';
import '/app/onBoarding/views/onboarding_screen.dart';
import '/app/features/subscriptions/views/subscriptions_screen.dart';
import '../features/auth/views/login_screen.dart';
import '../onBoarding/views/splash_screen.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otpScreen="/otpScreen";
  static const String productScreen="/productScreen";
  static const String subscriptionsScreen="/subscriptionsScreen";
  static const String referScreen="/referScreen";
  static const String searchScreen="/searchScreen";
  static const String editProfile="/editProfileScreen";
  static const String notificationScreen="/notificationScreen";
  static const String orderHistoryScreen='/orderHistoryScreen';
  static const String orderDetailsScreen='/orderDetailsScreen';
}

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash,page: () => SplashScreen()),

    GetPage(name: AppRoutes.onboarding,page: () => OnBoardingScreen(),),

    GetPage(name: AppRoutes.login, page: () => LoginScreen(),),

    GetPage(name: AppRoutes.otpScreen, page: ()=>OtpScreen()),

    GetPage(name: AppRoutes.home, page: () => HomeScreen(),),

    GetPage(name: AppRoutes.productScreen, page: ()=>ProductScreen()),

    GetPage(name: AppRoutes.subscriptionsScreen, page: ()=>SubscriptionsScreen()),


    GetPage(name: AppRoutes.searchScreen, page: ()=>SearchScreen()),

    GetPage(name:AppRoutes.editProfile,page: ()=>EditProfileScreen()),

    GetPage(name: AppRoutes.notificationScreen, page: ()=>NotificationScreen()),

    GetPage(name: AppRoutes.orderHistoryScreen, page:()=>OrderHistoryScreen()),

    GetPage(name: AppRoutes.orderDetailsScreen, page: ()=>OrderDetailsScreen())
  ];
}
