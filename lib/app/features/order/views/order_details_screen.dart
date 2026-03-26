import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/order/model/order_history_model.dart';
import 'package:golosaleuser/utils/end_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Orders orderDetails=Get.arguments;
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: Text(
          "order_details".tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: null, // disabled for now
            icon: const Icon(Icons.download),
            tooltip: "download_invoice".tr,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderHeader(orderDetails),
            const SizedBox(height: 12),
            _itemsList(orderDetails),
            const SizedBox(height: 16),
            _billSection(orderDetails),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _orderHeader(Orders orderDetails) {
    return Container(
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
          Text(
            "Order #ODR-${orderDetails.orderNumber}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${orderDetails.orderStatus}",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ITEMS =================

  Widget _itemsList(Orders orderDetails) {
    return Column(
      children:[
        ...orderDetails.orderItems!.map((e) => _itemTile(e)).toList(),
      ]);
  }

  Widget _itemTile(OrderItems item) {
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
            EndPoints.mediaUrl(item.product!.productThumbnail.toString()),
            height: 60,
            width: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.product!.productTitle}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${item.product!.productUnitTag} x ${item.qty}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "₹${item.product!.productPrice}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= BILL =================

  Widget _billSection(Orders orderDetails) {
    return Container(
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
          Text(
            "bill_summary".tr,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Divider(height: 24),
          _billRow("Item Total", "₹${orderDetails.subTotal}"),
          _billRow("Delivery Charge", "₹${orderDetails.deliveryFee}"),
          _billRow("Discount", "-₹${orderDetails.couponPercent}", green: true),
          const Divider(height: 24),
          _billRow(
            "Total Paid",
            "₹${orderDetails.grandTotal}",
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _billRow(String title, String value,
      {bool bold = false, bool green = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: bold ? FontWeight.w600 : null,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: bold ? FontWeight.w600 : null,
              color: green ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
