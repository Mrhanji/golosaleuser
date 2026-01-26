import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import '/utils/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class ReferScreen extends StatelessWidget {

   final HomeController homeController;
   ReferScreen({super.key, required this.homeController});



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(
      child: Column(children: [
      
        SizedBox(height: Get.height*0.03,),
        Container(
          height: Get.height*0.3,
          width: Get.width,
          child: Image.asset(AppConstants.referImage),
        ),
      
      
      

        Padding(
          padding: const EdgeInsets.all(08.0),
          child: Builder(
            builder: (context) {
              return _buildSummaryCard(homeController: homeController);
            }
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("refer_code".tr,style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: Get.height*0.02)),
                    Text("tap_to_share".tr,style: GoogleFonts.poppins(color: Colors.grey,fontSize: Get.height*0.015),),
                  ],
                ),
                //SizedBox(width: Get.width*0.01,),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    dashPattern: [10, 3],
                    strokeWidth: 1,
                    radius: Radius.circular(8),
                    color: Colors.indigo,
                    padding: EdgeInsets.all(8),
                  ),
                  child: Container(
                    width: Get.width*0.45,
                    alignment: Alignment.center,
                    child: Text("${homeController.userModel.data?.refferalCode}",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: Get.height*0.02),),
                  ),

                ),
              ],
            ),
          ),
        ),


      
      





        _buildTile(
          icon: Icons.share_outlined,
          title: 'refer_how_title'.tr,
          desc: 'refer_how_desc'.tr,
        ),
        _buildTile(
          icon: Icons.card_giftcard_outlined,
          title: 'refer_reward_title'.tr,
          desc: 'refer_reward_desc'.tr,
        ),
        _buildTile(
          icon: Icons.account_circle_outlined,
          title: 'refer_eligibility_title'.tr,
          desc: 'refer_eligibility_desc'.tr,
        ),
        _buildTile(
          icon: Icons.warning_amber_rounded,
          title: 'refer_rules_title'.tr,
          desc: 'refer_rules_desc'.tr,
        ),
      ],),
    ));
  }
}



// 🔥 Summary Card
Widget _buildSummaryCard({required HomeController homeController}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
      ),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.indigo.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        _summaryItem(
          icon: Icons.group_outlined,
          title: 'refer_count_title'.tr,
          value: '0', // 🔁 replace with controller value
        ),
        _divider(),
        _summaryItem(
          icon: Icons.currency_rupee,
          title: 'refer_earning_title'.tr,
          value: '₹${homeController.userModel.data?.walletAmount}',
        ),
      ],
    ),
  );
}

Widget _summaryItem({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Expanded(
    child: Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    ),
  );
}

Widget _divider() {
  return Container(
    height: 40,
    width: 1,
    color: Colors.white.withOpacity(0.4),
  );
}

// 🔽 FAQ Tile

Widget _buildTile({
  required IconData icon,
  required String title,
  required String desc,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: Colors.indigo),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Text(
          desc,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
