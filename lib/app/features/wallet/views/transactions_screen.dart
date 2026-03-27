import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("recent_transactions".tr),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _walletTransaction(
              title: "Order Payment",
              date: "Today",
              amount: "- ₹120",
              isDebit: true,
            ),
            _walletTransaction(
              title: "Wallet Topup",
              date: "Yesterday",
              amount: "+ ₹500",
              isDebit: false,
            ),
          ],
        ),
      ),
    );
  }
}


Widget _walletTransaction({
  required String title,
  required String date,
  required String amount,
  required bool isDebit,
}) {

  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor:
      isDebit ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
      child: Icon(
        isDebit ? Icons.call_made : Icons.call_received,
        color: isDebit ? Colors.red : Colors.green,
      ),
    ),
    title: Text(title, style: GoogleFonts.poppins()),
    subtitle: Text(date),

    trailing: Text(
      amount,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: isDebit ? Colors.red : Colors.green,
      ),
    ),
  );
}
