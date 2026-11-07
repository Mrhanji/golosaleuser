import 'package:dio/dio.dart';

import '/app/features/auth/model/user_model.dart';
import '/services/dio_service.dart';
import '/utils/end_points.dart';

class AuthService {
  DioService dioService = DioService();

  Future<UserModel> sendOtp(mobileNumber) async {
    var response = await dioService.postService(
      endPoint: EndPoints.sendOtp,
      dataBody: {"mobile": mobileNumber},
    );
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> verifyMobile(String mobileNumber) async {
    var response = await dioService.postService(
      endPoint: EndPoints.verifyMobile,
      dataBody: {"mobile": mobileNumber},
    );
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> registerUser({
    required String mobile,
    required String firstName,
    required String lastName,
    String? parentReferralCode,
  }) async {
    final Map<String, dynamic> body = {
      "mobile": mobile,
      "firstName": firstName,
      "lastName": lastName,
    };
    if (parentReferralCode != null && parentReferralCode.trim().isNotEmpty) {
      body["parentReferralCode"] = parentReferralCode.trim();
    }
    var response = await dioService.postService(
      endPoint: EndPoints.registerUser,
      dataBody: body,
    );
    return UserModel.fromJson(response.data);
  }

  Future<dynamic> setDeviceToken(String userId, String deviceId) async {
    try {
      var response = await dioService.postService(
        endPoint: EndPoints.setDeviceToken,
        dataBody: {"userId": userId, "deviceId": deviceId},
      );
      return response.data;
    } catch (e) {
      print("Error setting device token: $e");
      return null;
    }
  }

  Future<dynamic> sendDirectOtp(dynamic mobile, dynamic otp) async {
    try {
      final message =
          "Dear Customer, your OTP for account verification is $otp. Please do not share this OTP with anyone. - GOLOSALE ENTERPRISES";
      final encodedText = Uri.encodeComponent(message);
      final url =
          "http://146.88.24.157/api/mt/SendSMS"
          "?user=Golo-Sale"
          "&password=q12345"
          "&senderid=GOLOEP"
          "&channel=Trans"
          "&DCS=0"
          "&flashsms=0"
          "&number=91$mobile"
          "&text=$encodedText"
          "&DLTTemplateId=1707176767589967847"
          "&TelemarketerId=12071651285xxxxxxx"
          "&Peid=1701176414464527430"
          "&route=06";

      final response = await Dio().get(url);
      return response.data;
    } catch (e) {
      print("Error sending direct OTP SMS: $e");
      return null;
    }
  }

  Future<UserModel> verifyOtp({mobile, otp, deviceId}) async {
    var response = await dioService.postService(
      endPoint: EndPoints.verifyOtp,
      dataBody: {"mobile": mobile, "otpCode": otp, 'deviceId': deviceId},
    );
    print("Response:- ${response.data}");
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> getProfile(userId) async {
    var response = await DioService().getService(
      endPoint: EndPoints.getUserProfile(userId),
    );
    return UserModel.fromJson(response.data);
  }

  Future<dynamic> updateProfile(data, userId) async {
    var response = await DioService().postService(
      endPoint: EndPoints.updateProfile(userId),
      dataBody: data,
    );
    return response.data;
  }

  Future<dynamic> verifyReferralCode(String referralCode) async {
    var response = await dioService.getService(
      endPoint: EndPoints.verifyReferralCode(referralCode),
    );
    return response.data;
  }
}
