import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/recharge_controller.dart';


class RechargeWalletScreen extends StatelessWidget {
  RechargeWalletScreen({super.key});

  final controller = Get.put(RechargeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recharge Wallet",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Wallet Balance Card
            Obx(() => walletBalanceCard(
              controller.walletBalance.value.toString(),
            )),

            const SizedBox(height: 20),

            // ✅ Enter Amount Title
            Text(
              "Enter Amount",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Amount Input
            TextField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                prefixText: "₹ ",
                hintText: "Min ₹100 - Max ₹5000",
                hintStyle: GoogleFonts.poppins(fontSize: 13),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Quick Select
            Text(
              "Quick Select",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Chips List
            Obx(() {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.quickAmounts.map((amount) {
                  final isSelected =
                      controller.selectedAmount.value == amount;

                  return GestureDetector(
                    onTap: () => controller.selectAmount(amount),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        "₹$amount",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.blue
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),

            const Spacer(),

            // ✅ Recharge Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.startPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Recharge Now",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// ✅ Wallet Balance Card Widget
//////////////////////////////////////////////////////////////

Widget walletBalanceCard(String balance) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wallet Balance",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "₹ $balance",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}