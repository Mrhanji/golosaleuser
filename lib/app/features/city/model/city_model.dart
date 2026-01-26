
class CityModel {
  String? status;
  int? statusCode;
  String? message;
  List<CityData>? data;

  CityModel({this.status, this.statusCode, this.message, this.data});

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => CityData.fromJson(e)).toList();
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

class CityData {
  String? cityId;
  String? cityName;
  String? cityImageId;
  String? cityStatus;
  String? createdAt;
  String? updatedAt;

  CityData({this.cityId, this.cityName, this.cityImageId, this.cityStatus, this.createdAt, this.updatedAt});

  CityData.fromJson(Map<String, dynamic> json) {
    cityId = json["cityId"];
    cityName = json["cityName"];
    cityImageId = json["cityImageId"];
    cityStatus = json["cityStatus"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cityId"] = cityId;
    _data["cityName"] = cityName;
    _data["cityImageId"] = cityImageId;
    _data["cityStatus"] = cityStatus;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}