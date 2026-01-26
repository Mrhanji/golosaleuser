import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/city/views/city_selection_screen.dart';
import '../../profile/views/profile_screen.dart';
import '/app/features/cart/views/cart_screen.dart';
import '/app/features/refer/views/refer_screen.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import '../controller/home_controller.dart';
import 'home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final idx = controller.selectedIndex.value;
          final isCityEmpty=controller.defaultCityIsEmpty;

          Widget page= Container();
          switch (idx) {
            case 0:
              {
                page= homeView(controller: controller);
              }
            case 1:
              {
                page= ReferScreen(homeController:controller);
              }

            case 2:
              {
                page= CartScreen(homeController:controller);
              }

            case 3:
              {
                page= ProfileScreen(homeController:controller);
              }

            default:
              {
                page= Center(child: Text("No Page Found @ $idx"));
              }

          }
          return isCityEmpty.value?CitySelectionScreen():page;
        }),
      ),

      bottomNavigationBar: Obx(
        () => FlashyTabBar(
          selectedIndex: controller.selectedIndex.value,
          showElevation: true,
          onItemSelected: controller.setNavIndex,
          items: [
            FlashyTabBarItem(
              icon: const Icon(Icons.home),
              title: Text('home'.tr),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.people),
              title: Text('refer'.tr),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.shopping_cart_rounded),
              title: Text('cart'.tr),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.person),
              title: Text('profile'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
