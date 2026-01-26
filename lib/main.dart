import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/language/language.dart';
import 'app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const RootApp());
}



class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: AppRoutes.splash, // Set default route to splash screen
      getPages: AppPages.routes, // Define app routes
         translations: AppTranslations(),
        locale: Locales.en, // or Locales.hi
        fallbackLocale: Locales.en
    );
  }
}
