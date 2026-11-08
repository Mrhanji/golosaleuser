
class CouponModel {
  String? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  CouponModel({this.status, this.statusCode, this.message, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
    status = json["status"]?.toString();
    statusCode = json["statusCode"] is int
        ? json["statusCode"]
        : int.tryParse(json["statusCode"]?.toString() ?? '');
    message = json["message"]?.toString();
    if (json["data"] != null) {
      if (json["data"] is List) {
        data = (json["data"] as List).map((e) => Data.fromJson(e)).toList();
      } else if (json["data"] is Map<String, dynamic>) {
        data = [Data.fromJson(json["data"])];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["statusCode"] = statusCode;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? couponId;
  String? couponCode;
  String? couponInfo;
  String? discountType; // 'percentage' or 'flat'
  double? discountPercentage;
  double? discountAmount;
  double? maxCap;
  double? minCap;
  String? startDate;
  String? endDate;
  int? usageLimit;
  int? usedCount;
  int? perUserLimit;
  bool? isFirstOrderOnly;
  String? status;
  String? createdOn;
  String? updatedOn;

  // Enriched fields from validate & available endpoints
  bool? isValid;
  bool? isEligible;
  String? ineligibilityReason;
  int? userUsedCount;
  int? remainingUses;
  int? remainingUserUses;
  double? potentialDiscount;
  double? discount;
  double? savings;
  double? finalAmount;
  double? orderAmount;
  String? message;

  Data({
    this.couponId,
    this.couponCode,
    this.couponInfo,
    this.discountType,
    this.discountPercentage,
    this.discountAmount,
    this.maxCap,
    this.minCap,
    this.startDate,
    this.endDate,
    this.usageLimit,
    this.usedCount,
    this.perUserLimit,
    this.isFirstOrderOnly,
    this.status,
    this.createdOn,
    this.updatedOn,
    this.isValid,
    this.isEligible,
    this.ineligibilityReason,
    this.userUsedCount,
    this.remainingUses,
    this.remainingUserUses,
    this.potentialDiscount,
    this.discount,
    this.savings,
    this.finalAmount,
    this.orderAmount,
    this.message,
  });

  Data.fromJson(Map<String, dynamic> json) {
    couponId = json["couponId"]?.toString();
    couponCode = json["couponCode"]?.toString();
    couponInfo = json["couponInfo"]?.toString();
    discountType = json["discountType"]?.toString() ?? 'percentage';
    discountPercentage = _toDouble(json["discountPercentage"]);
    discountAmount = _toDouble(json["discountAmount"]);
    maxCap = _toDouble(json["maxCap"]);
    minCap = _toDouble(json["minCap"]);
    startDate = json["startDate"]?.toString();
    endDate = json["endDate"]?.toString();
    usageLimit = _toInt(json["usageLimit"]);
    usedCount = _toInt(json["usedCount"]);
    perUserLimit = _toInt(json["perUserLimit"]);
    isFirstOrderOnly = json["isFirstOrderOnly"] is bool
        ? json["isFirstOrderOnly"]
        : (json["isFirstOrderOnly"] == 1 || json["isFirstOrderOnly"] == "1");
    status = json["status"]?.toString();
    createdOn = json["createdOn"]?.toString();
    updatedOn = json["updatedOn"]?.toString();

    isValid = json["isValid"] == true;
    isEligible = json["isEligible"] == true;
    ineligibilityReason = json["ineligibilityReason"]?.toString();
    userUsedCount = _toInt(json["userUsedCount"]);
    remainingUses = _toInt(json["remainingUses"]);
    remainingUserUses = _toInt(json["remainingUserUses"]);
    potentialDiscount = _toDouble(json["potentialDiscount"]);
    discount = _toDouble(json["discount"]);
    savings = _toDouble(json["savings"]);
    finalAmount = _toDouble(json["finalAmount"]);
    orderAmount = _toDouble(json["orderAmount"]);
    message = json["message"]?.toString();
  }

  static double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["couponId"] = couponId;
    _data["couponCode"] = couponCode;
    _data["couponInfo"] = couponInfo;
    _data["discountType"] = discountType;
    _data["discountPercentage"] = discountPercentage;
    _data["discountAmount"] = discountAmount;
    _data["maxCap"] = maxCap;
    _data["minCap"] = minCap;
    _data["startDate"] = startDate;
    _data["endDate"] = endDate;
    _data["usageLimit"] = usageLimit;
    _data["usedCount"] = usedCount;
    _data["perUserLimit"] = perUserLimit;
    _data["isFirstOrderOnly"] = isFirstOrderOnly;
    _data["status"] = status;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    _data["isValid"] = isValid;
    _data["isEligible"] = isEligible;
    _data["ineligibilityReason"] = ineligibilityReason;
    _data["userUsedCount"] = userUsedCount;
    _data["remainingUses"] = remainingUses;
    _data["remainingUserUses"] = remainingUserUses;
    _data["potentialDiscount"] = potentialDiscount;
    _data["discount"] = discount;
    _data["savings"] = savings;
    _data["finalAmount"] = finalAmount;
    _data["orderAmount"] = orderAmount;
    _data["message"] = message;
    return _data;
  }
}
