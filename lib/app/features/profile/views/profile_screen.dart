import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '/app/features/profile/widgets/name_avatar.dart';
import '/app/features/home/controller/home_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/utils_functions.dart';
import '/app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../language/language.dart';

class ProfileScreen extends StatelessWidget {
  final HomeController homeController;
  ProfileScreen({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder(
              init: homeController,
              builder: (context) {
                return _profileHeader(homeController);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // _walletCard(),
                  // const SizedBox(height: 24),
                  _sectionTitle("account".tr),
                  _menuTile(
                    icon: CupertinoIcons.bag,
                    title: "order_history".tr,
                    onTap: () => Get.toNamed(AppRoutes.orderHistoryScreen),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.person,
                    title: "personal_information".tr,
                    onTap: () => Get.toNamed(AppRoutes.editProfile),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.repeat,
                    title: "subscriptions".tr,
                    onTap: () => Get.toNamed(
                      AppRoutes.subscriptionListScreen,
                      arguments: [],
                    ),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.location_solid,
                    title: 'address'.tr,
                    onTap: () => Get.toNamed(AppRoutes.addressScreen),
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle("settings".tr),
                  _menuTile(
                    icon: CupertinoIcons.bell,
                    title: "notifications".tr,
                    onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.globe,
                    title: "language".tr,
                    trailing: Text(
                      "english".tr,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => _changeLanguage(),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.question_circle,
                    title: "help_center".tr,
                    onTap: () =>
                        UtilsFunctions().launchUrls(AppConstants.helpCenterUrl),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.info,
                    title: "about_us".tr,
                    onTap: () =>
                        UtilsFunctions().launchUrls(AppConstants.aboutUsUrl),
                  ),
                  _menuTile(
                    icon: Icons.logout_rounded,
                    title: "logout".tr,
                    color: Colors.red,
                    onTap: () => Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "logout".tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "logout_msg".tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Get.back(),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        "no".tr,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => homeController.logout(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "yes".tr,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _profileHeader(HomeController controller) {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return Container(
      height: Get.height * 0.32,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor.withValues(alpha: 0.14),
            primaryColor.withValues(alpha: 0.01),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Decorative Offset Circles for layered shape enhancement
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: -40,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: 40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.03),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Avatar
                NameAvatar(
                  firstName: controller.userModel.data!.firstName.toString(),
                  lastName: controller.userModel.data!.lastName.toString(),
                  radius: 50,
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${controller.userModel.data!.firstName} ${controller.userModel.data!.lastName}",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.verified_rounded, color: primaryColor, size: 20),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "📞 ${controller.userModel.data?.userMobile}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= WALLET CARD =================

  Widget _walletCard() {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "wallet".tr,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_rounded,
                color: primaryColor,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "balance".tr,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹ ${homeController.userModel.data!.walletAmount}",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.rechargeScreen),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        Color.lerp(primaryColor, Colors.black, 0.12)!,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "add_money".tr,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "recent_transactions".tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.walletTransactionScreen),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'see_all'.tr,
                  style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= COMMON UI =================

  Widget _menuTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color,
  }) {
    final primaryColor = HexColor(AppConstants.primaryColor);
    final isDestructive = color != null && color == Colors.red;
    final tileColor = isDestructive ? Colors.red : primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tileColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: tileColor, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: color ?? Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ),
        trailing:
            trailing ??
            Icon(
              CupertinoIcons.chevron_forward,
              size: 16,
              color: Colors.grey.shade400,
            ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LANGUAGE DIALOG =================

_changeLanguage() {
  return Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Text(
        "change_language".tr,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
            leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
            title: Text(
              "english".tr,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            onTap: () {
              Get.updateLocale(Locales.en);
              Get.back();
            },
          ),
          const Divider(
            height: 1,
            indent: 24,
            endIndent: 24,
            color: Color(0xfff0f0f0),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
            leading: const Text("🇮🇳", style: TextStyle(fontSize: 20)),
            title: Text(
              "hindi".tr,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            onTap: () {
              Get.updateLocale(Locales.hi);
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}
