import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/features/auth/service/auth_service.dart';
import '/app/features/home/model/settings_model.dart';
import '/app/routes/app_routes.dart';
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
  ProductsModel popularProductsModel=ProductsModel();
  BannerModel bannerModel=BannerModel();
  SettingsModel settingsModel=SettingsModel();
  final RxInt selectedIndex = 0.obs;
  final RxBool isCityLoading=true.obs;
  late  CityData defaultCity=CityData();
  final RxBool defaultCityIsEmpty=true.obs;
  RxInt currentIndex = 0.obs;
  final RxBool isBannerLoading=true.obs;
  final RxBool isCategoryLoading=true.obs;
  final RxBool isPopularProductLoading=true.obs;
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
    userModel=await AuthService().getProfile(userModel.data?.userId);
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
      print(city);
      defaultCity=CityData.fromJson(jsonDecode(city));
      print("Default :${defaultCity.cityName}");
      defaultCityIsEmpty.value=false;
    }else{
      defaultCityIsEmpty.value=true;
    }}




  getBanners()async{
    isBannerLoading.value=true;
   await _getDefaultCity();
    bannerModel=await HomeServices().getBanners(defaultCity.cityId.toString());
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

  updateProfile(body)async{
    print(jsonEncode(body));
    var response=await AuthService().updateProfile(body,userModel.data!.userId);
    print(response);
    getUser();
    Get.back();
    Get.back();
    Get.snackbar("success".tr, "profile_update_msg".tr,backgroundColor: Colors.white);
  }

  getPopularProducts()async{
    popularProductsModel=await HomeServices().getPopularProducts();
    isPopularProductLoading.value=false;
    update();
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
    getPopularProducts();
  }
}
