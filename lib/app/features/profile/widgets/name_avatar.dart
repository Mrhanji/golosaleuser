import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameAvatar extends StatelessWidget {

  final String firstName;
  final String lastName;
  final double radius;

  const NameAvatar({
    super.key,
    required this.firstName,
    required this.lastName,
    this.radius = 58,
  });

  static const Color primaryColor = Color(0xff4FC83F);

  @override
  Widget build(BuildContext context) {

    String first =
    firstName.isNotEmpty
        ? firstName[0].toUpperCase()
        : "";

    String last =
    lastName.isNotEmpty
        ? lastName[0].toUpperCase()
        : "";

    String initials = "$first$last";

    return Container(
      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        border: Border.all(
          color: Colors.white,
          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: CircleAvatar(

        radius: radius,

        backgroundColor: primaryColor,

        child: Container(

          decoration: BoxDecoration(

            shape: BoxShape.circle,

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                primaryColor,
                primaryColor.withOpacity(.75),
              ],
            ),
          ),

          alignment: Alignment.center,

          child: Text(
            initials,

            style: GoogleFonts.poppins(
              fontSize: radius * .52,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}