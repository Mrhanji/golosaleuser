import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../utils/app_constants.dart';
import '../controller/auth_controller.dart';


class OtpScreen extends StatelessWidget {
   OtpScreen({super.key});
   final AuthController authController= Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // Pin themes for a premium look
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: HexColor(AppConstants.primaryColor), width: 1.8),
      color: Colors.white,
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.05),
        border: Border.all(color: HexColor(AppConstants.primaryColor), width: 1.5),
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Decorative background light green circles
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
            
            // Back Button
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: () => Get.back(),
                  ),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: Get.height * 0.06),
                                  // Verify Image
                                  SizedBox(
                                    height: Get.height * 0.22,
                                    child: Image.asset(
                                      AppConstants.otpVerifyImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.03),
                                  // Texts
                                  Text(
                                    "enter_otp".tr,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.height * 0.032,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "otp_msg".tr,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: Get.height * 0.016,
                                        color: Colors.grey.shade600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.03),
                                  
                                  // Form Card
                                  Container(
                                    width: double.infinity,
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
                                      children: [
                                        // Pinput
                                        Pinput(
                                          length: 4,
                                          controller: authController.otpController,
                                          defaultPinTheme: defaultPinTheme,
                                          focusedPinTheme: focusedPinTheme,
                                          submittedPinTheme: submittedPinTheme,
                                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                                        ),
                                        const SizedBox(height: 16),
                                        
                                        // Resend Code
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            Get.snackbar(
                                              "Info",
                                              "Please request OTP again from login screen",
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.blueGrey,
                                              colorText: Colors.white,
                                            );
                                          },
                                          child: Text(
                                            "resend_otp".tr,
                                            style: GoogleFonts.poppins(
                                              color: HexColor(AppConstants.primaryColor),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        
                                        // Action Button
                                        InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            authController.doLogin();
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            height: 56,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    HexColor(AppConstants.primaryColor),
                                                    HexColor(AppConstants.primaryColor).withValues(alpha: 0.85),
                                                  ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: HexColor(AppConstants.primaryColor)
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Change Number text button pinned at the bottom
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    "change_number".tr,
                                    style: GoogleFonts.poppins(
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
