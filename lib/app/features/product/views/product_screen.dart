import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';


/// ================= CONTROLLER =================

class ProductController extends GetxController {
  int quantity = 1;
  bool isSubscription = false;
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
}

/// ================= SCREEN =================

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());

  final List<String> images = [
    "https://images.unsplash.com/photo-1608198093002-ad4e005484ec",
    "https://images.unsplash.com/photo-1608198093002-ad4e005484ec",
  ];

  final List<String> subscriptionPlans = [
    "3 Days",
    "7 Days",
    "15 Days",
    "1 Month",
  ];

  final double price = 58;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(),
          SliverToBoxAdapter(child: _content()),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// ================= SLIVER APP BAR =================

  Widget _sliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      flexibleSpace: FlexibleSpaceBar(
        background: CarouselSlider(
          items: images.map((img) {
            return CachedNetworkImage(
              imageUrl: img,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            );
          }).toList(),
          options: CarouselOptions(
            height: 320,
            viewportFraction: 1,
          ),
        ),
      ),
    );
  }

  /// ================= MAIN CONTENT =================

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productInfo(),
          const SizedBox(height: 16),
          _quantityCard(),
          const SizedBox(height: 16),
          _purchaseTypeCard(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _productInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fresh Cow Milk",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "₹$price / 1 Litre",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Pure, farm-fresh cow milk sourced daily from trusted local dairies. Hygienically processed and quality-checked to retain its natural taste and nutrients. Buy instantly when needed or subscribe for hassle-free daily doorstep delivery—fresh, reliable, and perfect for your family’s everyday needs.",
          style: GoogleFonts.poppins(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  /// ================= QUANTITY =================

  Widget _quantityCard() {
    return _card(
      child: GetBuilder<ProductController>(
        builder: (controller) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quantity",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                _qtyBtn(Icons.remove, controller.decrement),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    controller.quantity.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _qtyBtn(Icons.add, controller.increment),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon),
      ),
    );
  }

  /// ================= PURCHASE TYPE =================

  Widget _purchaseTypeCard() {
    return GetBuilder<ProductController>(
      builder: (controller) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "purchase_type".tr,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _chip(
                  "one_time".tr,
                  !controller.isSubscription,
                      () => controller.toggleSubscription(false),
                ),
                const SizedBox(width: 10),
                _chip(
                  "subscription".tr,
                  controller.isSubscription,
                      () => controller.toggleSubscription(true),
                ),
              ],
            ),
            if (controller.isSubscription) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: subscriptionPlans.map((plan) {
                  return ChoiceChip(
                    label: Text(plan),
                    selected: controller.selectedPlan == plan,
                    onSelected: (_) => controller.selectPlan(plan),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? HexColor(AppConstants.primaryColor) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: HexColor(AppConstants.primaryColor)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : HexColor(AppConstants.primaryColor),
          ),
        ),
      ),
    );
  }

  /// ================= BOTTOM BAR =================

  Widget _bottomBar() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        final total = price * controller.quantity;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  Text(
                    "₹$total",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Add to cart / Subscribe logic
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  controller.isSubscription
                      ? "Subscribe"
                      : "Add to Cart",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= COMMON CARD =================

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
