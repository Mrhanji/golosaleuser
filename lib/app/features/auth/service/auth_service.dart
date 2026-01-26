import '/app/features/auth/model/user_model.dart';
import '/services/dio_service.dart';
import '/utils/end_points.dart';

class AuthService{
  DioService dioService=DioService();

  Future<UserModel>sendOtp(mobileNumber)async{
      var response=await dioService.postService(endPoint: EndPoints.sendOtp,dataBody: {"mobile":mobileNumber});
      return UserModel.fromJson(response.data);
  }


  Future<UserModel>verifyOtp({mobile,otp})async{
    var response=await dioService.postService(endPoint: EndPoints.verifyOtp,dataBody: {"mobile":mobile,"otpCode":otp});
    print("Response:- ${response.data}");
    return UserModel.fromJson(response.data);

  }
}