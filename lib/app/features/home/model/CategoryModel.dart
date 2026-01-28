
class CategoryModel {
  String? status;
  int? statusCode;
  String? message;
  List<CategoryData>? data;

  CategoryModel({this.status, this.statusCode, this.message, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => CategoryData.fromJson(e)).toList();
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

class CategoryData {
  String? categoryId;
  String? categoryTitle;
  String? categoryInfo;
  String? categoryPictureId;
  String? cityId;
  String? status;
  String? createdOn;
  String? updatedOn;

  CategoryData({this.categoryId, this.categoryTitle, this.categoryInfo, this.categoryPictureId, this.cityId, this.status, this.createdOn, this.updatedOn});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json["categoryId"];
    categoryTitle = json["categoryTitle"];
    categoryInfo = json["categoryInfo"];
    categoryPictureId = json["categoryPictureId"];
    cityId = json["cityId"];
    status = json["status"];
    createdOn = json["createdOn"];
    updatedOn = json["updatedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["categoryId"] = categoryId;
    _data["categoryTitle"] = categoryTitle;
    _data["categoryInfo"] = categoryInfo;
    _data["categoryPictureId"] = categoryPictureId;
    _data["cityId"] = cityId;
    _data["status"] = status;
    _data["createdOn"] = createdOn;
    _data["updatedOn"] = updatedOn;
    return _data;
  }
}