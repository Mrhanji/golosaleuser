import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/notification_service.dart';
import '/app/features/auth/model/user_model.dart';
import '/app/features/auth/service/auth_service.dart';
import '../../../../database/local_db.dart';
import '../../../routes/app_routes.dart';
import '../../../../utils/utils_functions.dart';

/// Auth controller
///
///

class AuthController extends GetxController {
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  AuthService authService = AuthService();
  UserModel userModel = UserModel();
  bool otpSending = false;
  String? generatedOtp;

  @override
  void onInit() {
    super.onInit();
  }

  /// Send Otp
  sendOtp() async {
    try {
      final mobile = mobileController.text.trim();
      print("mobile length ${mobile.length}");
      if (mobile.length == 10) {
        otpSending = true;
        update();

        // Check if mobile number is registered
        userModel = await authService.verifyMobile(mobile);
        print("verifyMobile result: ${userModel.toJson()}");

        if (userModel.statusCode == 201) {
          // Existing user -> Generate 4-digit OTP and send via SMS
          final otp = (1000 + Random().nextInt(9000)).toString();
          generatedOtp = otp;
          print("Generated Login OTP: $otp");

          await authService.sendDirectOtp(mobile, otp);

          UtilsFunctions.showSuccess("OTP sent successfully");
          otpSending = false;
          update();
          if (Get.currentRoute != AppRoutes.otpScreen) {
            Get.toNamed(AppRoutes.otpScreen);
          }
        } else if (userModel.statusCode == 200) {
          // Mobile not registered
          otpSending = false;
          update();
          UtilsFunctions.showError("Mobile number is not registered. Please sign up.");
        } else {
          otpSending = false;
          update();
          UtilsFunctions.showError(
            userModel.message?.toString() ?? "Failed to send OTP",
          );
        }
      } else {
        UtilsFunctions.showError("Please enter valid 10-digit mobile number");
      }
    } catch (e) {
      otpSending = false;
      update();
      print("Error in sendOtp: $e");
      UtilsFunctions.showError("Something went wrong. Please try again.");
    }
  }

  /// Send Login Request
  doLogin() async {
    final enteredOtp = otpController.text.trim();
    print("Entered Otp is: $enteredOtp, Generated Otp is: $generatedOtp");

    if (enteredOtp.length != 4) {
      UtilsFunctions.showError("Please enter valid 4-digit OTP");
      return;
    }

    if (generatedOtp != null && enteredOtp != generatedOtp) {
      UtilsFunctions.showError("Invalid OTP. Please enter the correct OTP.");
      return;
    }

    try {
      final mobile = mobileController.text.trim();
      final deviceId = await NotificationService.instance.getDeviceToken();

      // Fetch user profile data
      var response = await authService.verifyMobile(mobile);
      if (response.data != null) {
        if (deviceId != null && response.data?.userId != null) {
          await authService.setDeviceToken(response.data!.userId!, deviceId);
        }

        UtilsFunctions.showSuccess("Logged in successfully");
        await SecurePreferenceStorage().setLoginStatus(true);
        await SecurePreferenceStorage().setLoginUser(
          jsonEncode(response.toJson()).toString(),
        );
        otpController.clear();
        Get.offAllNamed(AppRoutes.home);
      } else {
        UtilsFunctions.showError(
          response.message?.toString() ?? "Login failed",
        );
      }
    } catch (e) {
      print("Error in doLogin: $e");
      UtilsFunctions.showError("Login failed. Please try again.");
    }
  }
}

