
class AddressHistoryModel {
  String? status;
  int? statusCode;
  String? message;
  List<AddressData>? data;

  AddressHistoryModel({this.status, this.statusCode, this.message, this.data});

  AddressHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => AddressData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["statusCode"] = statusCode;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class AddressData {
  String? addressId;
  String? userId;
  String? holderName;
  String? building;
  String? landmark;
  String? cityId;
  int? setAsDefault;
  String? latitude;
  String? longitude;
  String? houseImage;
  String? addressType;
  String? status;
  String? createdOn;
  String? updatedOn;

  AddressData({this.addressId, this.userId, this.holderName, this.building, this.landmark, this.cityId, this.setAsDefault, this.latitude, this.longitude, this.houseImage, this.addressType, this.status, this.createdOn, this.updatedOn});

  AddressData.fromJson(Map<String, dynamic> json) {
    addressId = json["addressId"];
    userId = json["userId"];
    holderName = json["holderName"];
    building = json["building"];
    landmark = json["landmark"];
    cityId = json["cityId"];
    setAsDefault = json["setAsDefault"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    houseImage = json["houseImage"];
    addressType = json["addressType"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["addressId"] = addressId;
    _data["userId"] = userId;
    _data["holderName"] = holderName;
    _data["building"] = building;
    _data["landmark"] = landmark;
    _data["cityId"] = cityId;
    _data["setAsDefault"] = setAsDefault;
    _data["latitude"] = latitude;
    _data["longitude"] = longitude;
    _data["houseImage"] = houseImage;
    _data["addressType"] = addressType;
    _data["status"] = status;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    return _data;
  }
}