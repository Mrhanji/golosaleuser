
class SubscriptionDetailsModel {
  String? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  SubscriptionDetailsModel({this.status, this.statusCode, this.message, this.data});

  SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }


}

class Data {
  int? subscriptionId;
  String? userId;
  String? productId;
  int? productQty;
  int? productPrice;
  String? startAt;
  String? endAt;
  int? planDuration;
  String? totalBill;
  String? addressId;
  String? paymentMode;
  String? status;
  String? createdAt;
  String? updatedAt;
  ProductInfo? productInfo;
  Address? address;
  List<Days>? days;

  Data({this.subscriptionId, this.userId, this.productId, this.productQty, this.productPrice, this.startAt, this.endAt, this.planDuration, this.totalBill, this.addressId, this.paymentMode, this.status, this.createdAt, this.updatedAt, this.productInfo, this.address, this.days});

  Data.fromJson(Map<String, dynamic> json) {
    subscriptionId = json["subscriptionId"];
    userId = json["userId"];
    productId = json["productId"];
    productQty = json["productQty"];
    productPrice = json["productPrice"];
    startAt = json["startAt"];
    endAt = json["endAt"];
    planDuration = json["planDuration"];
    totalBill = json["totalBill"];
    addressId = json["addressId"];
    paymentMode = json["paymentMode"];
    status = json["status"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    productInfo = json["productInfo"] == null ? null : ProductInfo.fromJson(json["productInfo"]);
    address = json["address"] == null ? null : Address.fromJson(json["address"]);
    days = json["days"] == null ? null : (json["days"] as List).map((e) => Days.fromJson(e)).toList();
  }


}

class Days {
  int? id;
  int? subscriptionId;
  String? userId;
  String? pauseAt;
  String? reStartAt;
  String? createdAt;
  String? updatedAt;

  Days({this.id, this.subscriptionId, this.userId, this.pauseAt, this.reStartAt, this.createdAt, this.updatedAt});

  Days.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    subscriptionId = json["subscriptionId"];
    userId = json["userId"];
    pauseAt = json["pauseAt"];
    reStartAt = json["reStartAt"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["subscriptionId"] = subscriptionId;
    _data["userId"] = userId;
    _data["pauseAt"] = pauseAt;
    _data["reStartAt"] = reStartAt;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class Address {
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
  int? pinCode;
  String? status;
  String? createdOn;
  String? updatedOn;

  Address({this.addressId, this.userId, this.holderName, this.building, this.landmark, this.cityId, this.setAsDefault, this.latitude, this.longitude, this.houseImage, this.addressType, this.pinCode, this.status, this.createdOn, this.updatedOn});

  Address.fromJson(Map<String, dynamic> json) {
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
    pinCode = json["pinCode"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }


}

class ProductInfo {
  String? productId;
  String? productTitle;
  String? productInfo;
  String? productPrice;
  String? productMrp;
  int? productStock;
  String? productThumbnail;
  String? productCategoryId;
  int? hasSubscriptionModel;
  String? productUnitTag;
  String? status;
  String? createdOn;
  String? updatedOn;

  ProductInfo({this.productId, this.productTitle, this.productInfo, this.productPrice, this.productMrp, this.productStock, this.productThumbnail, this.productCategoryId, this.hasSubscriptionModel, this.productUnitTag, this.status, this.createdOn, this.updatedOn});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    productId = json["productId"];
    productTitle = json["productTitle"];
    productInfo = json["productInfo"];
    productPrice = json["productPrice"];
    productMrp = json["productMrp"];
    productStock = json["productStock"];
    productThumbnail = json["productThumbnail"];
    productCategoryId = json["productCategoryId"];
    hasSubscriptionModel = json["hasSubscriptionModel"];
    productUnitTag = json["productUnitTag"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }


}