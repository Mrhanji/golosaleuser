
class CouponModel {
  String? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  CouponModel({this.status, this.statusCode, this.message, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
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
  String? couponId;
  String? couponCode;
  String? couponInfo;
  int? discountPercentage;
  int? maxCap;
  int? minCap;
  String? status;
  String? createdOn;
  String? updatedOn;

  Data({this.couponId, this.couponCode, this.couponInfo, this.discountPercentage, this.maxCap, this.minCap, this.status, this.createdOn, this.updatedOn});

  Data.fromJson(Map<String, dynamic> json) {
    couponId = json["couponId"];
    couponCode = json["couponCode"];
    couponInfo = json["couponInfo"];
    discountPercentage = json["discountPercentage"];
    maxCap = json["maxCap"];
    minCap = json["minCap"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["couponId"] = couponId;
    _data["couponCode"] = couponCode;
    _data["couponInfo"] = couponInfo;
    _data["discountPercentage"] = discountPercentage;
    _data["maxCap"] = maxCap;
    _data["minCap"] = minCap;
    _data["status"] = status;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    return _data;
  }
}