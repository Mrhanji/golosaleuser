import '../model/subscription_details_model.dart';
import '../model/subscription_model.dart';
import '/services/dio_service.dart';
import '/utils/end_points.dart';

class SubscriptionServices{

  Future<SubscriptionDetailsModel>getSubscriptionInfo(String subscriptionId)async{
    var response=await DioService().getService(endPoint: EndPoints.getSubscriptionInfo(subscriptionId));
    return SubscriptionDetailsModel.fromJson(response.data);
  }

  Future<SubscriptionModel>getSubscriptionList(String userId)async{
    var response=await DioService().getService(endPoint: EndPoints.getSubscriptionList(userId));
    return SubscriptionModel.fromJson(response.data);
  }

  Future<dynamic>updateSubscriptionStatus(dataBody)async{
    var response=await DioService().putService(endPoint: EndPoints.updateSubscriptionStatus, dataBody: dataBody);
    return response.data;
  }

  Future<dynamic>removeSubscriptionsStatus(dataBody)async{
    var response=await DioService().deleteService( EndPoints.removeSubscriptionStatus, dataBody: dataBody);
    return response.data;
  }

  Future<dynamic>subscribeSubscription(dataBody)async{
    var response=await DioService().postService(endPoint: EndPoints.subscribeSubscription, dataBody: dataBody);
    print("Response ${response.data}");
    return response.data;
  }
}