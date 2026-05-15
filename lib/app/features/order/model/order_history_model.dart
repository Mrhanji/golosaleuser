
class OrderHistoryModel {
  String? status;
  int? statusCode;
  String? message;
  Data? data;

  OrderHistoryModel({this.status, this.statusCode, this.message, this.data});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }


}

class Data {
  int? totalOrders;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<Orders>? orders;

  Data({this.totalOrders, this.totalPages, this.currentPage, this.pageSize, this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    totalOrders = json["totalOrders"];
    totalPages = json["totalPages"];
    currentPage = json["currentPage"];
    pageSize = json["pageSize"];
    orders = json["orders"] == null ? null : (json["orders"] as List).map((e) => Orders.fromJson(e)).toList();
  }


}

class Orders {
  String? orderId;
  int? orderNumber;
  String? userId;
  String? orderStatus;
  String? subTotal;
  String? grandTotal;
  String? createdOn;
  String? addressId;
  String? assignedDeliveryAgentId;
  String? couponId;
  int? couponPercent;
  int? deliveryFee;
  String? paymentMode;
  String? paymentRefDetails;
  List<OrderItems>? orderItems;
  int? totalQty;
  int? totalItems;
  bool? isSubscriptionOrder;

  Orders({this.orderId,this.orderNumber, this.userId, this.orderStatus, this.subTotal, this.grandTotal, this.createdOn, this.addressId, this.assignedDeliveryAgentId, this.couponId, this.couponPercent, this.deliveryFee, this.paymentMode, this.paymentRefDetails, this.orderItems, this.totalQty, this.totalItems,this.isSubscriptionOrder});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json["orderId"];
    orderNumber = json["orderNumber"];
    userId = json["userId"];
    orderStatus = json["orderStatus"];
    subTotal = json["subTotal"];
    grandTotal = json["grandTotal"];
    createdOn = json["createdOn"];
    addressId = json["addressId"];
    assignedDeliveryAgentId = json["assignedDeliveryAgentId"];
    couponId = json["couponId"];
    couponPercent = json["couponPercent"];
    deliveryFee = json["deliveryFee"];
    paymentMode = json["paymentMode"];
    paymentRefDetails = json["paymentRefDetails"];
    orderItems = json["orderItems"] == null ? null : (json["orderItems"] as List).map((e) => OrderItems.fromJson(e)).toList();
    totalQty = json["totalQty"];
    totalItems = json["totalItems"];
    isSubscriptionOrder = json["isSubscriptionOrder"].toString()=='yes'?true:false;
  }


}

class OrderItems {
  int? recordId;
  int? qty;
  Product? product;

  OrderItems({this.recordId, this.qty, this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    recordId = json["recordId"];
    qty = json["qty"];
    product = json["product"] == null ? null : Product.fromJson(json["product"]);
  }


}

class Product {
  String? productId;
  String? productTitle;
  String? productPrice;
  String? productMrp;
  String? productThumbnail;
  String? productUnitTag;

  Product({this.productId, this.productTitle, this.productPrice, this.productMrp, this.productThumbnail,this.productUnitTag});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json["productId"];
    productTitle = json["productTitle"];
    productPrice = json["productPrice"];
    productMrp = json["productMrp"];
    productThumbnail = json["productThumbnail"];
    productUnitTag = json["productUnitTag"];
  }


}