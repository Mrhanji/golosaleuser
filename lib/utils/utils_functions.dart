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

   showSnackBar({
    required String title,
    required String message,
    bool isError = false,
  }) {

    //Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,

      snackPosition: SnackPosition.TOP,

      margin: const EdgeInsets.all(14),

      borderRadius: 14,

      duration: const Duration(seconds: 2),

      backgroundColor:
      isError
          ? const Color(0xffE53935)
          : const Color(0xff4FC83F),

      colorText: Colors.white,

      snackStyle: SnackStyle.FLOATING,

      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(.12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      icon: Icon(
        isError
            ? Icons.error_outline_rounded
            : Icons.check_circle_outline_rounded,
        color: Colors.white,
      ),

      shouldIconPulse: false,
    );
  }
}
