
import '../../../../services/dio_service.dart';
import '../../../../utils/end_points.dart';
import '../model/wallet_transaction_model.dart';

class WalletService{
  Future<WalletTransactionsModel>getTransactions(String userId,int page,int limit)async{
    var response=await DioService().getService(endPoint: EndPoints.getWalletTransactions(userId, page, limit));
    return WalletTransactionsModel.fromJson(response.data);

  }
}