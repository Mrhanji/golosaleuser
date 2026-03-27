import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golosaleuser/app/features/address/model/address_model.dart';
import 'package:golosaleuser/utils/end_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../controller/address_controller.dart';





class AddressScreen extends StatelessWidget {

  AddressScreen({super.key});

  final AddressController controller =
  Get.put(AddressController());

  void openAddressForm(BuildContext context,
      {AddressModel? model}) {

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
        (model?.addressType ?? "home").obs;

    RxBool setDefault =
        (model?.setAsDefault == 1).obs;

    if (model != null) {
      controller.selectedLocation.value =
          LatLng(model.latitude, model.longitude);
    }

    Get.to(() => Scaffold(

      appBar: AppBar(
        title: Text(
            model == null ? "Add Address" : "Update Address"),
      ),

      body: Column(
        children: [

          /// MAP
          SizedBox(
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                    controller.selectedLocation.value,
                    zoom: 16,
                  ),
                  onMapCreated: (map) {
                    controller.mapController = map;
                  },
                  onCameraMove: (position) {
                    controller
                        .setLocation(position.target);
                  },
                ),

                const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 45,
                ),

                Positioned(
                  bottom: 15,
                  right: 15,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed:
                    controller.getCurrentLocation,
                    child:
                    const Icon(Icons.my_location),
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.all(20),
              child: Column(
                children: [

                  TextField(
                    controller: holderName,
                    decoration:
                    const InputDecoration(
                        labelText:
                        "Holder Name"),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: building,
                    decoration:
                    const InputDecoration(
                        labelText:
                        "Building / Flat"),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: landmark,
                    decoration:
                    const InputDecoration(
                        labelText:
                        "Landmark"),
                  ),

                  const SizedBox(height: 15),

                  /// IMAGE PICKER
                  Obx(() {

                    if (controller.selectedImage.value ==
                        null) {
                      return GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration:
                          BoxDecoration(
                            border: Border.all(
                                color: Colors.grey),
                            borderRadius:
                            BorderRadius
                                .circular(10),
                          ),
                          child: const Center(
                            child: Text(
                                "Upload Gate / House Image (Optional)"),
                          ),
                        ),
                      );
                    }

                    return Stack(
                      children: [

                        ClipRRect(
                          borderRadius:
                          BorderRadius
                              .circular(10),
                          child: Image.file(
                            controller
                                .selectedImage.value!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          right: 10,
                          top: 10,
                          child: CircleAvatar(
                            backgroundColor:
                            Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                  Icons.close),
                              onPressed: () {
                                controller
                                    .selectedImage
                                    .value = null;
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }),

                  const SizedBox(height: 15),

                  /// ADDRESS TYPE
                  Obx(() => Row(
                    children: [

                      ChoiceChip(
                        label:
                        const Text("Home"),
                        selected:
                        addressType.value ==
                            "home",
                        onSelected: (_) =>
                        addressType.value =
                        "home",
                      ),

                      const SizedBox(width: 10),

                      ChoiceChip(
                        label:
                        const Text("Office"),
                        selected:
                        addressType.value ==
                            "office",
                        onSelected: (_) =>
                        addressType.value =
                        "office",
                      ),
                    ],
                  )),

                  Obx(() => SwitchListTile(
                    title: const Text(
                        "Set as Default Address"),
                    value: setDefault.value,
                    onChanged: (v) =>
                    setDefault.value = v,
                  )),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(
                      minimumSize:
                      const Size(
                          double.infinity,
                          50),
                    ),
                    onPressed: () {

                      AddressModel newModel =
                      AddressModel(
                        id: model?.id ??
                            DateTime.now()
                                .toString(),
                        holderName:
                        holderName.text,
                        building: building.text,
                        landmark: landmark.text,
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
                        houseImage: controller
                            .selectedImage
                            .value
                            ?.path,
                      );

                      if (model == null) {
                      //  controller.addAddress(newModel);
                      } else {
                       // controller.updateAddress(newModel);
                      }

                      Get.back();
                    },
                    child: Text(model == null
                        ? "Save Address"
                        : "Update Address"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget addressCard(AddressData model) {

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              blurRadius: 8,
              color: Colors.black
                  .withOpacity(.05))
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Text(
                model.holderName.toString(),
                style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 16),
              ),

              const SizedBox(width: 10),

              Chip(
                  label:
                  Text(model.addressType.toString())),

              if (model.setAsDefault == 1)
                const Padding(
                  padding:
                  EdgeInsets.only(
                      left: 8),
                  child: Chip(
                      label:
                      Text("DEFAULT")),
                )
            ],
          ),

          const SizedBox(height: 5),

          Text(model.building.toString()),

          Text("Landmark: ${model.landmark}"),

          if (model.houseImage != '')
            Padding(
              padding:
              const EdgeInsets.only(
                  top: 10),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child: Image.network(
                  EndPoints.mediaUrl(model.houseImage.toString()),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 10),

          Row(
            children: [

              TextButton.icon(
                onPressed: () =>
                    // openAddressForm(
                    //     Get.context!,
                    //     model: model),
                    null,
                icon:
                const Icon(Icons.edit),
                label:
                const Text("Edit"),
              ),

              TextButton.icon(
                onPressed: () =>
                    controller.deleteAddress(
                        model.addressId.toString()),
                icon: const Icon(
                    Icons.delete,
                    color: Colors.red),
                label: const Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.red),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Addresses"),
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: () =>
            openAddressForm(context),
        child: const Icon(Icons.add),
      ),

      body: GetBuilder(
          init: controller,
          builder: (context){

        if(controller.fetchingState.value==AddressFetchingState.loading){
          return const Center(child: CircularProgressIndicator(),);

        }else if(controller.fetchingState.value==AddressFetchingState.notFound){
          return const Center(child: Text("No Address Found"),);
        }else
        return ListView.builder(
          itemCount: controller.addressHistoryModel.data!.length,
          itemBuilder:
              (context, index) {

            return addressCard(controller.addressHistoryModel.data![index]);
          },
        );
      }),
    );
  }
}