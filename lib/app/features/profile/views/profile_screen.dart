import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/utils_functions.dart';
import '../../auth/controller/auth_controller.dart';
import '/app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../language/language.dart';

class ProfileScreen extends StatelessWidget {
  final HomeController homeController;
    ProfileScreen({super.key, required  this.homeController});





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

                return _profileHeader( homeController);
              }
            ),
            //const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                 // _walletCard(),
                  const SizedBox(height: 24),

                  _sectionTitle("account".tr),
                  _menuTile(
                    icon: CupertinoIcons.bag,
                    title: "order_history".tr,
                    onTap: ()=>Get.toNamed(AppRoutes.orderHistoryScreen)
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
                      AppRoutes.subscriptionsScreen,
                      arguments: [],
                    ),
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle("settings".tr),
                  _menuTile(
                    icon: CupertinoIcons.bell,
                    title: "notifications".tr,
                    onTap: ()=>Get.toNamed(AppRoutes.notificationScreen)
                  ),
                  _menuTile(
                    icon: CupertinoIcons.globe,
                    title: "language".tr,
                    trailing: Text("english".tr),
                    onTap: () => _changeLanguage(),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.question_circle,
                    title: "help_center".tr,
                    onTap: () => UtilsFunctions().launchUrls(AppConstants.helpCenterUrl),
                  ),
                  _menuTile(
                    icon: CupertinoIcons.info,
                    title: "about_us".tr,
                    onTap: () => UtilsFunctions().launchUrls(AppConstants.aboutUsUrl),
                  ),
                  _menuTile(
                    icon: Icons.logout_rounded,
                    title: "logout".tr,
                    color: Colors.red,
                    onTap: ()=>Get.dialog(AlertDialog(
                      title: Text("logout_msg".tr),
                      actions: [
                        TextButton(onPressed: ()=>Get.back(), child: Text("no".tr)),
                        TextButton(onPressed: ()=>homeController.logout(), child: Text("yes".tr)),
                      ],
                    )),
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
    print("Build called");
    return Container(
      height: Get.height * 0.3,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff667EEA),
            Color(0xff764BA2),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -40, right: -40, child: _blurCircle(150)),
          Positioned(bottom: -30, left: -30, child: _blurCircle(120)),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child:  CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: CachedNetworkImageProvider(
                      controller.userModel.data?.profilePicture != null &&
                          controller.userModel.data!.profilePicture!.isNotEmpty
                          ? controller.userModel.data!.profilePicture!
                          : "https://www.golosale.com/assets/image-B0sHWpoa.png",
                    ),
                    onBackgroundImageError: (_, __) {
                      // image error handled internally by fallback URL

                    },

                    child: controller.userModel.data?.profilePicture == null
                        ? const Center(
                      child: Icon(CupertinoIcons.person_alt)
                    )
                        : null,
                  )
                  ,
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${controller.userModel.data!.firstName} ${controller.userModel.data!.lastName}",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      color: Colors.lightBlueAccent,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "📞 ${controller.userModel.data?.userMobile}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                //const SizedBox(height: 16),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _headerAction(
                //       icon: Icons.edit,
                //       label: "Edit",
                //       onTap: () => Get.toNamed(AppRoutes.editProfile),
                //     ),
                //     const SizedBox(width: 16),
                //     _headerAction(
                //       icon: Icons.account_balance_wallet,
                //       label: "Wallet",
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= WALLET CARD =================

  Widget _walletCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wallet",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Balance",
                      style: GoogleFonts.poppins(color: Colors.grey)),
                  Text(
                    "₹ 420.50",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("Add Money"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            ],
          ),

          const Divider(height: 30),

          Text(
            "Recent Transactions",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          _walletTransaction(
            title: "Order Payment",
            date: "Today",
            amount: "- ₹120",
            isDebit: true,
          ),
          _walletTransaction(
            title: "Wallet Topup",
            date: "Yesterday",
            amount: "+ ₹500",
            isDebit: false,
          ),
        ],
      ),
    );
  }

  Widget _walletTransaction({
    required String title,
    required String date,
    required String amount,
    required bool isDebit,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor:
        isDebit ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        child: Icon(
          isDebit ? Icons.call_made : Icons.call_received,
          color: isDebit ? Colors.red : Colors.green,
        ),
      ),
      title: Text(title, style: GoogleFonts.poppins()),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: isDebit ? Colors.red : Colors.green,
        ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color ?? Colors.indigo),
        title: Text(
          title,
          style: GoogleFonts.poppins(color: color),
        ),
        trailing:
        trailing ?? const Icon(CupertinoIcons.chevron_forward, size: 18),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _blurCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }

  Widget _headerAction({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= LANGUAGE DIALOG =================

_changeLanguage() {
  return Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("change_language".tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('🇺🇸 ${"english".tr}'),
            onTap: () {
              Get.updateLocale(Locales.en);
              Get.back();
            },
          ),
          const Divider(),
          ListTile(
            title: Text('🇮🇳 ${"hindi".tr}'),
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
