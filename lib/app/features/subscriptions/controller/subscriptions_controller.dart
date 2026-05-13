import 'package:get/get.dart';
import '/app/features/home/controller/home_controller.dart';
import '../model/subscription_model.dart';
import '../service/subscription_service.dart';

class SubscriptionsController extends GetxController {

  bool isLoading = false;

  SubscriptionModel subscriptions = SubscriptionModel();

  @override
  void onInit() {
    super.onInit();

    loadSubscriptions();
  }

  void loadSubscriptions() async{

    isLoading = true;
    update();
    subscriptions =await SubscriptionServices().getSubscriptionList(Get.put(HomeController()).userModel.data!.userId.toString());
    isLoading = false;
    update();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'scheduled'.tr;

      case 'completed':
        return 'completed'.tr;

      case 'cancelled':
        return 'cancelled'.tr;



      default:
        return status.tr;
    }
  }


}