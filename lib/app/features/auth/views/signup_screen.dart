import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import '../../../../utils/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    // Pin theme for inline OTP input matching OtpScreen
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 52,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
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

            // Top Bar with Back Button
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: Get.height * 0.02),
                                // App Branding Logo
                                Image.asset(
                                  AppConstants.appLogoOrganic,
                                  height: Get.height * 0.11,
                                  width: Get.width * 0.55,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 12),
                                // Header Title
                                Text(
                                  "create_account".tr,
                                  style: GoogleFonts.poppins(
                                    fontSize: Get.height * 0.030,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "signup_subtitle".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: Get.height * 0.015,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Card-based Form Container
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(20.0),
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
                                    child: GetBuilder<SignupController>(
                                      builder: (controller) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // First Name and Last Name Row
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "first_name".tr,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      _buildTextField(
                                                        controller: controller.firstNameController,
                                                        hintText: "first_name".tr,
                                                        icon: Icons.person_outline,
                                                        readOnly: controller.isOtpSent,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "last_name".tr,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      _buildTextField(
                                                        controller: controller.lastNameController,
                                                        hintText: "last_name".tr,
                                                        icon: Icons.person_outline,
                                                        readOnly: controller.isOtpSent,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),

                                            // Mobile Number Field
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "mobile_no".tr,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                if (controller.isOtpSent)
                                                  GestureDetector(
                                                    onTap: () => controller.resetOtpState(),
                                                    child: Text(
                                                      "change_number".tr,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.red.shade400,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              readOnly: controller.isOtpSent,
                                              keyboardType: TextInputType.phone,
                                              controller: controller.mobileController,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.only(left: 14.0, right: 10.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.phone_outlined,
                                                        color: Colors.grey,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        "+91",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                        height: 18,
                                                        width: 1,
                                                        color: Colors.grey.shade300,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                                hintText: "00000 00000",
                                                hintStyle: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400,
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                                filled: true,
                                                fillColor: controller.isOtpSent
                                                    ? Colors.grey.shade100
                                                    : Colors.grey.shade50,
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
                                            const SizedBox(height: 16),

                                            // Referral Code (Optional)
                                            Text(
                                              "refer_code_optional".tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildTextField(
                                              controller: controller.referralCodeController,
                                              hintText: "refer_code_optional".tr,
                                              icon: Icons.card_giftcard_outlined,
                                              readOnly: controller.isOtpSent,
                                              onChanged: controller.onReferralCodeChanged,
                                              borderColor: controller.referralErrorMessage != null
                                                  ? Colors.red.shade400
                                                  : (controller.isReferralVerified
                                                      ? Colors.green.shade500
                                                      : null),
                                              suffixIcon: controller.isCheckingReferral
                                                  ? const Padding(
                                                      padding: EdgeInsets.all(12.0),
                                                      child: CupertinoActivityIndicator(radius: 8),
                                                    )
                                                  : (controller.isReferralVerified
                                                      ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                                                      : (controller.referralErrorMessage != null
                                                          ? const Icon(Icons.cancel, color: Colors.red, size: 20)
                                                          : null)),
                                            ),
                                            if (controller.referralErrorMessage != null)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 14),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        controller.referralErrorMessage!,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: Colors.red.shade600,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else if (controller.isReferralVerified)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 14),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Referral code verified",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.green.shade600,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            const SizedBox(height: 20),

                                            // Inline OTP Section if OTP is sent
                                            if (controller.isOtpSent) ...[
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                  color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.05),
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.2),
                                                    width: 1.2,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "enter_otp".tr,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "otp_msg".tr,
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Pinput(
                                                      length: 4,
                                                      controller: controller.otpController,
                                                      defaultPinTheme: defaultPinTheme,
                                                      focusedPinTheme: focusedPinTheme,
                                                      submittedPinTheme: submittedPinTheme,
                                                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                                                      onCompleted: (_) {
                                                        FocusScope.of(context).unfocus();
                                                        controller.verifyAndSignUp();
                                                      },
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        if (controller.resendCountdown > 0)
                                                          Text(
                                                            "${"resend_otp_in".tr}${controller.resendCountdown}s",
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              color: Colors.grey.shade600,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          )
                                                        else
                                                          GestureDetector(
                                                            onTap: controller.isSendingOtp
                                                                ? null
                                                                : () => controller.resendOtp(),
                                                            child: Text(
                                                              "resend_otp".tr,
                                                              style: GoogleFonts.poppins(
                                                                color: HexColor(AppConstants.primaryColor),
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                            ],

                                            // Action Button: "Send OTP" or "Verify & Sign Up"
                                            Builder(
                                              builder: (context) {
                                                final bool isButtonDisabled = controller.isSendingOtp ||
                                                    controller.isVerifying ||
                                                    controller.isCheckingReferral ||
                                                    !controller.isReferralValid;

                                                return InkWell(
                                                  onTap: isButtonDisabled
                                                      ? null
                                                      : () {
                                                          FocusScope.of(context).unfocus();
                                                          if (controller.isOtpSent) {
                                                            controller.verifyAndSignUp();
                                                          } else {
                                                            controller.sendOtp();
                                                          }
                                                        },
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 300),
                                                    height: 54,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: isButtonDisabled
                                                            ? [Colors.grey.shade400, Colors.grey.shade400]
                                                            : [
                                                                HexColor(AppConstants.primaryColor),
                                                                HexColor(AppConstants.primaryColor).withValues(alpha: 0.85),
                                                              ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                      boxShadow: isButtonDisabled
                                                          ? []
                                                          : [
                                                              BoxShadow(
                                                                color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.3),
                                                                blurRadius: 12,
                                                                offset: const Offset(0, 6),
                                                              ),
                                                            ],
                                                    ),
                                                    child: Center(
                                                      child: (controller.isSendingOtp || controller.isVerifying)
                                                          ? const CupertinoActivityIndicator(color: Colors.white)
                                                          : Text(
                                                              controller.isOtpSent
                                                                  ? "verify_and_signup".tr
                                                                  : "send_otp".tr,
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

                                            // Route navigation back to Login screen
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "already_have_account".tr,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // If we came from LoginScreen, pop back, otherwise navigate to Login
                                                    if (Get.previousRoute == AppRoutes.login) {
                                                      Get.back();
                                                    } else {
                                                      Get.offNamed(AppRoutes.login);
                                                    }
                                                  },
                                                  child: Text(
                                                    "login".tr,
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
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Terms and conditions message pinned at the bottom
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                              child: Text(
                                "login_screen_msg".tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: Get.height * 0.014,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
    Color? borderColor,
  }) {
    final activeBorderColor = borderColor ?? Colors.grey.shade200;
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: activeBorderColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: activeBorderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: borderColor ?? HexColor(AppConstants.primaryColor),
            width: 1.8,
          ),
        ),
      ),
    );
  }
}
