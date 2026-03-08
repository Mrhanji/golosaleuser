import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import '../../../../database/local_db.dart';
import '../../home/service/home_service.dart';
import '/app/features/search/model/products_model.dart';

/// ================= CONTROLLER =================

class ProductController extends GetxController {
  ProductsModel productsModel=ProductsModel();
  RxBool isProductLoading=true.obs;
  int quantity = 1;
  bool isSubscription = false,isAddedIntoCart=false;
  String selectedPlan = "";

  void increment() {
    quantity++;
    update();
  }

  void decrement() {
    if (quantity > 1) quantity--;
    update();
  }

  void toggleSubscription(bool value) {
    isSubscription = value;
    selectedPlan = "";
    update();
  }

  void selectPlan(String plan) {
    selectedPlan = plan;
    update();
  }


  getProductInfo()async{
    productsModel=await HomeServices().getSingleProductById(Get.arguments);
    isProductLoading.value=false;
    update();
  }


  addToCart()async{
    Map<String,dynamic>body={
      'productId':productsModel.data!.first.productId,
      'userId':Get.put(HomeController()).userModel.data?.userId,
      'productQty':quantity,
    };
    isAddedIntoCart=true;
    update();
    print(body);
    var response=await HomeServices().addToCart(body);
    print(response);
    Get.snackbar("cart_added".tr, '${response['message']}');

  }

  /// init

  @override
  void onInit() {
    super.onInit();
    getProductInfo();
  }

}
