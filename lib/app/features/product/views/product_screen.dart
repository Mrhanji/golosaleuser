import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import 'package:golosaleuser/utils/end_points.dart';
import '../../../routes/app_routes.dart';
import '../controller/product_controller.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hexcolor/hexcolor.dart';
import '/app/features/cart/controller/cart_controller.dart';


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
            return const Center(child: CircularProgressIndicator());
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
      iconTheme: const IconThemeData(color: Colors.black),
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: EndPoints.mediaUrl(
              controller.productsModel.data!.first.productThumbnail.toString()),
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
          const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Icon(Icons.error),
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
          controller.productsModel.data!.first.hasSubscriptionModel == 1
              ? const SizedBox(height: 16)
              : const SizedBox.shrink(),
          controller.productsModel.data!.first.hasSubscriptionModel == 1
              ? _purchaseTypeCard()
              : const SizedBox.shrink(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  /// ================= PRODUCT INFO =================

  Widget _productInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${controller.productsModel.data!.first.productTitle}",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${controller.productsModel.data!.first.productUnitTag}",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${controller.productsModel.data!.first.productInfo}",
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

            /// ---- One-time / Subscription toggle chips ----
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

            /// ---- Subscription options ----
            if (controller.isSubscription) ...[
              const SizedBox(height: 14),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 5),
              /// ---- Slot selection ----
              _slotSection(controller),
              const SizedBox(height: 8),
              Text(
                "* Choose your preferred morning or evening delivery slot.",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 5),
              /// Plan chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subscriptionPlans.map((plan) {
                  return ChoiceChip(
                    label: Text("$plan ${"days".tr}"),
                    selected: controller.selectedPlan == plan,
                    onSelected: (_) => controller.selectPlan(plan),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              Text(
                "* Plan starts from Day 1 after scheduling.",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 14),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 10),

              /// ---- Total ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "total_amount".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    "₹${controller.total}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    "${controller.subscriptionDays} ${"days".tr}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 12),


            ],
          ],
        ),
      ),
    );
  }

  /// ================= SLOT SECTION =================

  /// ================= SLOT SECTION =================

  Widget _slotSection(
      ProductController controller,
      ) {

    final product =
        controller.productsModel.data!.first;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(
          "choose_slot".tr,

          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          runSpacing: 10,

          children: [

            _slotButton(

              controller: controller,

              icon:
              Icons.wb_sunny_outlined,

              label: "Morning",

              time: "06:00 – 08:00",

              slotKey: "morning",

              isAvailable:
              product.availableInMorningSlot ==
                  true,
            ),

            _slotButton(

              controller: controller,

              icon:
              Icons.nights_stay_outlined,

              label: "Evening",

              time: "18:00 – 20:00",

              slotKey: "evening",

              isAvailable:
              product.availableInEveningSlot ==
                  true,
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

    final bool selected =
        controller.selectedSlot == slotKey;

    return AnimatedOpacity(

      duration:
      const Duration(milliseconds: 250),

      opacity: isAvailable ? 1 : .55,

      child: InkWell(

        onTap: isAvailable
            ? () {
          controller.selectSlot(slotKey);
        }
            : null,

        borderRadius:
        BorderRadius.circular(14),

        child: AnimatedContainer(

          duration:
          const Duration(milliseconds: 250),

          width: 145,

          padding:
          const EdgeInsets.all(11),

          decoration: BoxDecoration(

            color: !isAvailable

                ? Colors.grey.shade100

                : selected

                ? const Color(
                0xFFE8F8F1)

                : Colors.white,

            borderRadius:
            BorderRadius.circular(14),

            border: Border.all(

              width: 1,

              color: !isAvailable

                  ? Colors.grey.shade300

                  : selected

                  ? const Color(
                  0xFF22A06B)

                  : Colors.grey.shade300,
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  Container(

                    padding:
                    const EdgeInsets.all(
                        6),

                    decoration:
                    BoxDecoration(

                      color: !isAvailable

                          ? Colors.grey
                          .shade200

                          : selected

                          ? const Color(
                          0xFF22A06B)
                          .withOpacity(
                          .12)

                          : Colors.grey
                          .shade100,

                      borderRadius:
                      BorderRadius
                          .circular(
                          10),
                    ),

                    child: Icon(

                      icon,

                      size: 15,

                      color: !isAvailable

                          ? Colors.grey

                          : selected

                          ? const Color(
                          0xFF0F6E56)

                          : Colors.grey
                          .shade600,
                    ),
                  ),

                  const Spacer(),

                  if (selected &&
                      isAvailable)

                    Container(

                      padding:
                      const EdgeInsets
                          .all(3),

                      decoration:
                      const BoxDecoration(

                        color: Color(
                            0xFF22A06B),

                        shape:
                        BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.check,
                        color:
                        Colors.white,
                        size: 10,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              Text(

                label,

                style:
                GoogleFonts.poppins(

                  fontSize: 12.5,

                  fontWeight:
                  FontWeight.w600,

                  color: !isAvailable

                      ? Colors.grey

                      : selected

                      ? const Color(
                      0xFF0F6E56)

                      : Colors.black87,
                ),
              ),

              const SizedBox(height: 2),

              Text(

                time,

                style:
                GoogleFonts.poppins(

                  fontSize: 10,

                  color: !isAvailable

                      ? Colors.grey

                      : selected

                      ? const Color(
                      0xFF22A06B)

                      : Colors.grey
                      .shade600,
                ),
              ),

              if (!isAvailable) ...[

                const SizedBox(height: 8),

                Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(

                    color:
                    Colors.red.withOpacity(
                        .08),

                    borderRadius:
                    BorderRadius.circular(
                        40),
                  ),

                  child: Text(

                    "slot_not_available"
                        .tr,

                    style:
                    GoogleFonts.poppins(

                      fontSize: 9,

                      color: Colors.red,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
  /// ================= CHIP =================

  Widget _chip(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
          selected ? HexColor(AppConstants.primaryColor) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: HexColor(AppConstants.primaryColor)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: selected
                ? Colors.white
                : HexColor(AppConstants.primaryColor),
          ),
        ),
      ),
    );
  }

  /// ================= BOTTOM BAR =================

  Widget _bottomBar() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        double total = 0;
        if (controller.isProductLoading.value == false) {
          total = double.parse(
              controller.productsModel.data!.first.productPrice.toString()) *
              controller.quantity;
        }
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
                    "total".tr,
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  Text(
                    "₹${controller.isSubscription ? controller.total : total}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: controller.isAddedIntoCart
                      ? Colors.amber
                      : Colors.blue.shade50,
                ),
                child: Text(
                  controller.isSubscription
                      ? "subscribe".tr
                      : controller.isAddedIntoCart
                      ? "added".tr
                      : "add_to_cart".tr,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: controller.isAddedIntoCart
                        ? Colors.white
                        : Colors.black,
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