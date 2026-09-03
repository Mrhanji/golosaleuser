import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/notification_service.dart';
import '../../../../database/local_db.dart';
import '../../../routes/app_routes.dart';
import '../model/user_model.dart';
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
    final code = value.trim();

    if (code.isEmpty) {
      isReferralValid = true;
      isCheckingReferral = false;
      referralErrorMessage = null;
      isReferralVerified = false;
      update();
      return;
    }

    // Set checking state while user enters referral code
    isCheckingReferral = true;
    referralErrorMessage = null;
    isReferralVerified = false;
    isReferralValid = false;
    update();

    _referralDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await verifyReferralCode(code);
    });
  }

  /// Verify referral code with the API
  Future<void> verifyReferralCode(String code) async {
    final cleanCode = code.trim();
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
      Get.snackbar(
        "Error",
        referralErrorMessage ?? "Please enter a valid referral code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    if (firstName.isEmpty) {
      Get.snackbar(
        "Error",
        "enter_first_name".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    if (lastName.isEmpty) {
      Get.snackbar(
        "Error",
        "enter_last_name".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    if (mobile.length != 10) {
      Get.snackbar(
        "Error",
        "enter_valid_mobile".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSendingOtp = true;
      update();

      UserModel userModel = await authService.sendOtp(mobile);

      if (userModel.statusCode == 200) {
        isOtpSent = true;
        _startCountdown();
        Get.snackbar(
          "Success",
          "Otp sent successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          userModel.message ?? "Failed to send OTP",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
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
      Get.snackbar(
        "Error",
        "enter_valid_otp".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isVerifying = true;
      update();

      final deviceId = await NotificationService.instance.getDeviceToken();
      final mobile = mobileController.text.trim();
      final response = await authService.verifyOtp(
        mobile: mobile,
        otp: otp,
        deviceId: deviceId,
        
      );

      if (response.data != null) {
        // Update user profile with name and optional parent referral code
        final userId = response.data?.userId;
        if (userId != null && userId.isNotEmpty) {
          final Map<String, dynamic> profileBody = {
            "firstName": firstNameController.text.trim(),
            "lastName": lastNameController.text.trim(),
            "userMobile": mobile,
          };
          if (referralCodeController.text.trim().isNotEmpty) {
            profileBody["parentUserReferralCode"] = referralCodeController.text.trim();
          }
          print("profileBody: ${profileBody}");
          try {
            await authService.updateProfile(profileBody, userId);
            // Fetch updated profile so local storage has complete info
            final updatedProfile = await authService.getProfile(userId);
            if (updatedProfile.data != null) {
              await SecurePreferenceStorage().setLoginUser(
                jsonEncode(updatedProfile.toJson()).toString(),
              );
            } else {
              await SecurePreferenceStorage().setLoginUser(
                jsonEncode(response.toJson()).toString(),
              );
            }
          } catch (e) {
            debugPrint("Error updating profile during signup: $e");
            await SecurePreferenceStorage().setLoginUser(
              jsonEncode(response.toJson()).toString(),
            );
          }
        } else {
          await SecurePreferenceStorage().setLoginUser(
            jsonEncode(response.toJson()).toString(),
          );
        }

        await SecurePreferenceStorage().setLoginStatus(true);

        Get.snackbar(
          "Success",
          "Account created and logged in successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Invalid OTP",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error during verify and signup: $e");
      Get.snackbar(
        "Error",
        "Failed to verify OTP. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isVerifying = false;
      update();
    }
  }
}
