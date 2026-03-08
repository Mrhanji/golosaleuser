
class CartModel {
  String? status;
  int? statusCode;
  String? message;
  List<CartData>? data;

  CartModel({this.status, this.statusCode, this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => CartData.fromJson(e)).toList();
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

class CartData {
  String? cartId;
  String? userId;
  String? productId;
  int? productQty;
  String? createdOn;
  String? updatedOn;
  ProductDetails? productDetails;

  CartData({this.cartId, this.userId, this.productId, this.productQty, this.createdOn, this.updatedOn, this.productDetails});

  CartData.fromJson(Map<String, dynamic> json) {
    cartId = json["cartId"];
    userId = json["userId"];
    productId = json["productId"];
    productQty = json["productQty"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
    productDetails = json["productDetails"] == null ? null : ProductDetails.fromJson(json["productDetails"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cartId"] = cartId;
    _data["userId"] = userId;
    _data["productId"] = productId;
    _data["productQty"] = productQty;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    if(productDetails != null) {
      _data["productDetails"] = productDetails?.toJson();
    }
    return _data;
  }
}

class ProductDetails {
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

  ProductDetails({this.productId, this.productTitle, this.productInfo, this.productPrice, this.productMrp, this.productStock, this.productThumbnail, this.productCategoryId, this.hasSubscriptionModel, this.productUnitTag, this.status, this.createdOn, this.updatedOn});

  ProductDetails.fromJson(Map<String, dynamic> json) {
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
    _data["productUnitTag"] = productUnitTag;
    _data["status"] = status;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    return _data;
  }
}