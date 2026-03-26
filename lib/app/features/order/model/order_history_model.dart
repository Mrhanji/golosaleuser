
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["statusCode"] = statusCode;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["totalOrders"] = totalOrders;
    _data["totalPages"] = totalPages;
    _data["currentPage"] = currentPage;
    _data["pageSize"] = pageSize;
    if(orders != null) {
      _data["orders"] = orders?.map((e) => e.toJson()).toList();
    }
    return _data;
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

  Orders({this.orderId,this.orderNumber, this.userId, this.orderStatus, this.subTotal, this.grandTotal, this.createdOn, this.addressId, this.assignedDeliveryAgentId, this.couponId, this.couponPercent, this.deliveryFee, this.paymentMode, this.paymentRefDetails, this.orderItems, this.totalQty, this.totalItems});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["orderId"] = orderId;
    _data["userId"] = userId;
    _data["orderStatus"] = orderStatus;
    _data["subTotal"] = subTotal;
    _data["grandTotal"] = grandTotal;
    _data["createdOn"] = createdOn;
    _data["addressId"] = addressId;
    _data["assignedDeliveryAgentId"] = assignedDeliveryAgentId;
    _data["couponId"] = couponId;
    _data["couponPercent"] = couponPercent;
    _data["deliveryFee"] = deliveryFee;
    _data["paymentMode"] = paymentMode;
    _data["paymentRefDetails"] = paymentRefDetails;
    if(orderItems != null) {
      _data["orderItems"] = orderItems?.map((e) => e.toJson()).toList();
    }
    _data["totalQty"] = totalQty;
    _data["totalItems"] = totalItems;
    return _data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["recordId"] = recordId;
    _data["qty"] = qty;
    if(product != null) {
      _data["product"] = product?.toJson();
    }
    return _data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["productId"] = productId;
    _data["productTitle"] = productTitle;
    _data["productPrice"] = productPrice;
    _data["productMrp"] = productMrp;
    _data["productThumbnail"] = productThumbnail;
    return _data;
  }
}