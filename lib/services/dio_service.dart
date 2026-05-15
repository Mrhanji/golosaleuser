import 'dart:io';

import 'package:dio/dio.dart';
import 'package:golosaleuser/utils/end_points.dart';
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
      print(endPoint);
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

  /// Put Service

  Future<Response>putService({required String endPoint,required Map<String,dynamic> dataBody})async{
    try{
      print("FullUrl:- ${AppConstants.apiUrl}$endPoint");
      return await dio.put(endPoint,data: dataBody);
    }catch(e) {
      throw Exception(e);
    }
  }


  /// Delete Service

  Future<dynamic>deleteService(endPoint,{dataBody})async{
    try{
      print("FullUrl:- ${AppConstants.apiUrl}$endPoint");
      return await dio.delete(endPoint,data: dataBody);
    }catch(e){
      throw Exception(e);
    }
  }


  /// 🚀 Upload Image
  Future<Response?> uploadMedia(File file,endPoint) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      Response response = await dio.post(
       endPoint, // your API
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      /// ✅ Print Full Response
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return response;
    } catch (e) {
      print("UPLOAD ERROR: $e");
    }
  }

}
