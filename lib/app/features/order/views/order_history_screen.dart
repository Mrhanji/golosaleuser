import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/order_controller.dart';
import '../model/order_history_model.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
   OrderHistoryScreen({super.key});
  OrderHistoryController controller=Get.put(OrderHistoryController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: Text(
          "order_history".tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: GetBuilder(
        init: controller,
        builder: (context) {
          if(controller.currentOrderHistoryState==OrderHistoryState.loading) {
            return Center(child: CircularProgressIndicator());
          }else if(controller.currentOrderHistoryState==OrderHistoryState.noItem){
            return Center(child: Text("no_item_found".tr));
          }else

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.orderHistoryModel.data!.orders!.length,
            itemBuilder: (_, index) {
              Orders order = controller.orderHistoryModel.data!.orders![index];
              return _orderCard(order);
            },
          );
        }
      ),
    );
  }

  Widget _orderCard(Orders order) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.orderDetailsScreen,arguments: order);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #ODR-${order.orderNumber}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "₹${order.grandTotal}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Date
            Text(
              "${order.createdOn}",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            // Items preview
            Text(
              "Total Items - ${order.totalItems}",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
