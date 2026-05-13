import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/routes/app_routes.dart';
import 'package:golosaleuser/utils/utils_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/end_points.dart';
import '../controller/subscribe_checkout_controller.dart';




/// ================= SCREEN =================
class SubscribeCartScreen extends StatelessWidget {
  SubscribeCartScreen({super.key});

  final controller = Get.put(SubscribeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("checkout".tr,
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _addressCard(),
            _productCard(),
            _dateSection(),
            _billCard(), // ✅ now exists
            _paymentSection(),
            _infoSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: _bottomBar(),
    );
  }

  /// ================= ADDRESS =================
  Widget _addressCard() {
    return Obx(() {
      if(controller.addressLoading==true){
        return const Center(child: CupertinoActivityIndicator());
      }else{
        if(controller.addressHistoryModel.data!.isEmpty){
          /// No Address Found add new address button also show here
          return Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("no_address_found".tr,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600)),
                      Text("add_new_address".tr),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _showAddressSheet,
                  child: Text("add".tr),
                )
              ],
            ),
          );

        }
      final data = controller.addressHistoryModel.data![controller.selectedAddress];

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.green),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.holderName.toString(),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600)),
                  Text(data.building!),
                ],
              ),
            ),

            TextButton(
              onPressed: _showAddressSheet,
              child: Text("change".tr),
            )
          ],
        ),
      );
      }
    });
  }

  void _showAddressSheet() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("select_address".tr,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600)),

            const SizedBox(height: 10),

            ...List.generate(controller.addressHistoryModel.data!.length, (index) {
              final data = controller.addressHistoryModel.data![index];

              return GetBuilder(
                init: controller,
                      builder: (c) => ListTile(
                leading: Icon(
                  controller.selectedAddress == index
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: Colors.green,
                ),
                title: Text(data.holderName!),
                subtitle: Text(data.building!),
                onTap: () {
                  controller.selectedAddress = index;
                  Get.back();
                },
              ));
            }),
            
            /// Add Address Button
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: ()=>Get.toNamed(AppRoutes.addressScreen),
              child: Text("add_new_address".tr),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PRODUCT =================
  Widget _productCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            color: Colors.grey.shade300,
            child: Obx((){
              if(controller.thumbnailLoading.value==true){
                return const Center(child: CupertinoActivityIndicator());
              }else
              return CachedNetworkImage(
                imageUrl: EndPoints.mediaUrl(controller.planDetails.productThumbnail.toString()),
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                const Center(child: CupertinoActivityIndicator()),
                errorWidget: (_, __, ___) {
                  print("error ${controller.planDetails.productThumbnail}");
                  return const Icon(Icons.error);
                },
              );
            }



            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${controller.planDetails.productTitle} (${controller.planDetails.productQty})",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
                Text("${controller.planDetails.productUnitTag}")
              ],
            ),
          ),
           Text("₹${controller.planDetails.productPrice}"),
        ],
      ),
    );
  }

  /// ================= DATE =================
  Widget _dateSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("subscription_duration".tr,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                  child: _dateBox(
                      "start_date".tr, UtilsFunctions().formatDate(controller.planDetails.startDate!))),
              const SizedBox(width: 10),
              Expanded(
                  child: _dateBox(
                      "end_date".tr, UtilsFunctions().formatDate(controller.planDetails.endDate!))),
            ],
          )
        ],
      ),
    );
  }

  Widget _dateBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// ================= BILL =================
  Widget _billCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [

           _row("subscription_days".tr, "${controller.planDetails.subscriptionDays}"),
          _row("quantity".tr, "${controller.planDetails.productQty}"),
          _row("subtotal".tr, "₹${controller.planDetails.total}"),
          const Divider(),
          _row("total".tr, "₹${controller.planDetails.total}", bold: true),
        ],
      ),
    );
  }

  Widget _row(String t, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(t,
              style: GoogleFonts.poppins(
                  fontWeight:
                  bold ? FontWeight.w600 : FontWeight.normal)),
          const Spacer(),
          Text(v,
              style: GoogleFonts.poppins(
                  fontWeight:
                  bold ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  /// ================= PAYMENT =================
  Widget _paymentSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: GetBuilder(
        init: controller,
              builder: (d) {
        final isEnabled = controller.isWalletEnabled;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("payment_method".tr,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600)),

            const SizedBox(height: 10),

            // RadioListTile<int>(
            //   value: 0,
            //   groupValue: controller.selectedPayment,
            //   onChanged: isEnabled
            //       ? (val) =>
            //   controller.changePaymentMethod(val!): null,
            //   title: Text(
            //       "${"wallet".tr} (₹${controller.walletBalance})"),
            // ),
            //
            // if (!isEnabled)
            //   Padding(
            //     padding: const EdgeInsets.only(left: 16),
            //     child: Text(
            //       "insufficient_balance".tr,
            //       style: const TextStyle(
            //           color: Colors.red, fontSize: 12),
            //     ),
            //   ),

            RadioListTile<int>(
              value: 1,
              groupValue: controller.selectedPayment,
              onChanged: (val) =>
              controller.changePaymentMethod(val!),
              title: Text("online_payment".tr),
            ),
          ],
        );
      }),
    );
  }

  /// ================= INFO =================
  Widget _infoSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: Colors.green),
          ),

          title: Text(
            "subscription_info".tr,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14),
          ),

          children: [

            /// DELIVERY
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_shipping, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("info_delivery".tr,
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// PAUSE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.pause_circle_outline, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("info_pause".tr,
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// CANCEL
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.cancel_outlined, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("info_cancel".tr,
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// REFUND
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("info_refund".tr,
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// DELIVERY RULE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("info_timing".tr,
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// SUPPORT
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.support_agent, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("info_support".tr,
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// NOTE
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "info_note".tr,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  /// ================= BOTTOM =================
  Widget _bottomBar() {
    return GetBuilder(
      init: controller,
      builder: (context) {
        return Container(
          height: Get.height * 0.12,
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: SafeArea(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.selectedPayment==0?[
                    Text("per_day".tr),
                     Text("₹${controller.perDayBill}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ]:[
                    Text("total".tr),
                     Text("₹${controller.planDetails.total}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    controller.subScribe();
                  },
                  child: Text("continue".tr),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}