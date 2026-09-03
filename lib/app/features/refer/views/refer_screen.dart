import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import '/app/features/home/controller/home_controller.dart';
import '/utils/app_constants.dart';

class ReferScreen extends StatelessWidget {
  final HomeController homeController;
  const ReferScreen({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.02),
            
            // Premium Header Illustration
            SizedBox(
              height: Get.height * 0.28,
              width: Get.width,
              child: Image.asset(
                AppConstants.referImage,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Get.height * 0.01),

            // Redesigned Stats/Summary Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _buildSummaryCard(
                homeController: homeController,
                primaryColor: primaryColor,
              ),
            ),

            // Redesigned Referral Code Voucher Coupon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "refer_code".tr,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "tap_to_share".tr,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        final code = homeController.userModel.data?.refferalCode ?? "";
                        if (code.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: code));
                          Get.snackbar(
                            "Copied!",
                            "Referral code copied to clipboard",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                            duration: const Duration(seconds: 2),
                            icon: const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 24,
                            ),
                          );
                        }
                      },
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: const [10, 3],
                          strokeWidth: 1.5,
                          radius: const Radius.circular(10),
                          color: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        child: Container(
                          width: double.infinity,
                          color: primaryColor.withValues(alpha: 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${homeController.userModel.data?.refferalCode}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.copy_rounded,
                                color: primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Share Invitation CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: InkWell(
                onTap: () {
                  final referralCode = homeController.userModel.data?.refferalCode ?? "";
                  SharePlus.instance.share(
                    ShareParams(
                      text: "Hey! Install GoloSale grocery & milk delivery app and use my referral code *${referralCode}* to get instant discounts and cashback on your organic purchases! 🌱🥛\nDownload now!",
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        Color.lerp(primaryColor, Colors.black, 0.12)!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Invite Friends",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            
            // Accordion FAQ/Rules Section
            _buildTile(
              icon: Icons.share_outlined,
              title: 'refer_how_title'.tr,
              desc: 'refer_how_desc'.tr,
              primaryColor: primaryColor,
            ),
            _buildTile(
              icon: Icons.card_giftcard_outlined,
              title: 'refer_reward_title'.tr,
              desc: 'refer_reward_desc'.tr,
              primaryColor: primaryColor,
            ),
            _buildTile(
              icon: Icons.account_circle_outlined,
              title: 'refer_eligibility_title'.tr,
              desc: 'refer_eligibility_desc'.tr,
              primaryColor: primaryColor,
            ),
            _buildTile(
              icon: Icons.warning_amber_rounded,
              title: 'refer_rules_title'.tr,
              desc: 'refer_rules_desc'.tr,
              primaryColor: primaryColor,
            ),
            SizedBox(height: Get.height * 0.05),
          ],
        ),
      ),
    );
  }
}

// Summary Card Widget
Widget _buildSummaryCard({
  required HomeController homeController,
  required Color primaryColor,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              children: [
                _summaryItem(
                  icon: Icons.group_outlined,
                  title: 'refer_count_title'.tr,
                  value: '${homeController.userModel.data?.totalReferedUser ?? 0}',
                  primaryColor: primaryColor,
                ),
                _divider(),
                _summaryItem(
                  icon: Icons.currency_rupee,
                  title: 'refer_earning_title'.tr,
                  value: '₹${homeController.userModel.data?.walletAmount ?? '0'}',
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _summaryItem({
  required IconData icon,
  required String title,
  required String value,
  required Color primaryColor,
}) {
  return Expanded(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _divider() {
  return Container(
    height: 50,
    width: 1.5,
    color: Colors.grey.shade200,
  );
}

// Redesigned Accordion Tile Widget
Widget _buildTile({
  required IconData icon,
  required String title,
  required String desc,
  required Color primaryColor,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        iconColor: primaryColor,
        collapsedIconColor: Colors.grey.shade400,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            desc,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}
