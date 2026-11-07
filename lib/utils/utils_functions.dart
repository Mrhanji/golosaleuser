import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class UtilsFunctions {
  Future<void> launchUrls(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static void showSnackBar({
    required String title,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    SnackPosition snackPosition = SnackPosition.TOP,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: isError ? const Color(0xFFE53935) : const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: (isError ? const Color(0xFFE53935) : const Color(0xFF2E7D32)).withValues(alpha: 0.3),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
      ],
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      icon: Container(
        margin: const EdgeInsets.only(left: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 0.2,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
      ),
      shouldIconPulse: false,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }

  static void showError(String message, {String title = "Error"}) {
    showSnackBar(
      title: title,
      message: message,
      isError: true,
    );
  }

  static void showSuccess(String message, {String title = "Success"}) {
    showSnackBar(
      title: title,
      message: message,
      isError: false,
    );
  }
}

