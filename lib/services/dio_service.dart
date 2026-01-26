import 'package:dio/dio.dart';
import '/utils/app_constants.dart';

class DioService {
  late final Dio dio;

  DioService() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// GET request
  Future<Response> getService({required String endPoint}) async {
    try {
      return await dio.get(endPoint);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }


  /// POST request

  Future<Response>postService({required String endPoint,required Map<String,dynamic> dataBody})async{
    try {
      print("FullUrl:- ${AppConstants.apiUrl}$endPoint");
      return await dio.post(endPoint,data: dataBody);
    }  catch (e) {
      throw Exception(e);
    }
  }
}
