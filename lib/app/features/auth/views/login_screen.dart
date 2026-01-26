import 'package:flutter/material.dart';
import '/app/features/auth/controller/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatelessWidget {

   LoginScreen({super.key});
   AuthController authController= Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: Get.height*0.3,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AppConstants.appLogoOrganic),
          ),

          /// Login Form

          Text("Welcome!",style: GoogleFonts.poppins(fontSize: Get.height*0.03,fontWeight: FontWeight.bold),),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: Get.height*0.07,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
                border: BoxBorder.all(color: Colors.blueGrey,strokeAlign: 1)
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: authController.mobileController,
                decoration: InputDecoration(
                  hintText: "mobile_no".tr,
                  hintStyle: GoogleFonts.poppins(fontSize: Get.height*0.02,color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),


          /// Login Button

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: ()=>authController.sendOtp(),
              child: Container(
                height: Get.height*0.07,
                width: Get.width,
                decoration: BoxDecoration(
                  color: HexColor(AppConstants.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text("login".tr,style: GoogleFonts.poppins(fontSize: Get.height*0.02,color: Colors.white),)),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("login_screen_msg".tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: Get.height*0.016,color: Colors.black),),
          ),

        ],),
      )),
    );
  }
}
