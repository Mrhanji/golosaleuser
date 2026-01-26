
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/home/controller/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final HomeController homeController = Get.put(HomeController());

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController lastNameController;
  late final TextEditingController referController;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    final data = homeController.userModel.data;
    nameController = TextEditingController(text: data?.firstName ?? '');
    lastNameController= TextEditingController(text: data?.lastName ?? '');
    emailController = TextEditingController(text: data?.userEmail ?? '');
    phoneController = TextEditingController(text: data?.userMobile ?? '');
    referController=TextEditingController(text: data?.parentUserReferralCode??'');

    selectedGender = data?.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    lastNameController.dispose();
    referController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4A6CF7), Color(0xff6E8CFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "edit_profile".tr,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GetBuilder(
        init: homeController,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _profileHeader(),
                const SizedBox(height: 16),
                _formCard(),
                const SizedBox(height: 24),
                _saveButton(),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ---------------- PROFILE HEADER ----------------
  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4A6CF7), Color(0xff6E8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: CachedNetworkImageProvider(
                    homeController.userModel.data?.profilePicture != null &&
                        homeController.userModel.data!.profilePicture!
                            .isNotEmpty
                        ? homeController.userModel.data!.profilePicture!
                        : "https://www.golosale.com/assets/image-B0sHWpoa.png",
                  ),
                  onBackgroundImageError: (_, __) {
                    // image error handled internally by fallback URL
                  },
                  child: homeController.userModel.data?.profilePicture == null
                      ? const Center(child: Icon(CupertinoIcons.person_alt))
                      : null,
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: InkWell(
              //     onTap: () {},
              //     child: Container(
              //       padding: const EdgeInsets.all(6),
              //       decoration: const BoxDecoration(
              //         color: Colors.black,
              //         shape: BoxShape.circle,
              //       ),
              //       child: const Icon(
              //         Icons.camera_alt,
              //         size: 18,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),
          // Text(
          //   "change_photo".tr,
          //   style: GoogleFonts.poppins(color: Colors.white70),
          // )
        ],
      ),
    );
  }

  /// ---------------- FORM CARD ----------------
  Widget _formCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _input("name".tr, Icons.person, controller: nameController),
              _input("last_name".tr, Icons.person, controller: lastNameController),
              _input("email".tr, Icons.email, controller: emailController, keyboardType: TextInputType.emailAddress),
              _input("mobile".tr, Icons.phone,
                  controller: phoneController, keyboardType: TextInputType.phone),
              _genderDropdown(),
              Visibility(
                visible: homeController.userModel.data?.parentUserReferralCode==''?true:false,
                replacement: Row(
                  children: [
                    Text("parent_refer_code".tr +":- ${homeController.userModel.data?.parentUserReferralCode}",),
                  ],
                ),
                child: _input(
                  "parent_refer_code".tr,
                  Icons.card_giftcard,
                  controller: nameController,
                  hint: "optional".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- INPUT FIELD ----------------
  Widget _input(
      String label,
      IconData icon, {
        String? hint,
        TextInputType keyboardType = TextInputType.text,
        required TextEditingController controller,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label.tr,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color(0xffF6F7FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ---------------- PASSWORD ----------------
  // Widget _passwordField() {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 14),
  //     child: TextField(
  //       controller: passwordController,
  //       obscureText: true,
  //       style: GoogleFonts.poppins(),
  //       decoration: InputDecoration(
  //         labelText: "password".tr,
  //         prefixIcon: const Icon(Icons.lock),
  //         suffixIcon: const Icon(Icons.visibility_off),
  //         filled: true,
  //         fillColor: const Color(0xffF6F7FB),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(14),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// ---------------- GENDER DROPDOWN ----------------
  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: InputDecoration(
          labelText: "gender".tr,
          prefixIcon: const Icon(Icons.people),
          filled: true,
          fillColor: const Color(0xffF6F7FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: [
          DropdownMenuItem(value: "male", child: Text("male".tr)),
          DropdownMenuItem(value: "female", child: Text("female".tr)),
          DropdownMenuItem(value: "other", child: Text("other".tr)),
        ],
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
      ),
    );
  }

  /// ---------------- SAVE BUTTON ----------------
  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4A6CF7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            final Map<String, dynamic> updated = {
              'name': nameController.text,
              'email': emailController.text,
              'phone': phoneController.text,
              'lastName': lastNameController.text,
              'gender': selectedGender,
              'parent_refer_code': referController.text,
            };
            // print map when save clicked
            debugPrint('Updated profile: $updated');
          },
          child: Text(
            "save_changes".tr,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
