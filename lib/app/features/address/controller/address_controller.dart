import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
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


  void addAddress(AddressModel model)async {

    var city=await SecurePreferenceStorage().getDefaultCity();
    var cityData=CityData.fromJson(jsonDecode(city));

    if (model.setAsDefault == 1) {
      for (var e in addressList) {
        e.setAsDefault = 0;
      }
    }
    Map<String,dynamic>dataBody={
      "userId": Get.put(HomeController()).userModel.data?.userId,
      "holderName": model.holderName,
      "building": model.building,
      "landmark": model.landmark,
      "cityId":cityData.cityId,
      "setAsDefault": model.setAsDefault,
      "latitude": model.latitude,
      "longitude": model.longitude,
      "houseImage": mediaId,
      "addressType": model.addressType,
      "status": "active"
    };

    var response=await AddressService().addAddress(dataBody);
    Get.snackbar("Success", response['message']);

    fetchingState=AddressFetchingState.loading.obs;

    fetchAddress();
  }

  void updateAddress(AddressModel model) {

    int index = addressList.indexWhere((e) => e.id == model.id);

    if (index != -1) {

      if (model.setAsDefault == 1) {
        for (var e in addressList) {
          e.setAsDefault = 0;
        }
      }

      addressList[index] = model;
      addressList.refresh();
    }
  }

  void deleteAddress(String id) {
    addressList.removeWhere((e) => e.id == id);
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