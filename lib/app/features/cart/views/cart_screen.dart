import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/routes/app_routes.dart';
import 'package:golosaleuser/utils/end_points.dart';
import '../model/cart_model.dart';
import '/app/features/home/controller/home_controller.dart';
import '../controller/cart_controller.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cached_network_image/cached_network_image.dart';



class CartScreen extends StatelessWidget {
  final HomeController homeController;
  CartScreen({super.key, required this.homeController});

  final CartController controller =
  Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: Text(
          "cart".tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Text(''),
      ),

      bottomNavigationBar: GetBuilder(
        init: controller,
        builder: (context) {
          if(controller.currentCartState==CartState.itemFound){
          return _checkoutBar();
        }else{
            return Text("");
          }
        }
      ),

      body: GetBuilder(
          init: controller,
          builder: (context){
        switch (controller.currentCartState) {
          case CartState.loading:
            return Center(child: CircularProgressIndicator(),);
          case CartState.noItem:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/empty-cart.png",),
                Text("no_item_found".tr),
              ],
            );
          case CartState.itemFound:
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _addressSection(),
                  const SizedBox(height: 12),
                  _cartItems(),
                  const SizedBox(height: 16),
                  _couponSection(),
                  const SizedBox(height: 16),
                  _invoiceSection(),
                  const SizedBox(height: 16),
                  _paymentSection(),
                  const SizedBox(height: 120),
                ],
              ),
            );
          case CartState.error:
            // TODO: Handle this case.
            throw UnimplementedError();
        }

      }),
    );
  }

  // ================= ADDRESS =================

  Widget _addressSection() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: controller.addressLoading?[Text('address_loading'.tr)]:[
          ...controller.addressHistoryModel.data!.map((e) =>
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: InkWell(
                  onTap: (){
                    controller.selectedAddressId=e.addressId.toString();
                    controller.update();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: controller.selectedAddressId==e.addressId?Colors.red:Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.location_solid, size: 18, color:controller.selectedAddressId==e.addressId?Colors.white: Colors.indigo),
                        const SizedBox(width: 6),
                        Text("${e.holderName}, ${e.building},",
                            style: GoogleFonts.poppins(fontSize: 13,
                            color:controller.selectedAddressId==e.addressId?Colors.white:Colors.black,
                              fontWeight: controller.selectedAddressId==e.addressId?FontWeight.bold:FontWeight.normal

                            )),

                      ],
                    ),
                  ),
                ),
              )
          ).toList(),

          InkWell(
            onTap: ()=>Get.toNamed(AppRoutes.addressScreen),
            child: _addressChip(
              icon: CupertinoIcons.add,
              text: "Add Address",
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressChip({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }

  // ================= CART ITEMS =================

Widget _cartItems() {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: controller.cartModel.data!.length,
    itemBuilder: (context, index) {
      return _cartItemCard( controller.cartModel.data![index]);
    },
  );
}

  Widget _cartItemCard(CartData cartData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl:
            "${EndPoints.mediaUrl(cartData.productDetails!.productThumbnail.toString())}",
            height: 70,
            width: 70,
            fit: BoxFit.contain,
            placeholder: (_, __) =>
            const CupertinoActivityIndicator(),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${cartData.productDetails!.productTitle}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${cartData.productDetails!.productUnitTag}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${AppConstants.currencySymbol}${cartData.productDetails!.productPrice}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          _quantityStepper(cartData),
        ],
      ),
    );
  }

  Widget _quantityStepper(CartData cartData) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _qtyBtn(CupertinoIcons.minus, ()=>controller.decrementQty(cartData.cartId.toString())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              cartData.productQty.toString(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          _qtyBtn(CupertinoIcons.plus, ()=>controller.incrementQty(cartData.cartId)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon,  onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18),
      ),
    );
  }

  // ================= COUPON =================

  Widget _couponSection() {
    return GetBuilder<CartController>(
      builder: (_) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.couponApplied
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Coupon Applied (${controller.couponModel.data?[0].couponCode ?? ''})",
                                  style: GoogleFonts.poppins(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "-₹${controller.discount.toStringAsFixed(controller.discount % 1 == 0 ? 0 : 2)}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: controller.removeCoupon,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.red, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (controller.couponModel.data != null &&
                            controller.couponModel.data!.isNotEmpty &&
                            (controller.couponModel.data![0].couponInfo?.isNotEmpty ?? false)) ...[
                          const SizedBox(height: 6),
                          Text(
                            controller.couponModel.data![0].couponInfo!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.couponController,
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (_) {
                                if (controller.couponErrorMessage.isNotEmpty) {
                                  controller.couponErrorMessage = '';
                                  controller.update();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter coupon code (e.g. FIRST25)",
                                isDense: true,
                                errorText: controller.couponErrorMessage.isNotEmpty
                                    ? controller.couponErrorMessage
                                    : null,
                                errorMaxLines: 2,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor(AppConstants.primaryColor),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: controller.couponSearching
                                ? null
                                : () => controller.applyCoupon(),
                            child: controller.couponSearching
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    "Apply",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      if (controller.availableCoupons.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () => _showAvailableCouponsSheet(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: HexColor(AppConstants.primaryColor).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: HexColor(AppConstants.primaryColor).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.local_offer_outlined,
                                    size: 18,
                                    color: HexColor(AppConstants.primaryColor)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "View Available Coupons (${controller.availableCoupons.length} Offers)",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: HexColor(AppConstants.primaryColor),
                                    ),
                                  ),
                                ),
                                Icon(Icons.chevron_right,
                                    color: HexColor(AppConstants.primaryColor),
                                    size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _showAvailableCouponsSheet() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_offer,
                        color: HexColor(AppConstants.primaryColor), size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Available Coupons",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(height: 20),
            Expanded(
              child: GetBuilder<CartController>(
                builder: (_) {
                  if (controller.availableCoupons.isEmpty) {
                    return Center(
                      child: Text(
                        "No coupons available at the moment",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.availableCoupons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final coupon = controller.availableCoupons[index];
                      final isEligible = coupon.isEligible ?? true;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isEligible ? Colors.white : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isEligible
                                ? HexColor(AppConstants.primaryColor).withOpacity(0.5)
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            if (isEligible)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: HexColor(AppConstants.primaryColor)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: HexColor(AppConstants.primaryColor),
                                    ),
                                  ),
                                  child: Text(
                                    coupon.couponCode ?? '',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: HexColor(AppConstants.primaryColor),
                                    ),
                                  ),
                                ),
                                if (isEligible)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          HexColor(AppConstants.primaryColor),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                      controller.applyCoupon(coupon.couponCode);
                                    },
                                    child: Text(
                                      "APPLY",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "NOT APPLICABLE",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (coupon.couponInfo != null &&
                                coupon.couponInfo!.isNotEmpty)
                              Text(
                                coupon.couponInfo!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (coupon.minCap != null && coupon.minCap! > 0)
                                  Text(
                                    "Min order: ₹${coupon.minCap!.toStringAsFixed(coupon.minCap! % 1 == 0 ? 0 : 2)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                if (coupon.discountType == 'percentage' &&
                                    coupon.maxCap != null &&
                                    coupon.maxCap! > 0)
                                  Text(
                                    "• Max savings: ₹${coupon.maxCap!.toStringAsFixed(coupon.maxCap! % 1 == 0 ? 0 : 2)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                if (coupon.isFirstOrderOnly == true)
                                  Text(
                                    "• First order only",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            if (!isEligible &&
                                coupon.ineligibilityReason != null &&
                                coupon.ineligibilityReason!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 13, color: Colors.orange.shade800),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      coupon.ineligibilityReason!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.orange.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (isEligible &&
                                coupon.potentialDiscount != null &&
                                coupon.potentialDiscount! > 0) ...[
                              const SizedBox(height: 6),
                              Text(
                                "Apply to save ₹${coupon.potentialDiscount!.toStringAsFixed(coupon.potentialDiscount! % 1 == 0 ? 0 : 2)} on this order",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ================= INVOICE =================

  Widget _invoiceSection() {
    return GetBuilder<CartController>(
      init: controller,
      builder: (_) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Invoice",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const Divider(height: 24),
            _row("Subtotal", "₹${controller.subTotal}"),
            _row("Delivery Charge", "₹${controller.deliveryCharge}"),
            if (controller.discount > 0)
              _row(
                "Discount",
                "-₹${controller.discount.toStringAsFixed(controller.discount % 1 == 0 ? 0 : 2)}",
                green: true,
              ),
            const Divider(height: 24),
            _row(
              "Total Payable",
              "₹${controller.total.toStringAsFixed(controller.total % 1 == 0 ? 0 : 2)}",
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value,
      {bool bold = false, bool green = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: bold ? FontWeight.w600 : null)),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: green ? Colors.green : null,
              fontWeight: bold ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PAYMENT =================

  Widget _paymentSection() {
    return GetBuilder<CartController>(
      builder: (_) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("payment_method".tr,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            RadioListTile<PaymentType>(
              value: PaymentType.cod,
              enabled: controller.isCodAvailable,
              groupValue: controller.paymentType,
              onChanged: controller.selectPayment,
              title:  Text("cash_on_delivery".tr),
            ),

            RadioListTile<PaymentType>(
              value: PaymentType.online,
              groupValue: controller.paymentType,
              onChanged: controller.selectPayment,
            title:  Text("online_payment".tr),
            //  title:  Text("₹${controller.userCurrentBalance} "+ "wallet_balance".tr),
            ),

            // Visibility(
            //   visible: controller.userCurrentBalance<controller.total,
            //   child: TextButton(onPressed: ()=>null, child: Text('low_balance_recharge_now'.tr,style: GoogleFonts.poppins(
            //     fontWeight: FontWeight.bold,
            //     color: Colors.red
            //   ),)),
            // )

          ],

        ),
      ),
    );
  }

  // ================= CHECKOUT =================

  Widget _checkoutBar() {
    return GetBuilder<CartController>(
      builder: (_) => Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: controller.hasInsufficientBalanceForOnlinePayment
                  ? Colors.grey
                  : HexColor(AppConstants.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              controller.placeOrder();
              // if (controller.paymentType == PaymentType.online && controller.userCurrentBalance>=controller.total) {
              //   // 👉 Razorpay integration here
              // } else {
              //   // 👉 Place COD order
              //   controller.placeOrder();
              // }
            },
            child: Text(
              controller.paymentType==PaymentType.online
                  ? "Pay ₹${controller.total.toStringAsFixed(controller.total % 1 == 0 ? 0 : 2)}"
                  : "pay_on_delivery".tr,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= COMMON CARD =================

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: child,
    );
  }
}
