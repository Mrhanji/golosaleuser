import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/address/model/address_model.dart';
import '/utils/end_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/address_controller.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final AddressController controller =
  Get.put(AddressController());

  static const Color primaryColor =
  Color(0xff4FC83F);

  static const Color secondaryColor =
  Color(0xff1D2939);

  void openAddressForm(
      BuildContext context,
      {dynamic model}) {

    TextEditingController holderName =
    TextEditingController(
        text: model?.holderName ?? "");

    TextEditingController building =
    TextEditingController(
        text: model?.building ?? "");

    TextEditingController landmark =
    TextEditingController(
        text: model?.landmark ?? "");

    RxString addressType =
    RxString(
        model?.addressType?.toString() ??
            "home");

    RxBool setDefault =
    RxBool(
        (model?.setAsDefault ?? 0) == 1);

    controller.selectedImage.value = null;

    if (model != null) {

      controller.selectedLocation.value =
          LatLng(
            double.tryParse(
                model.latitude.toString()) ??
                28.6139,
            double.tryParse(
                model.longitude.toString()) ??
                77.2090,
          );

      if (model.pinCode != null) {

        controller.selectedPinCode =
            int.tryParse(
                model.pinCode.toString()) ??
                controller.selectedPinCode;
      }
    }

    Get.to(
          () => Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,

          title: Text(
            model == null
                ? "add_address".tr
                : "update_address".tr,

            style: GoogleFonts.poppins(
              color: secondaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),

        body: Column(
          children: [

            /// MAP
            Container(
              margin:
              const EdgeInsets.symmetric(
                  horizontal: 16),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(.05),
                    blurRadius: 10,
                    offset:
                    const Offset(0, 4),
                  )
                ],
              ),

              clipBehavior: Clip.antiAlias,

              child: SizedBox(
                height: 240,

                child: Stack(
                  alignment: Alignment.center,

                  children: [

                    GoogleMap(
                      initialCameraPosition:
                      CameraPosition(
                        target: controller
                            .selectedLocation
                            .value,
                        zoom: 16,
                      ),

                      onMapCreated: (map) {
                        controller.mapController =
                            map;
                      },

                      onCameraMove:
                          (position) {

                        controller
                            .setLocation(
                            position.target);
                      },
                    ),

                    Container(
                      padding:
                      const EdgeInsets.all(
                          10),

                      decoration:
                      const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    Positioned(
                      bottom: 14,
                      right: 14,

                      child:
                      FloatingActionButton(
                        mini: true,
                        elevation: 0,

                        backgroundColor:
                        secondaryColor,

                        onPressed: controller
                            .getCurrentLocation,

                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.all(18),

                child: Column(
                  children: [

                    /// HOLDER NAME
                    buildTextField(
                      controller:
                      holderName,
                      title:
                      "holder_name".tr,
                      icon:
                      Icons.person_outline,
                    ),

                    const SizedBox(
                        height: 14),

                    /// BUILDING
                    buildTextField(
                      controller:
                      building,
                      title:
                      "building_flat".tr,
                      icon: Icons
                          .home_work_outlined,
                    ),

                    const SizedBox(
                        height: 14),

                    /// LANDMARK
                    buildTextField(
                      controller:
                      landmark,
                      title:
                      "landmark".tr,
                      icon: Icons
                          .location_on_outlined,
                    ),

                    const SizedBox(
                        height: 14),

                    /// PINCODE
                    GetBuilder<
                        AddressController>(
                      builder:
                          (controller) {

                        return Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                              horizontal:
                              16),

                          decoration:
                          BoxDecoration(
                            color: Colors
                                .grey
                                .shade100,

                            borderRadius:
                            BorderRadius
                                .circular(
                                16),
                          ),

                          child:
                          DropdownButtonHideUnderline(

                            child:
                            DropdownButton<
                                int>(

                              value: controller
                                  .pinCode
                                  .contains(
                                  controller
                                      .selectedPinCode)
                                  ? controller
                                  .selectedPinCode
                                  : null,

                              isExpanded:
                              true,

                              icon:
                              const Icon(
                                Icons
                                    .keyboard_arrow_down_rounded,
                              ),

                              hint: Text(
                                "select_pincode"
                                    .tr,

                                style:
                                GoogleFonts
                                    .poppins(
                                  fontSize:
                                  13,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                ),
                              ),

                              items: controller
                                  .pinCode
                                  .map((e) {

                                return DropdownMenuItem<
                                    int>(
                                  value: e,

                                  child: Text(
                                    e.toString(),

                                    style:
                                    GoogleFonts
                                        .poppins(
                                      fontSize:
                                      13,
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                    ),
                                  ),
                                );
                              }).toList(),

                              onChanged:
                                  (value) {

                                if (value !=
                                    null) {

                                  controller
                                      .selectPinCode(
                                      value);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                        height: 18),

                    /// IMAGE PICKER
                    Obx(() {

                      bool hasNetworkImage =
                          model?.houseImage !=
                              null &&
                              model.houseImage !=
                                  '';

                      bool hasLocalImage =
                          controller
                              .selectedImage
                              .value !=
                              null;

                      if (!hasLocalImage &&
                          !hasNetworkImage) {

                        return GestureDetector(

                          onTap: controller
                              .pickImage,

                          child: Container(
                            height: 120,
                            width:
                            double.infinity,

                            decoration:
                            BoxDecoration(

                              color: Colors
                                  .grey
                                  .shade100,

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  20),

                              border:
                              Border.all(
                                color: Colors
                                    .grey
                                    .shade300,
                              ),
                            ),

                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                              children: [

                                Container(
                                  padding:
                                  const EdgeInsets
                                      .all(
                                      12),

                                  decoration:
                                  BoxDecoration(
                                    color: primaryColor
                                        .withOpacity(
                                        .1),

                                    shape: BoxShape
                                        .circle,
                                  ),

                                  child:
                                  const Icon(
                                    Icons
                                        .cloud_upload_outlined,

                                    size: 28,

                                    color:
                                    primaryColor,
                                  ),
                                ),

                                const SizedBox(
                                    height:
                                    10),

                                Text(
                                  "upload_house_image"
                                      .tr,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    fontSize:
                                    13,
                                    fontWeight:
                                    FontWeight
                                        .w600,

                                    color:
                                    secondaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [

                          ClipRRect(
                            borderRadius:
                            BorderRadius
                                .circular(
                                18),

                            child: hasLocalImage

                                ? Image.file(
                              controller
                                  .selectedImage
                                  .value!,

                              height: 150,
                              width: double
                                  .infinity,

                              fit: BoxFit
                                  .cover,
                            )

                                : Image.network(

                              EndPoints
                                  .mediaUrl(
                                model
                                    .houseImage
                                    .toString(),
                              ),

                              height:
                              150,
                              width: double
                                  .infinity,

                              fit: BoxFit
                                  .cover,
                            ),
                          ),

                          Positioned(
                            right: 12,
                            top: 12,

                            child: InkWell(

                              onTap:
                              controller
                                  .pickImage,

                              child:
                              Container(

                                padding:
                                const EdgeInsets
                                    .all(
                                    8),

                                decoration:
                                const BoxDecoration(
                                  color:
                                  secondaryColor,

                                  shape: BoxShape
                                      .circle,
                                ),

                                child:
                                const Icon(
                                  Icons.edit,
                                  color: Colors
                                      .white,
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),

                    const SizedBox(
                        height: 22),

                    /// ADDRESS TYPE
                    Obx(() => Row(
                      children: [

                        Expanded(
                          child:
                          addressTypeCard(
                            icon: Icons
                                .home_rounded,

                            title:
                            "home".tr,

                            isSelected:
                            addressType
                                .value ==
                                "home",

                            onTap: () {
                              addressType
                                  .value =
                              "home";
                            },
                          ),
                        ),

                        const SizedBox(
                            width: 12),

                        Expanded(
                          child:
                          addressTypeCard(
                            icon: Icons
                                .work_rounded,

                            title:
                            "office".tr,

                            isSelected:
                            addressType
                                .value ==
                                "office",

                            onTap: () {
                              addressType
                                  .value =
                              "office";
                            },
                          ),
                        ),
                      ],
                    )),

                    const SizedBox(
                        height: 10),

                    /// DEFAULT
                    Obx(() =>
                        SwitchListTile(

                          activeColor:
                          primaryColor,

                          contentPadding:
                          EdgeInsets.zero,

                          title: Text(
                            "set_default_address"
                                .tr,

                            style:
                            GoogleFonts
                                .poppins(
                              fontSize:
                              13,

                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),

                          value:
                          setDefault
                              .value,

                          onChanged:
                              (v) {

                            setDefault
                                .value = v;
                          },
                        )),

                    const SizedBox(
                        height: 16),

                    /// SAVE BUTTON
                    ElevatedButton(

                      style:
                      ElevatedButton
                          .styleFrom(

                        elevation: 0,

                        backgroundColor:
                        primaryColor,

                        minimumSize:
                        const Size(
                            double
                                .infinity,
                            54),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              18),
                        ),
                      ),

                      onPressed: () {

                        AddressModel newModel =
                        AddressModel(

                          id: model
                              ?.addressId ??
                              DateTime.now()
                                  .toString(),

                          holderName:
                          holderName.text,

                          building:
                          building.text,

                          landmark:
                          landmark.text,

                          setAsDefault:
                          setDefault.value
                              ? 1
                              : 0,

                          latitude: controller
                              .selectedLocation
                              .value
                              .latitude,

                          longitude: controller
                              .selectedLocation
                              .value
                              .longitude,

                          addressType:
                          addressType.value,

                          houseImage:
                          controller
                              .selectedImage
                              .value
                              ?.path ??
                              model
                                  ?.houseImage,
                        );

                        if (model ==
                            null) {

                          controller
                              .addAddress(
                              newModel);

                        } else {

                          controller
                              .updateAddress(
                              newModel);

                          controller
                              .update();

                          Get.snackbar(
                            "success".tr,
                            "address_updated_successfully"
                                .tr,
                          );
                        }

                        Get.back();
                      },

                      child: Text(
                        model == null
                            ? "save_address"
                            .tr
                            : "update_address"
                            .tr,

                        style:
                        GoogleFonts
                            .poppins(
                          fontWeight:
                          FontWeight
                              .w700,

                          fontSize: 15,
                          color:
                          Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController
    controller,
    required String title,
    required IconData icon,
  }) {

    return TextField(

      controller: controller,

      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(

        labelText: title,

        labelStyle:
        GoogleFonts.poppins(
          fontSize: 13,
        ),

        prefixIcon: Icon(
          icon,
          color: primaryColor,
          size: 20,
        ),

        filled: true,
        fillColor:
        Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
              16),

          borderSide:
          BorderSide.none,
        ),
      ),
    );
  }

  Widget addressTypeCard({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration:
        const Duration(
            milliseconds: 250),

        padding:
        const EdgeInsets.symmetric(
            vertical: 14),

        decoration: BoxDecoration(

          color: isSelected
              ? primaryColor
              : Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(
              18),

          boxShadow: isSelected
              ? [
            BoxShadow(
              color: primaryColor
                  .withOpacity(.18),

              blurRadius: 10,
              offset:
              const Offset(
                  0, 4),
            )
          ]
              : [],
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(
              icon,

              color: isSelected
                  ? Colors.white
                  : secondaryColor,

              size: 18,
            ),

            const SizedBox(width: 7),

            Text(
              title,

              style:
              GoogleFonts.poppins(
                fontSize: 13,

                color: isSelected
                    ? Colors.white
                    : secondaryColor,

                fontWeight:
                FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addressCard(
      AddressData model) {

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),

        boxShadow: [

          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,

            offset:
            const Offset(0, 4),

            color: Colors.black
                .withOpacity(.035),
          )
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// TOP SECTION
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Text(
                      model.holderName
                          .toString(),

                      style:
                      GoogleFonts
                          .poppins(
                        fontWeight:
                        FontWeight
                            .w700,

                        fontSize: 15,

                        color:
                        secondaryColor,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children: [

                        /// HOME/OFFICE CHIP
                        Container(

                          padding:
                          const EdgeInsets
                              .symmetric(
                              horizontal:
                              12,
                              vertical:
                              7),

                          decoration:
                          BoxDecoration(
                            color:
                            primaryColor,

                            borderRadius:
                            BorderRadius
                                .circular(
                                100),
                          ),

                          child: Row(
                            mainAxisSize:
                            MainAxisSize
                                .min,

                            children: [

                              Icon(
                                model.addressType
                                    .toString() ==
                                    "home"
                                    ? Icons.home
                                    : Icons.work,

                                color: Colors
                                    .white,

                                size: 14,
                              ),

                              const SizedBox(
                                  width: 5),

                              Text(
                                model
                                    .addressType
                                    .toString()
                                    .tr,

                                style:
                                GoogleFonts
                                    .poppins(
                                  color: Colors
                                      .white,

                                  fontWeight:
                                  FontWeight
                                      .w600,

                                  fontSize:
                                  11.5,
                                ),
                              )
                            ],
                          ),
                        ),

                        /// DEFAULT CHIP
                        if (model
                            .setAsDefault ==
                            1)

                          Container(

                            padding:
                            const EdgeInsets
                                .symmetric(
                                horizontal:
                                12,
                                vertical:
                                7),

                            decoration:
                            BoxDecoration(

                              color: primaryColor
                                  .withOpacity(
                                  .10),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  100),

                              border:
                              Border.all(
                                color:
                                primaryColor
                                    .withOpacity(
                                    .15),
                              ),
                            ),

                            child: Row(
                              mainAxisSize:
                              MainAxisSize
                                  .min,

                              children: [

                                Icon(
                                  Icons
                                      .verified_rounded,

                                  size: 14,

                                  color:
                                  primaryColor,
                                ),

                                const SizedBox(
                                    width:
                                    5),

                                Text(
                                  "default"
                                      .tr,

                                  style:
                                  GoogleFonts
                                      .poppins(
                                    color:
                                    primaryColor,

                                    fontWeight:
                                    FontWeight
                                        .w700,

                                    fontSize:
                                    11.5,
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 14),

          /// ADDRESS DETAILS
          addressRow(
            Icons.home_work_outlined,
            model.building.toString(),
          ),

          const SizedBox(height: 8),

          addressRow(
            Icons.location_on_outlined,
            model.landmark.toString(),
          ),

          const SizedBox(height: 8),

          addressRow(
            Icons.pin_drop_outlined,
            model.pinCode.toString(),
          ),

          if (model.houseImage != null &&
              model.houseImage != '')

            Padding(
              padding:
              const EdgeInsets.only(
                  top: 14),

              child: ClipRRect(

                borderRadius:
                BorderRadius.circular(
                    18),

                child: Image.network(

                  EndPoints.mediaUrl(
                      model.houseImage
                          .toString()),

                  height: 145,
                  width:
                  double.infinity,

                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 16),

          /// BUTTONS
          Row(
            children: [

              /// EDIT
              Expanded(
                child: actionButton(
                  title:
                  "edit".tr,
                  icon:
                  Icons.edit_rounded,

                  bgColor:
                  primaryColor
                      .withOpacity(
                      .10),

                  textColor:
                  primaryColor,

                  onTap: () {

                    openAddressForm(
                      Get.overlayContext!,
                      model: model,
                    );
                  },
                ),
              ),

              const SizedBox(
                  width: 10),

              /// DELETE
              Expanded(
                child: actionButton(
                  title:
                  "delete".tr,
                  icon:
                  Icons.delete_rounded,

                  bgColor: Colors.red
                      .withOpacity(
                      .08),

                  textColor:
                  Colors.red,

                  onTap: () {

                    Get.defaultDialog(

                      title:
                      "delete_address"
                          .tr,

                      middleText:
                      "delete_address_confirmation"
                          .tr,

                      radius: 18,

                      textCancel:
                      "cancel".tr,

                      textConfirm:
                      "delete".tr,

                      confirmTextColor:
                      Colors.white,

                      buttonColor:
                      Colors.red,

                      onConfirm:
                          () {

                        controller
                            .addressHistoryModel
                            .data
                            ?.removeWhere(
                                (e) =>
                            e.addressId ==
                                model
                                    .addressId);

                        controller
                            .update();

                        Get.back();

                        Get.snackbar(
                          "success"
                              .tr,

                          "address_deleted_successfully"
                              .tr,
                        );
                      },
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addressRow(
      IconData icon,
      String text,
      ) {

    return Row(
      children: [

        Container(

          padding:
          const EdgeInsets.all(
              8),

          decoration: BoxDecoration(
            color: primaryColor
                .withOpacity(.1),

            borderRadius:
            BorderRadius.circular(
                12),
          ),

          child: Icon(
            icon,
            color: primaryColor,
            size: 16,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,

            style:
            GoogleFonts.poppins(
              fontWeight:
              FontWeight.w500,

              fontSize: 12.5,

              color:
              secondaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget actionButton({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {

    return InkWell(

      onTap: onTap,

      borderRadius:
      BorderRadius.circular(
          18),

      child: Container(

        padding:
        const EdgeInsets.symmetric(
            vertical: 13),

        decoration: BoxDecoration(
          color: bgColor,

          borderRadius:
          BorderRadius.circular(
              18),
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: textColor,
              size: 18,
            ),

            const SizedBox(width: 7),

            Text(
              title,

              style:
              GoogleFonts.poppins(
                color: textColor,

                fontSize: 12.5,

                fontWeight:
                FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF4F7FA),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        const Color(
            0xffF4F7FA),

        centerTitle: true,

        title: Text(
          "my_addresses".tr,

          style:
          GoogleFonts.poppins(
            color:
            secondaryColor,

            fontWeight:
            FontWeight.w700,

            fontSize: 20,
          ),
        ),
      ),

      floatingActionButton:
      FloatingActionButton(

        elevation: 0,

        backgroundColor:
        primaryColor,

        onPressed: () =>
            openAddressForm(context),

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body:
      GetBuilder<
          AddressController>(

        init: controller,

        builder: (controller) {

          if (controller
              .fetchingState
              .value ==
              AddressFetchingState
                  .loading) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (controller
              .fetchingState
              .value ==
              AddressFetchingState
                  .notFound) {

            return Center(
              child: Text(
                "no_address_found"
                    .tr,

                style:
                GoogleFonts
                    .poppins(
                  fontSize: 13,
                  fontWeight:
                  FontWeight
                      .w600,
                ),
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.only(
                top: 8,
                bottom: 100),

            itemCount: controller
                .addressHistoryModel
                .data
                ?.length ??
                0,

            itemBuilder:
                (context, index) {

              return addressCard(
                controller
                    .addressHistoryModel
                    .data![index],
              );
            },
          );
        },
      ),
    );
  }
}