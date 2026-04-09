
class WalletTransactionsModel {
  String? status;
  int? statusCode;
  String? message;
  Data? data;

  WalletTransactionsModel({this.status, this.statusCode, this.message, this.data});

  WalletTransactionsModel.fromJson(Map<String, dynamic> json) {
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
  int? totalTransactions;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<Transactions>? transactions;

  Data({this.totalTransactions, this.totalPages, this.currentPage, this.pageSize, this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    totalTransactions = json["totalTransactions"];
    totalPages = json["totalPages"];
    currentPage = json["currentPage"];
    pageSize = json["pageSize"];
    transactions = json["transactions"] == null ? null : (json["transactions"] as List).map((e) => Transactions.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["totalTransactions"] = totalTransactions;
    _data["totalPages"] = totalPages;
    _data["currentPage"] = currentPage;
    _data["pageSize"] = pageSize;
    if(transactions != null) {
      _data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Transactions {
  int? id;
  String? userId;
  int? amount;
  int? lastAmount;
  String? createdOn;
  String? transType;
  String? message;

  Transactions({this.id, this.userId, this.amount, this.lastAmount, this.createdOn, this.transType, this.message});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    amount = json["amount"];
    lastAmount = json["lastAmount"];
    createdOn = json["createdOn"];
    transType = json["transType"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["userId"] = userId;
    _data["amount"] = amount;
    _data["lastAmount"] = lastAmount;
    _data["createdOn"] = createdOn;
    _data["transType"] = transType;
    _data["message"] = message;
    return _data;
  }
}