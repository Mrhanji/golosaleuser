import '/utils/app_constants.dart';

class EndPoints{
  static const String sendOtp="/auth/sendOtp";
  static const String verifyOtp="/auth/verifyOtp";
  static const String getCities="/cities/getAllCities";
  static const String getCategory="/category/getCategories";
  static const String updateProfile="";
  static const String getAddress="";
  static  String getCityBanners(String cityId)=>"/banners/bannersByCity?cityId=$cityId";



  /// Media Url
  static  String mediaUrl(String mediaId)=>"${AppConstants.apiUrl}/media/getMediaById?mediaId=$mediaId";
}