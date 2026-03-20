import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  });
}

class AddressController extends GetxController {

  RxList<AddressModel> addressList = <AddressModel>[].obs;

  Rx<LatLng> selectedLocation = const LatLng(28.6139, 77.2090).obs;

  GoogleMapController? mapController;

  /// SAMPLE DATA
  @override
  void onInit() {
    super.onInit();

    addressList.addAll([
      AddressModel(
        id: "1",
        holderName: "Rahul Sharma",
        building: "A-45 Green Apartment",
        landmark: "Near Metro Station",
        setAsDefault: 1,
        latitude: 28.6139,
        longitude: 77.2090,
        addressType: "home",
      ),
      AddressModel(
        id: "2",
        holderName: "Sagar Sharma",
        building: "Sky Residency",
        landmark: "Near Mall",
        setAsDefault: 0,
        latitude: 28.57,
        longitude: 77.32,
        addressType: "office",
      ),
    ]);
  }

  void setLocation(LatLng latLng) {
    selectedLocation.value = latLng;
  }

  /// GET CURRENT LOCATION
  Future<void> getCurrentLocation() async {

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();

    selectedLocation.value =
        LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLng(selectedLocation.value),
    );
  }

  void addAddress(AddressModel model) {

    if (model.setAsDefault == 1) {
      for (var e in addressList) {
        e.setAsDefault = 0;
      }
    }

    addressList.add(model);
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
}