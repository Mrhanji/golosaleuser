import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../utils/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';


class OtpScreen extends StatelessWidget {
   OtpScreen({super.key});
  AuthController authController= Get.put(AuthController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height*0.01,),
            SizedBox(
                height: Get.height*0.3,
                child: Image.asset(AppConstants.otpVerifyImage)),
            //SizedBox(height: Get.height*0.3,),
            Text("enter_otp".tr,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: Get.height*0.03),),

            Text("otp_msg".tr,style: GoogleFonts.poppins(),textAlign: TextAlign.center,),
            Container(
              height: Get.height*0.1,
              width: Get.width,
              child: Pinput(
                controller: authController.otpController,
              ),
            ),
            TextButton(onPressed: ()=>Get.back(), child: Text("resend_otp".tr,style: GoogleFonts.poppins(),)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: ()=>authController.doLogin(),
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


            TextButton(onPressed: ()=>Get.back(), child: Text("change_number".tr,style: GoogleFonts.poppins(color: Colors.red),)),


          ],
        ),
      )),
    );
  }
}
