import '/services/dio_service.dart';
import '/utils/end_points.dart';

class OrderService{
  
  Future<dynamic>updateOrderStatus(dataBody)async{
    var response=await DioService().putService(endPoint: EndPoints.placeOrder, dataBody: dataBody);
    return response.data;
  }
}