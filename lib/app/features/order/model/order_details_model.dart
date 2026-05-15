
class OrderDetailsModel {
  String? status;
  int? statusCode;
  String? message;
  Data? data;

  OrderDetailsModel({this.status, this.statusCode, this.message, this.data});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }


}

class Data {
  String? orderId;
  int? orderNumber;
  String? userId;
  String? orderStatus;
  String? subTotal;
  String? grandTotal;
  String? createdOn;
  String? couponId;
  int? couponPercent;
  int? deliveryFee;
  String? paymentMode;
  String? paymentRefDetails;
  List<OrderItems>? orderItems;
  Address? address;
  AssignedDeliveryAgent? assignedDeliveryAgent;
  User? user;
  List<OrderUpdates>? orderUpdates;
  bool? isSubscriptionOrder;


  Data({this.orderId, this.orderNumber, this.userId, this.orderStatus, this.subTotal, this.grandTotal, this.createdOn, this.couponId, this.couponPercent, this.deliveryFee, this.paymentMode, this.paymentRefDetails, this.orderItems, this.address, this.assignedDeliveryAgent, this.user, this.orderUpdates,this.isSubscriptionOrder});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json["orderId"];
    orderNumber = json["orderNumber"];
    userId = json["userId"];
    orderStatus = json["orderStatus"];
    subTotal = json["subTotal"];
    grandTotal = json["grandTotal"];
    createdOn = json["createdOn"];
    couponId = json["couponId"];
    couponPercent = json["couponPercent"];
    deliveryFee = json["deliveryFee"];
    paymentMode = json["paymentMode"];
    isSubscriptionOrder = json["isSubscriptionOrder"].toString()=='no'?false:true;
    paymentRefDetails = json["paymentRefDetails"];
    orderItems = json["orderItems"] == null ? null : (json["orderItems"] as List).map((e) => OrderItems.fromJson(e)).toList();
    address = json["address"] == null ? null : Address.fromJson(json["address"]);
    assignedDeliveryAgent = json["assignedDeliveryAgent"] == null ? null : AssignedDeliveryAgent.fromJson(json["assignedDeliveryAgent"]);
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    orderUpdates = json["orderUpdates"] == null ? null : (json["orderUpdates"] as List).map((e) => OrderUpdates.fromJson(e)).toList();
  }


}

class OrderUpdates {
  int? id;
  String? message;
  String? createdOn;
  String? updateType;

  OrderUpdates({this.id, this.message, this.createdOn, this.updateType});

  OrderUpdates.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    message = json["message"];
    createdOn = json["createdOn"];
    updateType = json["updateType"];
  }


}

class User {
  String? userId;
  String? firstName;
  String? lastName;
  String? userMobile;
  dynamic profilePicture;

  User({this.userId, this.firstName, this.lastName, this.userMobile, this.profilePicture});

  User.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    userMobile = json["userMobile"];
    profilePicture = json["profilePicture"];
  }


}

class AssignedDeliveryAgent {
  String? agentId;
  String? firstName;
  String? lastName;
  String? mobile;
  int? isOnline;
  String? status;

  AssignedDeliveryAgent({this.agentId, this.firstName, this.lastName, this.mobile, this.isOnline, this.status});

  AssignedDeliveryAgent.fromJson(Map<String, dynamic> json) {
    agentId = json["agentId"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    mobile = json["mobile"];
    isOnline = json["isOnline"];
    status = json["status"];
  }


}

class Address {
  String? addressId;
  String? holderName;
  String? building;
  String? landmark;
  String? cityId;
  String? latitude;
  String? longitude;
  String? houseImage;
  String? addressType;

  Address({this.addressId, this.holderName, this.building, this.landmark, this.cityId, this.latitude, this.longitude, this.houseImage, this.addressType});

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json["addressId"];
    holderName = json["holderName"];
    building = json["building"];
    landmark = json["landmark"];
    cityId = json["cityId"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    houseImage = json["houseImage"];
    addressType = json["addressType"];
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

  Product({this.productId, this.productTitle, this.productPrice, this.productMrp, this.productThumbnail, this.productUnitTag});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json["productId"];
    productTitle = json["productTitle"];
    productPrice = json["productPrice"];
    productMrp = json["productMrp"];
    productThumbnail = json["productThumbnail"];
    productUnitTag = json["productUnitTag"];
  }


}