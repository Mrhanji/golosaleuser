
class SettingsModel {
  String? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  SettingsModel({this.status, this.statusCode, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
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

class Data {
  int? settingsId;
  int? deliveryFreeAbove;
  int? deliveryFee;
  int? referReceiverCommission;
  int? maintenanceMode;
  int? isCodEnable;

  Data({this.settingsId, this.deliveryFreeAbove, this.deliveryFee, this.referReceiverCommission, this.maintenanceMode, this.isCodEnable});

  Data.fromJson(Map<String, dynamic> json) {
    settingsId = json["settingsId"];
    deliveryFreeAbove = json["deliveryFreeAbove"];
    deliveryFee = json["deliveryFee"];
    referReceiverCommission = json["referReceiverCommission"];
    maintenanceMode = json["maintenanceMode"];
    isCodEnable = json["isCodEnable"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["settingsId"] = settingsId;
    _data["deliveryFreeAbove"] = deliveryFreeAbove;
    _data["deliveryFee"] = deliveryFee;
    _data["referReceiverCommission"] = referReceiverCommission;
    _data["maintenanceMode"] = maintenanceMode;
    _data["isCodEnable"] = isCodEnable;
    return _data;
  }
}