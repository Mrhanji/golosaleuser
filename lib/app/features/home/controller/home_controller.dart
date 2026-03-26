import 'dart:convert';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/model/settings_model.dart';
import 'package:golosaleuser/app/routes/app_routes.dart';
import '/app/features/search/model/products_model.dart';
import '/app/features/home/model/CategoryModel.dart';
import '/app/features/home/model/banner_model.dart';
import '/app/features/auth/model/user_model.dart';
import '/app/features/city/model/city_model.dart';
import '../../../../database/local_db.dart';
import '../service/home_service.dart';


class HomeController extends GetxController {

  UserModel userModel=UserModel();
  CityModel cityModel=CityModel();
  CategoryModel categoryModel=CategoryModel();
  ProductsModel productsModel=ProductsModel();
  BannerModel bannerModel=BannerModel();
  SettingsModel settingsModel=SettingsModel();
  final RxInt selectedIndex = 0.obs;
  final RxBool isCityLoading=true.obs;
  late  CityData defaultCity=CityData();
  final RxBool defaultCityIsEmpty=true.obs;
  final RxBool isBannerLoading=true.obs;
  final RxBool isCategoryLoading=true.obs;
  final RxBool isCategoryItemLoading=true.obs;


  void setNavIndex(int i) => selectedIndex.value = i;

  void setCity(int cityIndex)async{
    print(cityModel.data![cityIndex].toJson());
    await SecurePreferenceStorage().setDefaultCity(jsonEncode(cityModel.data![cityIndex]).toString());
    defaultCity=cityModel.data![cityIndex];
    defaultCityIsEmpty.value=false;
    _callAllFunctions();
    update();
  }

  restCity(){
    defaultCityIsEmpty.value=true;
    update();
  }





  getUser()async{
    var user=await SecurePreferenceStorage().getLoginUser();
    userModel=UserModel.fromJson(jsonDecode(user.toString()));
    print(userModel.data?.firstName);
    update();
  }


  logout()async{
    await SecurePreferenceStorage().setLoginStatus(false);
    await SecurePreferenceStorage().setLoginUser("");
    Get.offAllNamed("/login");
  }


  getCities()async{
    isCityLoading.value=true;
    cityModel=await HomeServices().getCities();
    isCityLoading.value=false;
    update();
  }

  _getDefaultCity()async{
    var city=await SecurePreferenceStorage().getDefaultCity();
    if(city.isNotEmpty){
      defaultCity=CityData.fromJson(jsonDecode(city));
      defaultCityIsEmpty.value=false;
    }else{
      defaultCityIsEmpty.value=true;
    }}




  getBanners()async{
    isBannerLoading.value=true;
    bannerModel=await HomeServices().getBanners(defaultCity.cityId??'');
    isBannerLoading.value=false;
    update();

  }


  getCategory()async{
    isCategoryLoading.value=true;
    categoryModel=await HomeServices().getCategory();
    isCategoryLoading.value=false;
    update();
  }


  getCategoryItem(categoryId)async{
    isCategoryItemLoading.value=true;
    productsModel=ProductsModel();
    update();
    productsModel=await HomeServices().getCategoryProducts(categoryId);
    isCategoryItemLoading.value=false;
    update();

  }


  _callAllFunctions(){
    _getDefaultCity();
    getCities();
    getCategory();
    getBanners();
  }


  getSettings()async{
    settingsModel=await HomeServices().getAppSettings();
    if(settingsModel.data?.first.maintenanceMode ==1){
      Get.offAllNamed(AppRoutes.maintenanceModeScreen);
    }
  }


  checkPermissions()async{
    //Check here allow user permission for location and notifications if not allowed then ask for allow these permission if user not allow then cloes app.



  }


  @override
  void onInit() {
    super.onInit();
    getSettings();
    getUser();
    _getDefaultCity();
    getCities();
    getBanners();
    getCategory();

  }
}
