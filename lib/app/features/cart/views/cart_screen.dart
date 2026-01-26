import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum PaymentType { cod, online }

class CartController extends GetxController {
  int quantity = 2;

  double subTotal = 23;
  double deliveryCharge = 45;
  double discount = 0;

  bool couponApplied = false;
  PaymentType paymentType = PaymentType.cod;

  void incrementQty() {
    quantity++;
    update();
  }

  void decrementQty() {
    if (quantity > 1) quantity--;
    update();
  }

  void applyCoupon() {
    discount = 10;
    couponApplied = true;
    update();
  }

  void selectPayment(PaymentType? type) {
    if (type == null) return;
    paymentType = type;
    update();
  }

  double get total =>
      subTotal + deliveryCharge - discount;
}

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

      bottomNavigationBar: _checkoutBar(),

      body: SingleChildScrollView(
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
      ),
    );
  }

  // ================= ADDRESS =================

  Widget _addressSection() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _addressChip(
            icon: CupertinoIcons.location_solid,
            text: "Home • 123 Main Road, Delhi",
          ),
          _addressChip(
            icon: CupertinoIcons.add,
            text: "Add Address",
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
    return GetBuilder<CartController>(
      builder: (_) => Column(
        children: List.generate(2, (_) => _cartItemCard()),
      ),
    );
  }

  Widget _cartItemCard() {
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
            "https://milma.com/storage/products//April2023//OcDXueDoR1F5XgXwaUkT.png",
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
                  "Fresh Cow Milk",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "1 Litre",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${AppConstants.currencySymbol}58",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          _quantityStepper(),
        ],
      ),
    );
  }

  Widget _quantityStepper() {
    return GetBuilder<CartController>(
      builder: (_) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            _qtyBtn(CupertinoIcons.minus, controller.decrementQty),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                controller.quantity.toString(),
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            _qtyBtn(CupertinoIcons.plus, controller.incrementQty),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
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
        child: controller.couponApplied
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Coupon Applied (SAVE10)",
              style: GoogleFonts.poppins(color: Colors.green),
            ),
            Text(
              "-₹${controller.discount}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter coupon code",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: controller.applyCoupon,
              child: const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INVOICE =================

  Widget _invoiceSection() {
    return GetBuilder<CartController>(
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
              _row("Discount", "-₹${controller.discount}", green: true),
            const Divider(height: 24),
            _row(
              "Total Payable",
              "₹${controller.total}",
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
              groupValue: controller.paymentType,
              onChanged: controller.selectPayment,
              title:  Text("cash_on_delivery".tr),
            ),

            RadioListTile<PaymentType>(
              value: PaymentType.online,
              groupValue: controller.paymentType,
              onChanged: controller.selectPayment,
              title:  Text("online_payment".tr),
            ),
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
              backgroundColor: HexColor(AppConstants.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              if (controller.paymentType == PaymentType.online) {
                // 👉 Razorpay integration here
              } else {
                // 👉 Place COD order
              }
            },
            child: Text(
              "Pay ₹${controller.total}",
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
