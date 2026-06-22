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
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import '/utils/app_constants.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../database/local_db.dart';
import '../service/home_service.dart';

class HomeController extends GetxController {
  UserModel userModel = UserModel();
  CityModel cityModel = CityModel();
  CategoryModel categoryModel = CategoryModel();
  ProductsModel productsModel = ProductsModel();
  ProductsModel popularProductsModel = ProductsModel();
  BannerModel bannerModel = BannerModel();
  SettingsModel settingsModel = SettingsModel();
  final RxInt selectedIndex = 0.obs;
  final RxBool isCityLoading = true.obs;
  late CityData defaultCity = CityData();
  final RxBool defaultCityIsEmpty = true.obs;
  RxInt currentIndex = 0.obs;
  final RxBool isBannerLoading = true.obs;
  final RxBool isCategoryLoading = true.obs;
  final RxBool isPopularProductLoading = true.obs;
  final RxBool isCategoryItemLoading = true.obs;

  void setNavIndex(int i) => selectedIndex.value = i;

  void setCity(int cityIndex) async {
    print(cityModel.data![cityIndex].toJson());
    await SecurePreferenceStorage().setDefaultCity(
      jsonEncode(cityModel.data![cityIndex]).toString(),
    );
    defaultCity = cityModel.data![cityIndex];
    defaultCityIsEmpty.value = false;
    fetchCityDependentData();
    getPopularProducts();
    update();
  }

  void restCity() {
    defaultCityIsEmpty.value = true;
    update();
  }

  Future<void> getUser() async {
    try {
      var user = await SecurePreferenceStorage().getLoginUser();
      if (user != null && user.isNotEmpty) {
        userModel = UserModel.fromJson(jsonDecode(user.toString()));
        userModel = await AuthService().getProfile(userModel.data?.userId);
        print(userModel.data?.firstName);
        update();
      }
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> logout() async {
    await SecurePreferenceStorage().setLoginStatus(false);
    await SecurePreferenceStorage().setLoginUser("");
    Get.offAllNamed("/login");
  }

  Future<void> getCities() async {
    isCityLoading.value = true;
    try {
      cityModel = await HomeServices().getCities();
      if (cityModel.data != null && cityModel.data!.length == 1) {
        await SecurePreferenceStorage().setDefaultCity(
          jsonEncode(cityModel.data![0]).toString(),
        );
        defaultCity = cityModel.data![0];
        defaultCityIsEmpty.value = false;
        await fetchCityDependentData();
      }
    } catch (e) {
      print("Error fetching cities: $e");
    } finally {
      isCityLoading.value = false;
      update();
    }
  }

  Future<void> initDefaultCity() async {
    try {
      var city = await SecurePreferenceStorage().getDefaultCity();
      if (city != null && city.isNotEmpty) {
        print(city);
        defaultCity = CityData.fromJson(jsonDecode(city));
        print("Default :${defaultCity.cityName}");
        defaultCityIsEmpty.value = false;
        await fetchCityDependentData();
      } else {
        defaultCityIsEmpty.value = true;
        await getCities();
      }
    } catch (e) {
      print("Error loading default city: $e");
      defaultCityIsEmpty.value = true;
      await getCities();
    }
  }

  Future<void> fetchCityDependentData() async {
    if (defaultCity.cityId == null) return;
    await Future.wait([getBanners(), getCategory()]);
  }

  Future<void> getBanners() async {
    if (defaultCity.cityId == null) return;
    isBannerLoading.value = true;
    try {
      bannerModel = await HomeServices().getBanners(
        defaultCity.cityId.toString(),
      );
    } catch (e) {
      print("Error getting banners: $e");
    } finally {
      isBannerLoading.value = false;
      update();
    }
  }

  Future<void> getCategory() async {
    if (defaultCity.cityId == null) return;
    isCategoryLoading.value = true;
    try {
      categoryModel = await HomeServices().getCategory(
        defaultCity.cityId.toString(),
      );
    } catch (e) {
      print("Error getting categories: $e");
    } finally {
      isCategoryLoading.value = false;
      update();
    }
  }

  Future<void> getCategoryItem(dynamic categoryId) async {
    isCategoryItemLoading.value = true;
    productsModel = ProductsModel();
    update();
    try {
      productsModel = await HomeServices().getCategoryProducts(categoryId);
    } catch (e) {
      print("Error getting category products: $e");
    } finally {
      isCategoryItemLoading.value = false;
      update();
    }
  }

  Future<void> getSettings() async {
    try {
      settingsModel = await HomeServices().getAppSettings();
      if (settingsModel.data?.first.maintenanceMode == 1) {
        Get.offAllNamed(AppRoutes.maintenanceModeScreen);
      }
    } catch (e) {
      print("Error getting app settings: $e");
    }
  }

  Future<void> checkPermissions() async {
    try {
      // 1. Check Location Permission
      PermissionStatus locationStatus = await Permission.location.status;
      bool locationGranted = locationStatus.isGranted || locationStatus.isLimited;

      // 2. Check Notification Permission
      PermissionStatus notificationStatus = await Permission.notification.status;
      bool notificationsGranted = notificationStatus.isGranted || notificationStatus.isLimited;

      // 3. Skip if already allowed
      if (locationGranted && notificationsGranted) {
        return;
      }

      // 4. Show Beautiful Dialog
      await Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon or graphic container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HexColor(AppConstants.primaryColor).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_outlined,
                    color: HexColor(AppConstants.primaryColor),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Enable Permissions",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "To ensure smooth, real-time order tracking and early morning delivery updates, GoloSale requires location and notification access.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Details of what is needed
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: HexColor(AppConstants.primaryColor), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Location: For precise delivery tracking.",
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.notifications_active_outlined, color: HexColor(AppConstants.primaryColor), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Notifications: For dispatch & arrival alerts.",
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Later",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back(); // close dialog
                          
                          // Request location permission
                          if (!locationGranted) {
                            await Permission.location.request();
                          }
                          // Request notification permission
                          if (!notificationsGranted) {
                            await Permission.notification.request();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor(AppConstants.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Enable All",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      print("Error checking permissions: $e");
    }
  }

  Future<void> updateProfile(dynamic body) async {
    print(jsonEncode(body));
    try {
      var response = await AuthService().updateProfile(
        body,
        userModel.data!.userId,
      );
      print(response);
      getUser();
      Get.back();
      Get.back();
      Get.snackbar(
        "success".tr,
        "profile_update_msg".tr,
        backgroundColor: Colors.white,
      );
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> getPopularProducts() async {
    isPopularProductLoading.value = true;
    try {
      popularProductsModel = await HomeServices().getPopularProducts();
    } catch (e) {
      print("Error getting popular products: $e");
    } finally {
      isPopularProductLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getSettings();
    getUser();
    initDefaultCity();
    getPopularProducts();
    checkPermissions();
  }
}
