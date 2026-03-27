import 'dart:io';
import '/app/features/address/model/address_model.dart';
import '/services/dio_service.dart';
import '/utils/end_points.dart';

class AddressService{

  addAddress(dataBody)async{
    var response=await DioService().postService(endPoint: EndPoints.addAddress, dataBody: dataBody);
    return response.data;
  }


  uploadAddressImage(File file)async{
    var response=await DioService().uploadMedia(file, EndPoints.uploadMedia);
    return response?.data;
  }

  Future<AddressHistoryModel>getAddress(String? userId)async{
    var response=await DioService().getService(endPoint: EndPoints.getAddress(userId!));
    return AddressHistoryModel.fromJson(response.data);
  }

}