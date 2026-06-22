import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '/app/features/city/views/city_selection_screen.dart';
import '../../profile/views/profile_screen.dart';
import '/app/features/cart/views/cart_screen.dart';
import '/app/features/refer/views/refer_screen.dart';
import '/utils/app_constants.dart';
import '../controller/home_controller.dart';
import 'home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final Color primaryColor = HexColor(AppConstants.primaryColor);

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final idx = controller.selectedIndex.value;
          final isCityEmpty = controller.defaultCityIsEmpty;

          if (isCityEmpty.value) {
            return CitySelectionScreen();
          }

          Widget page = Container();
          switch (idx) {
            case 0:
              page = homeView(controller: controller);
              break;
            case 1:
              page = ReferScreen(homeController: controller);
              break;
            case 2:
              page = CartScreen(homeController: controller);
              break;
            case 3:
              page = ProfileScreen(homeController: controller);
              break;
            default:
              page = Center(child: Text("No Page Found @ $idx"));
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(idx),
              child: page,
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        final selectedIdx = controller.selectedIndex.value;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: CupertinoIcons.house,
                    activeIcon: CupertinoIcons.house_fill,
                    label: 'home'.tr,
                    isSelected: selectedIdx == 0,
                    onTap: controller.setNavIndex,
                    primaryColor: primaryColor,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: CupertinoIcons.person_2,
                    activeIcon: CupertinoIcons.person_2_fill,
                    label: 'refer'.tr,
                    isSelected: selectedIdx == 1,
                    onTap: controller.setNavIndex,
                    primaryColor: primaryColor,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: CupertinoIcons.shopping_cart,
                    activeIcon: CupertinoIcons.cart_fill,
                    label: 'cart'.tr,
                    isSelected: selectedIdx == 2,
                    onTap: controller.setNavIndex,
                    primaryColor: primaryColor,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: CupertinoIcons.person,
                    activeIcon: CupertinoIcons.person_fill,
                    label: 'profile'.tr,
                    isSelected: selectedIdx == 3,
                    onTap: controller.setNavIndex,
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required Function(int) onTap,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? primaryColor : Colors.grey.shade600,
                size: 20,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

