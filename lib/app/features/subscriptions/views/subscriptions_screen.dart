import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';


class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("subscriptions".tr),
      ),
      body: Column(
        children: [
        Expanded(
          // height: Get.height*0.45,
          // width: Get.width,

          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),

          ),
        ),

          /// List of Subscriptions show here


          Expanded(child:ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return ListTile(
                title: Text("Subscription Name $index"),
              );
            },
          ))

        ],
      ),
    );
  }
}
