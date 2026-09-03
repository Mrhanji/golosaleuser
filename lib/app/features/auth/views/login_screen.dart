import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/app/features/auth/controller/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatelessWidget {

   LoginScreen({super.key});
   final AuthController authController= Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Decorative background light green circles/gradients
            Positioned(
              top: -Get.height * 0.15,
              right: -Get.width * 0.2,
              child: Container(
                width: Get.width * 0.8,
                height: Get.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.05,
              left: -Get.width * 0.25,
              child: Container(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.04),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: Get.height * 0.05),
                                // Branding App Logo - made larger and more prominent
                                Image.asset(
                                  AppConstants.appLogoOrganic,
                                  height: Get.height * 0.18,
                                  width: Get.width * 0.7,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: Get.height * 0.03),
                                // Welcoming Headers
                                Text(
                                  "welcome".tr,
                                  style: GoogleFonts.poppins(
                                    fontSize: Get.height * 0.034,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Enter your mobile number to get started",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: Get.height * 0.016,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.03),
                                
                                // Card-based Form Container
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(24.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 24,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "mobile_no".tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Stylish Input Field
                                        TextField(
                                          keyboardType: TextInputType.phone,
                                          controller: authController.mobileController,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.phone_outlined,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "+91",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    height: 20,
                                                    width: 1,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                            hintText: "00000 00000",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.grey.shade400,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: HexColor(AppConstants.primaryColor), width: 1.8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        
                                        // Premium Action Button with State updates
                                        GetBuilder<AuthController>(
                                          builder: (controller) {
                                            return InkWell(
                                              onTap: controller.otpSending
                                                  ? null
                                                  : () {
                                                      FocusScope.of(context).unfocus();
                                                      controller.sendOtp();
                                                    },
                                              borderRadius: BorderRadius.circular(12),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                height: 56,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: controller.otpSending
                                                        ? [Colors.grey.shade400, Colors.grey.shade400]
                                                        : [
                                                            HexColor(AppConstants.primaryColor),
                                                            HexColor(AppConstants.primaryColor).withValues(alpha: 0.85),
                                                          ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: controller.otpSending
                                                      ? []
                                                      : [
                                                          BoxShadow(
                                                            color: HexColor(AppConstants.primaryColor)
                                                                .withValues(alpha: 0.3),
                                                            blurRadius: 12,
                                                            offset: const Offset(0, 6),
                                                          ),
                                                        ],
                                                ),
                                                child: Center(
                                                  child: controller.otpSending
                                                      ? const CupertinoActivityIndicator(
                                                          color: Colors.white,
                                                        )
                                                      : Text(
                                                          "login".tr,
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 18),
                                        // Route button to Sign Up screen
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "dont_have_account".tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(AppRoutes.signup);
                                              },
                                              child: Text(
                                                "signup".tr,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: HexColor(AppConstants.primaryColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            // Terms and conditions message pinned at the bottom
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                              child: Text(
                                "login_screen_msg".tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: Get.height * 0.015,
                                  color: Colors.grey.shade500,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
