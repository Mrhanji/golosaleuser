import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/transactions_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/wallet_transaction_model.dart';


class TransactionsScreen extends StatelessWidget {
  TransactionsScreen({super.key});

  final controller = Get.put(TransactionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("recent_transactions".tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          // ✅ Initial Loading
          if (controller.isInitialLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ✅ Empty State
          if (controller.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Transactions Yet",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your wallet activity will appear here",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // ✅ List with pagination
          return ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.transactions.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // bottom loader
              if (index == controller.transactions.length) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final txn = controller.transactions[index];
              final isDebit = txn.transType == "debit";

              return walletTransactionItem(
                txn
              );
            },
          );
        }),
      ),
    );
  }
}





Widget walletTransactionItem(Transactions txn) {
  final type = txn.transType?.toLowerCase() ?? "";

  // ✅ Decide type
  final isDebit = type == "debit";
  final isCredit = type == "credit";
  final isRefund = type == "refund";

  // ✅ Icon + Color
  IconData icon;
  Color color;

  if (isDebit) {
    icon = Icons.arrow_upward;
    color = Colors.red;
  } else if (isRefund) {
    icon = Icons.refresh;
    color = Colors.orange;
  } else {
    icon = Icons.arrow_downward;
    color = Colors.green;
  }

  // ✅ Format Date
  String formattedDate = "";
  try {
    final dateTime = DateTime.parse(txn.createdOn ?? "");
    formattedDate = DateFormat("dd-MM-yyyy HH:mm",).format(dateTime,);
  } catch (_) {}

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: Row(
      children: [
        // ✅ Icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),

        const SizedBox(width: 12),

        // ✅ Middle Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txn.message ?? "Transaction",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "closing_balance".tr +": ₹${txn.lastAmount ?? 0}",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),

        // ✅ Amount
        Text(
          "${isDebit ? '-' : '+'} ₹${txn.amount ?? 0}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    ),
  );
}