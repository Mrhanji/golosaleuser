import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/service/home_service.dart';
import '../../home/controller/home_controller.dart';
import '/app/features/order/model/order_history_model.dart';


enum OrderHistoryState { loading, noItem, error, itemFound }



class OrderHistoryController extends GetxController{
  OrderHistoryState currentOrderHistoryState = OrderHistoryState.loading;
  OrderHistoryModel orderHistoryModel=OrderHistoryModel();


  getHistory()async{
    var userId=Get.put(HomeController()).userModel.data!.userId.toString();
    orderHistoryModel=await HomeServices().getOrderHistory(userId);
    if(orderHistoryModel.data!.orders!.isNotEmpty){
      currentOrderHistoryState=OrderHistoryState.itemFound;
    }else{
      currentOrderHistoryState=OrderHistoryState.noItem;
    }
    update();
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getHistory();
  }

}