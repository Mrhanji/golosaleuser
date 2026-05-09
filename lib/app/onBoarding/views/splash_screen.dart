import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../database/local_db.dart';
import '/app/routes/app_routes.dart';
import '/utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startSplashFlow();
  }

  Future<void> _startSplashFlow() async {
    if (!mounted) return;

    try {
      /// Start animation (non-blocking safe delay)
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() => _opacity = 1.0);
      }

      bool isLoggedIn = false;

      try {
        /// Add timeout so it NEVER hangs
        isLoggedIn = await SecurePreferenceStorage()
            .getLoginStatus()
            .timeout(const Duration(seconds: 2), onTimeout: () {
          debugPrint("Login status timeout");
          return false; // fallback
        });
      } catch (e, stack) {
        debugPrint("Error reading login status: $e");
        debugPrintStack(stackTrace: stack);

        /// fallback → treat as logged out
        isLoggedIn = false;
      }

      /// Ensure splash is visible for minimum time
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      /// ALWAYS navigate (no condition where it skips)
      if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    } catch (e, stack) {
      debugPrint("Critical Splash Error: $e");
      debugPrintStack(stackTrace: stack);

      if (!mounted) return;

      /// Absolute fallback (never stuck)
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated logo
            Spacer(),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                AppConstants.appLogoOrganic,
                width: Get.height * 0.4,
                height: Get.height * 0.4,
              ),
            ),
            // Loading indicator at the bottom
            CupertinoActivityIndicator(
              color: HexColor(AppConstants.primaryColor),
            ),
            Spacer(),
            Text(
              'v${AppConstants.appVersion}',
              style: GoogleFonts.poppins(color: Colors.grey.shade500),
            ),
            SizedBox(height: Get.height * 0.03),
          ],
        ),
      ),
    );
  }
}
