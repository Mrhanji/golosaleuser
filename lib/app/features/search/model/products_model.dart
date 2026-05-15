
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
  bool? availableInEveningSlot;
  bool? availableInMorningSlot;
  String? productUnitTag;
  String? status;
  String? createdOn;
  String? updatedOn;

  ProductData({this.productId, this.productTitle, this.productInfo, this.productPrice, this.productMrp, this.productStock, this.productThumbnail, this.productCategoryId, this.hasSubscriptionModel,this.productUnitTag, this.status, this.createdOn, this.updatedOn,this.availableInEveningSlot,this.availableInMorningSlot});

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
    productUnitTag = json["productUnitTag"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
    availableInEveningSlot=json["availableInEveningSlot"]==1;
    availableInMorningSlot=json["availableInMorningSlot"]==1;
  }


}