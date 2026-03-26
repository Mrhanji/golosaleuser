import 'package:golosaleuser/app/features/order/model/order_history_model.dart';

import '/app/features/home/model/settings_model.dart';
import '/app/features/cart/model/address_model.dart';
import '/app/features/cart/model/cart_model.dart';
import '/app/features/search/model/products_model.dart';
import '/app/features/home/model/CategoryModel.dart';
import '/app/features/auth/model/user_model.dart';
import '/app/features/home/model/banner_model.dart';
import '/app/features/city/model/city_model.dart';
import '/services/dio_service.dart';
import '/utils/end_points.dart';


class HomeServices{

  Future<CityModel>getCities()async{
    var response=await DioService().getService(endPoint: EndPoints.getCities);
    return CityModel.fromJson(response.data);
  }


  Future<UserModel>setUserDeviceId()async{
    var response=await DioService().getService(endPoint: EndPoints.getCities);
    return UserModel.fromJson(response.data);
  }


  Future<BannerModel>getBanners(String cityId)async{
    var response=await DioService().getService(endPoint: EndPoints.getCityBanners(cityId));
    return BannerModel.fromJson(response.data);
  }


  Future<CategoryModel>getCategory()async {

    var response=await DioService().getService(endPoint: EndPoints.getCategory);
    return CategoryModel.fromJson(response.data);

  }




  Future<ProductsModel> searchProduct(String title)async{
    var response=await DioService().getService(endPoint: EndPoints.searchProduct(title));
    return ProductsModel.fromJson(response.data);
    }




   Future<ProductsModel>getSingleProductById(String productId)async{
    var response=await DioService().getService(endPoint: EndPoints.getSingleProductById(productId));
    print(response.data);
    return ProductsModel.fromJson(response.data);
   }


   Future<ProductsModel>getCategoryProducts(String categoryId)async{
    var response=await DioService().getService(endPoint: EndPoints.searchProductByCategory(categoryId));
    return ProductsModel.fromJson(response.data);
   }



   Future<CartModel>getCart(String userId)async{
    var response=await DioService().getService(endPoint: EndPoints.getCartItems(userId));
    return CartModel.fromJson(response.data);
   }


   Future<dynamic>addToCart(Map<String,dynamic>body)async {
     var response = await DioService().postService(endPoint: EndPoints.addCart,dataBody: body);
     return response.data;

   }

   Future<dynamic>updateToCart(Map<String,dynamic>body)async {
    print(body);
     var response = await DioService().putService(endPoint: EndPoints.updateCart,dataBody: body);
     return response.data;
   }

   Future<dynamic>removeCart(String cartId)async{
    var response=await DioService().getService(endPoint: EndPoints.removeCartItem(cartId));
    return response.data;
   }

   Future<AddressModel>getAddress(userId)async{
    var response=await DioService().getService(endPoint: EndPoints.getAddress(userId));
    return AddressModel.fromJson(response.data);
}


Future<SettingsModel>getAppSettings()async{
    var response=await

    DioService().getService(endPoint: EndPoints.appSetting);
    print(response.data);
    return SettingsModel.fromJson(response.data);

  }
  
  
  Future<dynamic>placeOrder(dataBody)async{
    var response=await DioService().postService(endPoint: EndPoints.placeOrder, dataBody: dataBody);
    return response.data;
  }


  Future<OrderHistoryModel>getOrderHistory(userId)async{
    var response=await DioService().getService(endPoint: EndPoints.getOrderHistory(userId));
    return OrderHistoryModel.fromJson(response.data);
  }

}