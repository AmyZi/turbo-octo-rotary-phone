import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/features/address/screens/search_and_pick_location_screen.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class AddNewAddress extends StatefulWidget {
  final Address? address;
  const AddNewAddress({super.key, this.address});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roadController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController addressLevelController = TextEditingController();
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    Get.find<LocationController>().initTextControllers();
    if(widget.address != null) {
      Get.find<LocationController>().locationController.text = widget.address!.address!;
      houseController.text = widget.address!.house ?? '';
      roadController.text = widget.address!.street ?? '';
      addressLevelController.text = widget.address?.addressLabel ?? '';
      Get.find<AddressController>().updateAddressIndex(
        widget.address!.addressLabel! == 'home' ? 0 : widget.address!.addressLabel! == 'office' ? 1 : 2,
        false,
      );
      _cameraPosition = CameraPosition(target: LatLng(widget.address!.latitude!, widget.address!.longitude!));
    }
    phoneController.text = Get.find<ProfileController>().profileModel!.data!.phone!;
    nameController.text = '${Get.find<ProfileController>().profileModel!.data!.firstName!} '
        '${Get.find<ProfileController>().profileModel!.data!.lastName!}';
    super.initState();
  }
  @override
  void dispose() {
    Get.find<LocationController>().mapController?.dispose();
    _mapController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'add_address'.tr, centerTitle: true),
          body: GetBuilder<AddressController>(builder: (addressController) {
            return GetBuilder<LocationController>(builder: (locationController) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Stack(children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
                          topRight: Radius.circular(Dimensions.paddingSizeExtraLarge),
                        ),
                        child: SizedBox(height: 170, width: Get.width, child: GoogleMap(
                            initialCameraPosition:  CameraPosition(
                              target: widget.address != null ?
                              LatLng(widget.address!.latitude!, widget.address!.longitude!) :
                              locationController.initialPosition, zoom: 16,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              locationController.mapController = controller;
                            },
                            onCameraIdle: () {
                              if(_cameraPosition != null) {
                                locationController.updatePosition(_cameraPosition?.target, false, null);
                              }
                            },
                            onCameraMove: ((position) => _cameraPosition = position),
                            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: true,
                            style:
                            Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap
                        )),
                      ),

                      Positioned(child: Padding(
                        padding: const EdgeInsets.only(top: 55),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(width: 50,height: 50, child: Image.asset(Images.pickLocation)),
                        ),
                      )),

                      Positioned(child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: ()=> Get.to(() => PickMapScreen(
                              type: LocationType.location,
                              onLocationPicked: (Position position, String address) {
                                locationController.mapController!.moveCamera(CameraUpdate.newCameraPosition(
                                  CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16),
                                ));
                                locationController.locationController.text = address;
                              },
                              address: widget.address ?? locationController.addAddress,
                            )),
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                ),
                                width: 40,height: 40,
                                child: Icon(Icons.fullscreen, color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ),
                      )),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        'choose_label'.tr,
                        style: textMedium.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeDefault,
                        top: Dimensions.paddingSizeExtraSmall,
                      ),
                      child: SizedBox(height: 74, child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: addressController.addressTypeList.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => addressController.updateAddressIndex(index, true),
                          child: Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                            child: Column(children: [
                              Container(width: 50,height: 50,
                                padding: const EdgeInsets.all(Dimensions.paddingSize),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: addressController.selectAddressIndex == index ?
                                  Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: addressController.selectAddressIndex == index
                                        ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                  ),
                                ),
                                child: Image.asset(
                                  addressController.addressTypeList[index].icon,
                                  color: addressController.selectAddressIndex == index ?
                                  Colors.white :
                                  Theme.of(context).hintColor,
                                  scale: 0.5,
                                ),
                              ),
                              Text(addressController.addressTypeList[index].title.tr),
                            ]),
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    if(addressController.selectAddressIndex == 2)...[
                      CustomTextField(
                        hintText: 'address_level_name'.tr,
                        inputType: TextInputType.streetAddress,
                        prefixIcon: Images.location,
                        controller: addressLevelController,
                        inputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],

                    CustomTextField(
                      hintText: 'pick_location'.tr,
                      inputType: TextInputType.name,
                      prefixIcon: Images.location,
                      read: true,
                      controller: Get.find<LocationController>().locationController,
                      inputAction: TextInputAction.next,
                      onTap: (){
                        Get.to(() => SearchAndPickLocationScreen(mapController: _mapController,address: widget.address));
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomTextField(
                      hintText: 'name'.tr,
                      inputType: TextInputType.name,
                      prefixIcon: Images.person,
                      controller: nameController,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomTextField(
                      hintText: 'phone'.tr,
                      inputType: TextInputType.name,
                      prefixIcon: Images.call,
                      controller: phoneController,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomTextField(
                      hintText: 'street'.tr,
                      inputType: TextInputType.name,
                      controller: roadController,
                      prefixIcon: Images.road,
                      inputAction: TextInputAction.next,
                    ),

                  ]),
                ),
              );
            });
          }),
        ),
        bottomNavigationBar: GetBuilder<AddressController>(builder: (addressController) {
          return GetBuilder<LocationController>(builder: (locationController) {
            return Container(
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha:.1),spreadRadius: 1,
                  blurRadius: 5, offset: Offset.fromDirection(1,1),
                )],
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: !addressController.isLoading ?
                ButtonWidget(
                  buttonText: widget.address != null ? 'update_address'.tr : 'save_address'.tr,
                  onPressed: () {
                    String location = Get.find<LocationController>().locationController.text;
                    String name = nameController.text;
                    String phone = phoneController.text;
                    String street = roadController.text;
                    String levelName = addressLevelController.text.trim();

                    if(location.isEmpty) {
                      showCustomSnackBar('address_is_required'.tr);
                    }else if(name.isEmpty) {
                      showCustomSnackBar('name_is_required'.tr);
                    }else if(phone.isEmpty) {
                      showCustomSnackBar('phone_is_required'.tr);
                    }else if(addressController.selectAddressIndex == 2 && levelName.isEmpty){
                      showCustomSnackBar('address_level_name_required'.tr);
                    }else{
                      Address address = Address (
                        id: widget.address?.id,
                        address: location,
                        latitude: locationController.pickPosition.latitude,
                        longitude: locationController.pickPosition.longitude,
                        contactPersonName: name,
                        contactPersonPhone: phone,
                        street: street,
                        addressLabel: addressController.selectAddressIndex == 2 ?
                        levelName : addressController.selectAddress,
                      );
                      addressController.addNewAddress(address, updateAddress: widget.address != null);
                    }
                  },
                ) :
                Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)),
              ),
            );
          });
        }),
      ),
    );
  }
}
