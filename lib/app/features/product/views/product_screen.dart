import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import 'package:golosaleuser/utils/end_points.dart';
import '../controller/product_controller.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:golosaleuser/app/features/home/widgets/shimmer_skeleton.dart';

/// ================= SCREEN =================

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());

  final List<int> subscriptionPlans = [7, 15, 30, 90, 180, 365];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: GetBuilder(
        init: controller,
        builder: (context) {
          if (controller.isProductLoading.value == true) {
            return _shimmerLoading();
          } else {
            return CustomScrollView(
              slivers: [
                _sliverAppBar(),
                SliverToBoxAdapter(child: _content()),
              ],
            );
          }
        },
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
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.3),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: EndPoints.mediaUrl(
            controller.productsModel.data!.first.productThumbnail.toString(),
          ),
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              const Center(child: CupertinoActivityIndicator()),
          errorWidget: (_, __, ___) => const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 48,
          ),
        ),
      ),
    );
  }

  /// ================= MAIN CONTENT =================

  Widget _content() {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _productInfo(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _quantityCard(),
          ),
          controller.productsModel.data!.first.hasSubscriptionModel == 1
              ? const SizedBox(height: 16)
              : const SizedBox.shrink(),
          controller.productsModel.data!.first.hasSubscriptionModel == 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _purchaseTypeCard(),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  /// ================= PRODUCT INFO =================

  Widget _productInfo() {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "${controller.productsModel.data!.first.productTitle}",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${controller.productsModel.data!.first.productUnitTag}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Product Description",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${controller.productsModel.data!.first.productInfo}",
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ],
      ),
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
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                _qtyBtn(Icons.remove, controller.decrement),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    controller.quantity.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
    final primaryColor = HexColor(AppConstants.primaryColor);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 18, color: primaryColor),
      ),
    );
  }

  /// ================= PURCHASE TYPE =================

  Widget _purchaseTypeCard() {
    final primaryColor = HexColor(AppConstants.primaryColor);

    return GetBuilder<ProductController>(
      builder: (controller) => _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "purchase_type".tr,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),

            /// ---- One-time / Subscription toggle chips ----
            Row(
              children: [
                _chip(
                  "one_time".tr,
                  !controller.isSubscription,
                  () => controller.toggleSubscription(false),
                  primaryColor,
                ),
                const SizedBox(width: 12),
                _chip(
                  "subscription".tr,
                  controller.isSubscription,
                  () => controller.toggleSubscription(true),
                  primaryColor,
                ),
              ],
            ),

            /// ---- Subscription options ----
            if (controller.isSubscription) ...[
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade100, height: 1),
              const SizedBox(height: 14),

              /// ---- Slot selection ----
              _slotSection(controller),
              const SizedBox(height: 10),
              Text(
                "* Choose your preferred morning or evening delivery slot.",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Divider(color: Colors.grey.shade100, height: 1),
              const SizedBox(height: 14),

              /// Plan chips
              Text(
                "Select Plan",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    (controller.productsModel.data!.first.slotPlans!
                            .where(
                              (d) =>
                                  d.slotType.toString() ==
                                  controller.selectedSlot.toString(),
                            )
                            .toList()
                          ..sort(
                            (a, b) => (a.durationDays ?? 0).compareTo(
                              b.durationDays ?? 0,
                            ),
                          ))
                        .map((plan) {
                          final isSelected =
                              controller.selectedPlan == plan.durationDays;
                          return ChoiceChip(
                            label: Text(
                              "${plan.durationDays} ${"days".tr}",
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) =>
                                controller.selectPlan(plan.durationDays!),
                            selectedColor: primaryColor,
                            backgroundColor: Colors.grey.shade50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          );
                        })
                        .toList(),
              ),

              const SizedBox(height: 10),

              Text(
                "* Plan starts from Day 1 after scheduling.",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 14),
              Divider(color: Colors.grey.shade100, height: 1),
              const SizedBox(height: 14),

              /// ---- Total ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "total_amount".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "₹${controller.total}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// ---- Subscription days ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "subscription_days".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${controller.subscriptionDays} ${"days".tr}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  /// ================= SLOT SECTION =================

  Widget _slotSection(ProductController controller) {
    final product = controller.productsModel.data!.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "choose_slot".tr,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _slotButton(
                controller: controller,
                icon: Icons.wb_sunny_outlined,
                label: "Morning",
                time: "06:00 – 08:00",
                slotKey: "morning",
                isAvailable: product.availableInMorningSlot == true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _slotButton(
                controller: controller,
                icon: Icons.nights_stay_outlined,
                label: "Evening",
                time: "18:00 – 20:00",
                slotKey: "evening",
                isAvailable: product.availableInEveningSlot == true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ================= SLOT BUTTON =================

  Widget _slotButton({
    required ProductController controller,
    required IconData icon,
    required String label,
    required String time,
    required String slotKey,
    required bool isAvailable,
  }) {
    final primaryColor = HexColor(AppConstants.primaryColor);
    final bool selected = controller.selectedSlot == slotKey;
    final darkGreen = Color.lerp(primaryColor, Colors.black, 0.2)!;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isAvailable ? 1 : .55,
      child: InkWell(
        onTap: isAvailable
            ? () {
                controller.selectSlot(slotKey);
              }
            : null,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: !isAvailable
                ? Colors.grey.shade50
                : selected
                ? primaryColor.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1.5,
              color: !isAvailable
                  ? Colors.grey.shade200
                  : selected
                  ? primaryColor
                  : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: !isAvailable
                          ? Colors.grey.shade200
                          : selected
                          ? primaryColor.withValues(alpha: 0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: !isAvailable
                          ? Colors.grey
                          : selected
                          ? darkGreen
                          : Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  if (selected && isAvailable)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: !isAvailable
                      ? Colors.grey
                      : selected
                      ? darkGreen
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: !isAvailable
                      ? Colors.grey
                      : selected
                      ? primaryColor
                      : Colors.grey.shade500,
                ),
              ),
              if (!isAvailable) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "slot_not_available".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 8.5,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// ================= CHIP =================

  Widget _chip(
    String text,
    bool selected,
    VoidCallback onTap,
    Color primaryColor,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primaryColor : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.grey.shade700,
              fontWeight: selected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= BOTTOM BAR =================

  Widget _bottomBar() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        final primaryColor = HexColor(AppConstants.primaryColor);
        double total = 0;
        if (controller.isProductLoading.value == false) {
          total =
              double.parse(
                controller.productsModel.data!.first.productPrice.toString(),
              ) *
              controller.quantity;
        }
        final isAdded = controller.isAddedIntoCart;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
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
                    "total".tr,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "₹${controller.isSubscription ? controller.total : total}",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.isSubscription) {
                    controller.navigateToSubscribe();
                  } else {
                    if (!controller.isAddedIntoCart) {
                      controller.addToCart();
                    } else {
                      Get.put(HomeController()).selectedIndex.value = 2;
                      Get.back();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: controller.isSubscription
                      ? primaryColor
                      : isAdded
                      ? Colors.amber.shade700
                      : primaryColor,
                ),
                child: Text(
                  controller.isSubscription
                      ? "subscribe".tr
                      : isAdded
                      ? "added".tr
                      : "add_to_cart".tr,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: child,
    );
  }

  /// ================= SHIMMER LOADING =================

  Widget _shimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image Shimmer
          ShimmerSkeleton(
            width: Get.width,
            height: 320,
            borderRadius: BorderRadius.zero,
          ),
          // Overlapping details card shimmer
          Transform.translate(
            offset: const Offset(0, -28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card Shimmer
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerSkeleton(
                            width: Get.width * 0.5,
                            height: 24,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          ShimmerSkeleton(
                            width: 70,
                            height: 24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ShimmerSkeleton(
                        width: 140,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12),
                      ShimmerSkeleton(
                        width: double.infinity,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      ShimmerSkeleton(
                        width: double.infinity,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      ShimmerSkeleton(
                        width: Get.width * 0.4,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Quantity Card Shimmer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ShimmerSkeleton(
                    width: double.infinity,
                    height: 72,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 16),
                // Purchase Type Card Shimmer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ShimmerSkeleton(
                    width: double.infinity,
                    height: 160,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
