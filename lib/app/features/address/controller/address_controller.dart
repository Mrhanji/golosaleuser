import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:golosaleuser/utils/utils_functions.dart';
import '/app/features/address/model/address_model.dart';
import '/app/features/address/service/address_service.dart';
import '/app/features/home/controller/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../database/local_db.dart';
import '../../city/model/city_model.dart';

class AddressModel {

  String id;
  String holderName;
  String building;
  String landmark;
  int setAsDefault;
  double latitude;
  double longitude;
  String? houseImage;
  String addressType;
  String? cityId;
  String? status;

  AddressModel({
    required this.id,
    required this.holderName,
    required this.building,
    required this.landmark,
    required this.setAsDefault,
    required this.latitude,
    required this.longitude,
    this.houseImage,
    required this.addressType,
    this.cityId,
    this.status
  });
}

enum AddressFetchingState {
  loading,
  success,
  notFound,
  error,
}
class AddressController extends GetxController {

  RxList<AddressModel> addressList = <AddressModel>[].obs;
  AddressHistoryModel addressHistoryModel=AddressHistoryModel();
  Rx<LatLng> selectedLocation = const LatLng(28.6139, 77.2090).obs;
  Rx<AddressFetchingState> fetchingState = AddressFetchingState.loading.obs;
  GoogleMapController? mapController;
  final ImagePicker picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  String? mediaId='';
  List<int>pinCode=[
    208001,
    208002,
    208003,
    208004,
    208005,
    208006,
    208007,
    208008,
    208009,
    208010,
    208011,
    208012,
    208013,
    208014,
    208015,
    208016,
    208017,
    208018,
    208019,
    208020,
    208021,
    208022,
    208023,
    208024,
    208025,
    208026,
    208027
  ];
  int selectedPinCode=208001;



  selectPinCode(pincode){
    selectedPinCode=pincode;
    update();
  }
    Future pickImage() async {

    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      selectedImage.value = File(image.path);
      var response=await AddressService().uploadAddressImage(File(image.path));
      print(response['message']);
      print(response['data'].first['mediaId']);
      mediaId=response['data'].first['mediaId'];
    }
  }


  fetchAddress()async{
      addressHistoryModel=await AddressService().getAddress(Get.put(HomeController()).userModel.data?.userId);
      if(addressHistoryModel.data!=null){
        fetchingState=AddressFetchingState.success.obs;
      }else{
        fetchingState=AddressFetchingState.notFound.obs;
      }
      update();
  }




  /// SAMPLE DATA
  @override
  void onInit() {
    super.onInit();
fetchAddress();

  }

  void setLocation(LatLng latLng) {
    selectedLocation.value = latLng;
  }

  /// GET CURRENT LOCATION


  void addAddress(AddressModel model) async {

    try {

      var city =
      await SecurePreferenceStorage()
          .getDefaultCity();

      var cityData =
      CityData.fromJson(
        jsonDecode(city),
      );

      if (model.setAsDefault == 1) {

        for (var e in addressList) {
          e.setAsDefault = 0;
        }
      }

      Map<String, dynamic> dataBody = {

        "userId":
        Get.put(HomeController())
            .userModel
            .data
            ?.userId,

        "holderName":
        model.holderName,

        "building":
        model.building,

        "landmark":
        model.landmark,

        "cityId":
        cityData.cityId,

        "setAsDefault":
        model.setAsDefault,

        "latitude":
        model.latitude,

        "longitude":
        model.longitude,

        "houseImage":
        mediaId,

        "addressType":
        model.addressType,

        "pinCode":
        selectedPinCode,

        "status":
        "active"
      };

      print("DAta body $dataBody");

      var response =
      await AddressService()
          .addAddress(dataBody);

      Get.snackbar(
        "success".tr,
        response['message'],
        snackPosition:
        SnackPosition.BOTTOM,
      );

      fetchingState =
          AddressFetchingState
              .loading
              .obs;

      fetchAddress();

    } catch (e) {

      print("ADD ADDRESS ERROR $e");

      Get.snackbar(
        "error".tr,
        "something_went_wrong".tr,
        snackPosition:
        SnackPosition.BOTTOM,
      );
    }
  }

   updateAddress(AddressModel model)async {

    Map<String, dynamic> dataBody = {

      "addressId":model.id,
      "userId":
      Get.put(HomeController())
          .userModel
          .data
          ?.userId,

      "holderName":
      model.holderName,

      "building":
      model.building,

      "landmark":
      model.landmark,


      "setAsDefault":
      model.setAsDefault,

      "latitude":
      model.latitude,

      "longitude":
      model.longitude,

      "houseImage":
      mediaId,

      "addressType":
      model.addressType,

      "pinCode":
      selectedPinCode,

      "status":
      "active"
    };
    try {
      print("Data Body ${jsonEncode(dataBody)}");
      var response=await AddressService().updateAddress(dataBody);
      Get.snackbar(
        "success".tr,
        "address_updated_successfully".tr,
        snackPosition:
        SnackPosition.TOP,
      );

      fetchingState =
          AddressFetchingState
              .loading
              .obs;

      fetchAddress();
return response;

    } catch (e) {

      print("UPDATE ADDRESS ERROR $e");

      Get.snackbar(
        "error".tr,
        "something_went_wrong".tr,
        snackPosition:
        SnackPosition.BOTTOM,
      );
    }
  }

  void deleteAddress(String id) async{
   addressHistoryModel.data?.removeWhere((e) => e.addressId ==id);
    update();
    await AddressService().deleteAddress(id);
  }



  Future getCurrentLocation() async {

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position =
    await Geolocator.getCurrentPosition();

    selectedLocation.value =
        LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLng(selectedLocation.value),
    );
  }
  uploadImage()async{

  }
}