class UserModel {
  String? status;
  int? statusCode;
  String? message;
  Data? data;

  UserModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];

    final dynamic rawData = json["data"];

    if (rawData is List && rawData.isNotEmpty) {
      // backend returns list → take first item
      data = Data.fromJson(rawData.first);
    } else if (rawData is Map<String, dynamic>) {
      // backend returns object
      data = Data.fromJson(rawData);
    } else {
      // empty list or null
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json["status"] = status;
    json["statusCode"] = statusCode;
    json["message"] = message;
    if (data != null) {
      json["data"] = data!.toJson();
    }
    return json;
  }
}

class Data {
  String? userId;
  String? firstName;
  String? lastName;
  String? userMobile;
  String? userEmail;
  String? gender;
  String? walletAmount;
  String? refferalCode;
  int? otpCode;
  String? otpValidity;
  String? parentUserReferralCode;
  String? profilePicture;
  String? status;
  String? createdOn;
  String? updatedOn;

  Data({
    this.userId,
    this.firstName,
    this.lastName,
    this.userMobile,
    this.userEmail,
    this.gender,
    this.walletAmount,
    this.refferalCode,
    this.otpCode,
    this.otpValidity,
    this.parentUserReferralCode,
    this.profilePicture,
    this.status,
    this.createdOn,
    this.updatedOn,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    userMobile = json["userMobile"]?.toString();
    userEmail = json["userEmail"];
    gender = json["gender"];
    walletAmount = json["walletAmount"]?.toString();
    refferalCode = json["refferalCode"];
    otpCode = json["otpCode"];
    otpValidity = json["otpValidity"]?.toString();
    parentUserReferralCode = json["parentUserReferralCode"];
    profilePicture=json["profilePicture"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json["userId"] = userId;
    json["firstName"] = firstName;
    json["lastName"] = lastName;
    json["userMobile"] = userMobile;
    json["userEmail"] = userEmail;
    json["gender"] = gender;
    json["walletAmount"] = walletAmount;
    json["refferalCode"] = refferalCode;
    json["otpCode"] = otpCode;
    json["otpValidity"] = otpValidity;
    json["parentUserReferralCode"] = parentUserReferralCode;
    json["profilePicture"] = profilePicture;
    json["status"] = status;
    json["createdOn"] = createdOn;
    json["updatedOn"] = updatedOn;
    return json;
  }
}
