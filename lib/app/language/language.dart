import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'english':'English',
      'change_language':'Change Language',
      'welcome': 'Welcome',
      'skip': 'Skip',
      'next': 'Next',
      'done': 'Done',
      'onboarding_image_only': 'Image',
      'profile': 'Profile',
      'logout': 'Logout',
      'settings': 'Settings',
      'login_screen_msg':"By continuing, you agree to our Terms of Service and Privacy Policy.",
      'login':"Login",
      'mobile_no':"Mobile No.",
      'enter_otp':"Enter OTP",
      'otp_msg':"We have sent a 6 digit OTP to your registered mobile number",
      'resend_otp':'Resend OTP',
      'change_number':'Change Number?',
      'home':"Home",
      'cart':"Cart",
      'search':'Search',
      'category':'Category',
      'shop_by_category':'Shop by category',
      'popular_items':'Popular Items',
      'search_for_product':'Search For Product',
      'recent_search':'Recent Searches',
      'order_summary':'Order Summary',
      'order_now':'Order Now',
      'check_out':'Check Out',
      'delivery_address':'Delivery Address',
      'add_new_address':'Add New Address',
      'edit_address':'Edit Address',
      'select_address':'Select Address',
      'subtotal':'Subtotal',
      'delivery_charge':'Delivery Charge',
      'total_amount':'Total Amount',
      'order_placed':'Order Placed',
      'order_placed_msg':'Your order has been placed successfully.',
      'coupon_code':'Coupon Code',
      'apply':'Apply',
      'remove':'Remove',
      'discount':'Discount',
      'account':'Account',
      'order_history':'Order History',
      'personal_information':'Personal Information',
      'subscriptions':'Subscriptions',
      'language':'Language',
      'notifications':'Notifications',
      'help_center':'Help Center',
      'about_us':'About Us',
      'refer_code':'Refer Code',
      'refer':'Refer',
      'tap_to_share':'Tap to Share',
      'refer_and_earn':'Refer and Earn',
      'refer_terms':'Refer Terms',
      'you_will_get':'You will get.',
      'coupon':'Coupon',
      "refer_how_title": "How Refer & Earn Works",
      "refer_how_desc": "Share your referral code with friends. When they sign up and start their first paid milk subscription, you earn rewards instantly.",
      "refer_reward_title": "What Rewards Will I Get?",
      "refer_reward_desc": "For every successful referral, rewards are added to your GoloSale wallet. You can use them on future milk deliveries.",
      "refer_eligibility_title": "Who Can Participate?",
      "refer_eligibility_desc": "All registered GoloSale users can participate. There is no limit on how many friends you can refer.",
      "refer_rules_title": "Important Rules to Remember",
      "refer_rules_desc": "Rewards are given only for genuine referrals. Self-referrals or fake accounts may result in reward cancellation.",
      "refer_count_title": "Total Referrals",
      "refer_earning_title": "Total Earnings",
      "edit_profile": "Edit Profile",
      "name": "Name",
      "email": "Email",
      "phone": "Phone",
      "password": "Password",
      "gender": "Gender",
      "male": "Male",
      "female": "Female",
      "other": "Other",
      "save_changes": "Save Changes",
      "change_photo":"Change Photo",
      "parent_refer_code":"Parent Refer Code",
      'purchase_type':'Purchase Type',
      'one_time':'One Time',
      'subscription':'Subscription',
      'online_payment':'Online Payment',
      'cash_on_delivery':'Cash on Delivery',
      'payment_method':'Payment Method',
      'total':'Total',
      'add_to_cart':'Add to Cart'



    },
    'hi_IN': {
      'hello': 'नमस्ते',
      'hindi':'हिन्दी',
      'welcome': 'स्वागत है',
      'skip': 'छोड़ें',
      'next': 'आगे',
      'done': 'समाप्त',
      'onboarding_image_only': 'छवि',
      'profile': 'प्रोफ़ाइल',
      'logout': 'लॉग आउट',
      'settings': 'सेटिंग्स',
      'login_screen_msg':'',
      "refer_count_title": "कुल रेफरल",
      "refer_earning_title": "कुल कमाई",

      "refer_how_title": "Refer & Earn कैसे काम करता है",
      "refer_how_desc": "अपना रेफरल कोड दोस्तों के साथ शेयर करें। उनके पहले पेड सब्सक्रिप्शन पर आपको रिवॉर्ड मिलता है।",

      "refer_reward_title": "मुझे क्या रिवॉर्ड मिलेगा?",
      "refer_reward_desc": "रिवॉर्ड आपके GoloSale वॉलेट में जुड़ जाता है और भविष्य की डिलीवरी में इस्तेमाल किया जा सकता है।",

      "refer_eligibility_title": "कौन भाग ले सकता है?",
      "refer_eligibility_desc": "सभी रजिस्टर्ड यूजर्स इस प्रोग्राम में भाग ले सकते हैं।",

      "refer_rules_title": "जरूरी नियम",
      "refer_rules_desc": "सेल्फ रेफरल या फर्जी अकाउंट पर रिवॉर्ड रद्द किया जा सकता है।"
    },
  };
}

class Locales {
  static const Locale en = Locale('en', 'US');
  static const Locale hi = Locale('hi', 'IN');

  static List<Locale> get supported => [en, hi];
}

class LocaleService {
  /// Call `LocaleService.updateLocale(Locales.hi)` or `Locales.en`
  static void updateLocale(Locale locale) {
    Get.updateLocale(locale);
  }

  static Locale get fallback => Locales.en;
}
