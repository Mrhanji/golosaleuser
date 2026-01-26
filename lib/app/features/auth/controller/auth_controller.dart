import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '/app/features/auth/model/user_model.dart';
import '/app/features/auth/service/auth_service.dart';
import '../../../../database/local_db.dart';
import '../../../routes/app_routes.dart';

/// Auth controller
///
///

class AuthController extends GetxController{
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  AuthService authService =AuthService();
  UserModel userModel=UserModel();



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  /// Send Otp
  sendOtp()async{

    try{
      print("mobile lenth ${mobileController.text.length}");
      if(mobileController.text.length==10){
       userModel= await AuthService().sendOtp(mobileController.text);
       if(userModel.statusCode==200) {
         Get.snackbar("Success", "Otp sent successfully",
             backgroundColor: Colors.green,colorText: Colors.white,
             snackPosition: SnackPosition.BOTTOM);
         Get.toNamed(AppRoutes.otpScreen);
       }else{
         Get.snackbar("Error", userModel.message.toString(),);
       }

    }else{
        Get.snackbar("Error", "Please enter valid mobile number",backgroundColor: Colors.blueGrey.shade300,colorText: Colors.white);
      }
    }catch(e) {
      print(e);
    }

  }





  /// Send Login Request to server.

  doLogin()async{
   /// verify otp and login user.
    print("Otp is:- ${otpController.text}");
    if(otpController.text.length==4){
      var response=await authService.verifyOtp(mobile: mobileController.text,otp: otpController.text);
      if(response.data!=null){
        Get.snackbar("Success", "Login successfully",snackPosition: SnackPosition.BOTTOM);
        await SecurePreferenceStorage().setLoginStatus(true);
        await SecurePreferenceStorage().setLoginUser(jsonEncode(response.toJson()).toString());
        Get.offAllNamed(AppRoutes.home);
      }else{
        Get.snackbar("Error", response.message.toString(),snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
      }
    }else{
      Get.snackbar("Error", "Please enter valid otp",snackPosition: SnackPosition.BOTTOM);
    }



  }



}