import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/notification_service.dart';
import '../../../../database/local_db.dart';
import '../../../routes/app_routes.dart';
import '../../../../utils/utils_functions.dart';
import '../service/auth_service.dart';

class SignupController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final AuthService authService = AuthService();

  bool isOtpSent = false;
  bool isSendingOtp = false;
  bool isVerifying = false;
  int resendCountdown = 0;
  Timer? _countdownTimer;
  String? generatedOtp;

  // Referral code validation state
  bool isReferralValid = true;
  bool isCheckingReferral = false;
  bool isReferralVerified = false;
  String? referralErrorMessage;
  Timer? _referralDebounceTimer;

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _referralDebounceTimer?.cancel();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    referralCodeController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Start 30 seconds countdown for resending OTP
  void _startCountdown() {
    resendCountdown = 30;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown > 0) {
        resendCountdown--;
        update();
      } else {
        timer.cancel();
      }
    });
  }

  /// Reset OTP state if user wants to change phone number
  void resetOtpState() {
    _countdownTimer?.cancel();
    resendCountdown = 0;
    isOtpSent = false;
    otpController.clear();
    update();
  }

  /// Handle referral code text change
  void onReferralCodeChanged(String value) {
    _referralDebounceTimer?.cancel();

    final cleanCode = value.trim();
    if (cleanCode.isEmpty) {
      isReferralValid = true;
      isCheckingReferral = false;
      referralErrorMessage = null;
      isReferralVerified = false;
      update();
      return;
    }

    isReferralVerified = false;
    isCheckingReferral = true;
    referralErrorMessage = null;
    update();

    _referralDebounceTimer = Timer(const Duration(milliseconds: 600), () {
      _validateReferralCode(cleanCode);
    });
  }

  Future<void> _validateReferralCode(String cleanCode) async {
    if (cleanCode.isEmpty) {
      isReferralValid = true;
      isCheckingReferral = false;
      referralErrorMessage = null;
      isReferralVerified = false;
      update();
      return;
    }

    try {
      isCheckingReferral = true;
      update();

      final response = await authService.verifyReferralCode(cleanCode);

      if (response is Map) {
        final statusCode = response['statusCode'];
        final status = response['status'];
        final data = response['data'];
        final count = (data is Map && data['count'] != null)
            ? (data['count'] is int ? data['count'] : int.tryParse(data['count'].toString()) ?? 0)
            : 0;

        if ((status == 'success' || statusCode == 200) && count > 0) {
          isReferralValid = true;
          isReferralVerified = true;
          referralErrorMessage = null;
        } else {
          isReferralValid = false;
          isReferralVerified = false;
          referralErrorMessage = response['message']?.toString() ?? "Invalid Referral Code";
        }
      } else {
        isReferralValid = false;
        isReferralVerified = false;
        referralErrorMessage = "Invalid Referral Code";
      }
    } catch (e) {
      debugPrint("Error verifying referral code: $e");
      isReferralValid = false;
      isReferralVerified = false;
      referralErrorMessage = "Invalid Referral Code";
    } finally {
      isCheckingReferral = false;
      update();
    }
  }

  /// Validate inputs and send OTP
  Future<void> sendOtp() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobile = mobileController.text.trim();
    final referCode = referralCodeController.text.trim();

    if (referCode.isNotEmpty && (!isReferralValid || isCheckingReferral)) {
      UtilsFunctions.showError(referralErrorMessage ?? "Please enter a valid referral code");
      return;
    }

    if (firstName.isEmpty) {
      UtilsFunctions.showError("enter_first_name".tr);
      return;
    }

    if (lastName.isEmpty) {
      UtilsFunctions.showError("enter_last_name".tr);
      return;
    }

    if (mobile.length != 10) {
      UtilsFunctions.showError("enter_valid_mobile".tr);
      return;
    }

    try {
      isSendingOtp = true;
      update();

      // Check if mobile number is already registered via verifyMobile
      final checkMobile = await authService.verifyMobile(mobile);

      if (checkMobile.statusCode == 201) {
        // Mobile already registered
        isSendingOtp = false;
        update();
        UtilsFunctions.showError(checkMobile.message ?? "Mobile number is already registered. Please login.");
        return;
      }

      if (checkMobile.statusCode == 200) {
        // Mobile not used -> Auto-generate 4-digit OTP and send via SMS
        final otp = (1000 + Random().nextInt(9000)).toString();
        generatedOtp = otp;
        print("Generated Signup OTP: $otp");

        await authService.sendDirectOtp(mobile, otp);

        isOtpSent = true;
        _startCountdown();
        UtilsFunctions.showSuccess("OTP sent successfully");
      } else {
        UtilsFunctions.showError(checkMobile.message ?? "Failed to send OTP");
      }
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      UtilsFunctions.showError("Something went wrong. Please try again.");
    } finally {
      isSendingOtp = false;
      update();
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (resendCountdown > 0 || isSendingOtp) return;
    await sendOtp();
  }

  /// Verify OTP and complete registration
  Future<void> verifyAndSignUp() async {
    print("verifyAndSignUp called");
    final otp = otpController.text.trim();
    if (otp.length != 4) {
      UtilsFunctions.showError("enter_valid_otp".tr);
      return;
    }

    if (generatedOtp != null && otp != generatedOtp) {
      UtilsFunctions.showError("Invalid OTP. Please enter the correct OTP.");
      return;
    }

    try {
      isVerifying = true;
      update();

      final mobile = mobileController.text.trim();
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final referCode = referralCodeController.text.trim();
      final deviceId = await NotificationService.instance.getDeviceToken();

      // Call register API: /auth/register
      final registerResponse = await authService.registerUser(
        mobile: mobile,
        firstName: firstName,
        lastName: lastName,
        parentReferralCode: referCode.isNotEmpty ? referCode : null,
      );

      print("Register response: ${registerResponse.toJson()}");

      if (registerResponse.statusCode == 201 || registerResponse.status == 'success') {
        // Fetch created user details via /auth/verifyMobile
        final userResponse = await authService.verifyMobile(mobile);

        if (userResponse.data != null) {
          final userId = userResponse.data?.userId;
          if (deviceId != null && userId != null) {
            await authService.setDeviceToken(userId, deviceId);
          }

          await SecurePreferenceStorage().setLoginStatus(true);
          await SecurePreferenceStorage().setLoginUser(
            jsonEncode(userResponse.toJson()).toString(),
          );

          UtilsFunctions.showSuccess("Account created and logged in successfully");
          Get.offAllNamed(AppRoutes.home);
        } else {
          await SecurePreferenceStorage().setLoginStatus(true);
          await SecurePreferenceStorage().setLoginUser(
            jsonEncode(registerResponse.toJson()).toString(),
          );
          UtilsFunctions.showSuccess("Account created and logged in successfully");
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        UtilsFunctions.showError(registerResponse.message ?? "Registration failed. Please try again.");
      }
    } catch (e) {
      debugPrint("Error during verify and signup: $e");
      UtilsFunctions.showError("Failed to register. Please try again.");
    } finally {
      isVerifying = false;
      update();
    }
  }
}
