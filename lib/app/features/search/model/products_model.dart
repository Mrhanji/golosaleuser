
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
  String? productUnitTag;
  String? status;
  String? createdOn;
  String? updatedOn;

  ProductData({this.productId, this.productTitle, this.productInfo, this.productPrice, this.productMrp, this.productStock, this.productThumbnail, this.productCategoryId, this.hasSubscriptionModel,this.productUnitTag, this.status, this.createdOn, this.updatedOn});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["productId"] = productId;
    _data["productTitle"] = productTitle;
    _data["productInfo"] = productInfo;
    _data["productPrice"] = productPrice;
    _data["productMrp"] = productMrp;
    _data["productStock"] = productStock;
    _data["productThumbnail"] = productThumbnail;
    _data["productCategoryId"] = productCategoryId;
    _data["hasSubscriptionModel"] = hasSubscriptionModel;
    _data["status"] = status;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    return _data;
  }
}