
class BannerModel {
  String? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  BannerModel({this.status, this.statusCode, this.message, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
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

class Data {
  String? bannerId;
  String? cityId;
  String? bannerImageId;
  String? status;
  String? bannerType;
  String? createdOn;
  String? updatedOn;

  Data({this.bannerId, this.cityId, this.bannerImageId, this.status, this.bannerType, this.createdOn, this.updatedOn});

  Data.fromJson(Map<String, dynamic> json) {
    bannerId = json["bannerId"];
    cityId = json["cityId"];
    bannerImageId = json["bannerImageId"];
    status = json["status"];
    bannerType = json["bannerType"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["bannerId"] = bannerId;
    _data["cityId"] = cityId;
    _data["bannerImageId"] = bannerImageId;
    _data["status"] = status;
    _data["bannerType"] = bannerType;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    return _data;
  }
}