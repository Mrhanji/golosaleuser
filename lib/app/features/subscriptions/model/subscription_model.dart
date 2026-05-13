
class SubscriptionModel {
  String? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  SubscriptionModel({this.status, this.statusCode, this.message, this.data});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
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

  Data({this.subscriptionId, this.userId, this.productId, this.productQty, this.productPrice, this.startAt, this.endAt, this.planDuration, this.totalBill, this.addressId, this.paymentMode, this.status, this.createdAt, this.updatedAt});

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
  }


}