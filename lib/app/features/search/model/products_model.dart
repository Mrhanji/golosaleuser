
class ProductsModel {
  String? status;
  int? statusCode;
  String? message;
  List<ProductData>? data;

  ProductsModel({this.status, this.statusCode, this.message, this.data});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => ProductData.fromJson(e)).toList();
  }


}

class ProductData {
  String? productId;
  String? productTitle;
  String? productInfo;
  String? productPrice;
  String? productMrp;
  int? productStock;
  String? productThumbnail;
  String? productCategoryId;
  int? hasSubscriptionModel;
  bool? availableInMorningSlot;
  bool? availableInEveningSlot;
  String? productUnitTag;
  String? status;
  String? createdOn;
  String? updatedOn;
  dynamic categoryTitle;
  List<SlotPlans>? slotPlans;

  ProductData({this.productId, this.productTitle, this.productInfo, this.productPrice, this.productMrp, this.productStock, this.productThumbnail, this.productCategoryId, this.hasSubscriptionModel, this.availableInMorningSlot, this.availableInEveningSlot, this.productUnitTag, this.status, this.createdOn, this.updatedOn, this.categoryTitle, this.slotPlans});

  ProductData.fromJson(Map<String, dynamic> json) {
    productId = json["productId"];
    productTitle = json["productTitle"];
    productInfo = json["productInfo"];
    productPrice = json["productPrice"];
    productMrp = json["productMrp"];
    productStock = json["productStock"];
    productThumbnail = json["productThumbnail"];
    productCategoryId = json["productCategoryId"];
    hasSubscriptionModel = json["hasSubscriptionModel"];
    availableInMorningSlot = json["availableInMorningSlot"];
    availableInEveningSlot = json["availableInEveningSlot"];
    productUnitTag = json["productUnitTag"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
    categoryTitle = json["categoryTitle"];
    slotPlans = json["slotPlans"] == null ? null : (json["slotPlans"] as List).map((e) => SlotPlans.fromJson(e)).toList();
  }


}

class SlotPlans {
  int? id;
  String? productId;
  String? slotType;
  int? durationDays;
  String? status;
  String? createdAt;
  String? updatedAt;

  SlotPlans({this.id, this.productId, this.slotType, this.durationDays, this.status, this.createdAt, this.updatedAt});

  SlotPlans.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    productId = json["productId"];
    slotType = json["slotType"];
    durationDays = json["durationDays"];
    status = json["status"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }


}