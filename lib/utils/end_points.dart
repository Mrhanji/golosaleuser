import '/utils/app_constants.dart';

class EndPoints{
  static const String sendOtp="/auth/sendOtp";
  static const String verifyOtp="/auth/verifyOtp";
  static const String getCities="/cities/getAllCities";
  static const String getCategory="/category/getCategories";
  static const String popularProduct="/product/popular";

  static const String updateCart="/cart/update";
  static const String addCart="/cart/add";
  static const String addAddress="/address/add";
  static const String appSetting='/settings/get';
  static const String updateAddress='/address/update';
  static const String placeOrder="/orders/order-history";
  static const String addWalletAmount="/wallet/addAmount";
  static const String subscribeSubscription="/subscriptions/add";
  static const String updateSubscription="/subscriptions/update";

  static String getOrderHistory(String userId)=>"/orders/order-history?userId=$userId";
  static String getAddress(String userId)=>"/address/list?userId=$userId";
  static String getCartItems(String userId)=>"/cart/getCart?userId=$userId";
  static String removeCartItem(String cartId)=>"/cart/remove?cartId=$cartId";
  static String getCityBanners(String cityId)=>"/banners/bannersByCity?cityId=$cityId";
  static String searchProduct(String query)=>"/product/search?productTitle=$query";
  static String searchProductByCategory(String categoryId)=>"/product/search?categoryId=$categoryId";
  static String getSingleProductById(String productId)=>"/product/search?productId=$productId";
  static String getWalletTransactions(String userId, int page, int limit)=>"/wallet/userWalletTransaction?userId=$userId&page=$page&limit=$limit";
  static String getUserProfile(String userId)=>'/auth/userProfile?userId=$userId';
  static String getCouponInfo(String couponCode)=>'/coupon/search?couponCode=$couponCode';
  static String updateProfile(String userId)=>'/auth/updateProfile?userId=$userId';
  static String deleteAddress(String addressId)=>"/address/delete?addressId=$addressId";
  static String getSubscriptionInfo(String subscriptionId)=>"/subscriptions/list?subscriptionId=$subscriptionId";
  static String getSubscriptionList(String userId)=>"/subscriptions/list?userId=$userId";


  /// Media Url
  static  String mediaUrl(String mediaId)=>"${AppConstants.apiUrl}/media/getMediaById?mediaId=$mediaId";
  static  const uploadMedia="/media/uploadMedia?tag=address";
}