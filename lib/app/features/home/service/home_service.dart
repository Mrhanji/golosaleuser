import '/app/features/home/model/CategoryModel.dart';
import '/app/features/auth/model/user_model.dart';
import '/app/features/home/model/banner_model.dart';
import '/app/features/city/model/city_model.dart';
import '/services/dio_service.dart';
import '/utils/end_points.dart';


class HomeServices{

  Future<CityModel>getCities()async{
    var response=await DioService().getService(endPoint: EndPoints.getCities);
    return CityModel.fromJson(response.data);
  }


  Future<UserModel>setUserDeviceId()async{
    var response=await DioService().getService(endPoint: EndPoints.getCities);
    return UserModel.fromJson(response.data);
  }


  Future<BannerModel>getBanners(String cityId)async{
    var response=await DioService().getService(endPoint: EndPoints.getCityBanners(cityId));
    return BannerModel.fromJson(response.data);
  }


  Future<CategoryModel>getCategory()async {

    var response=await DioService().getService(endPoint: EndPoints.getCategory);
    return CategoryModel.fromJson(response.data);

  }






}