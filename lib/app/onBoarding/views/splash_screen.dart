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
    /// Start fade animation
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _opacity = 1.0);

    /// Get login status (async)
    final bool loginStatus = await SecurePreferenceStorage().getLoginStatus();

    /// Keep splash visible
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    /// Navigate safely using GetX
    if (loginStatus) {
      Get.offAllNamed(AppRoutes.home);
    } else {
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
