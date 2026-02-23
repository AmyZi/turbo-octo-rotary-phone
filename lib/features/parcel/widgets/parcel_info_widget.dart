import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/helper/country_code_helper.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/test_field_title.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class ParcelInfoWidget extends StatefulWidget {
  final bool isSender;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelInfoWidget({super.key, required this.isSender, required this.expandableKey});

  @override
  State<ParcelInfoWidget> createState() => _ParcelInfoWidgetState();
}

class _ParcelInfoWidgetState extends State<ParcelInfoWidget> {

  @override
  void initState() {
    super.initState();

    final ParcelController parcelController = Get.find<ParcelController>();

    if(widget.isSender) {
      String? senderPhoneNumber = Get.find<ProfileController>().profileModel?.data?.phone;

      if(senderPhoneNumber != null) {
       parcelController.onChangeSenderCountryCode(CountryCodeHelper.getCountryCode(senderPhoneNumber), isUpdate: false);
      }

      parcelController.senderContactController.text = senderPhoneNumber?.replaceAll(parcelController.getSenderCountryCode ?? '', '') ?? '';
      parcelController.senderNameController.text = Get.find<ProfileController>().customerName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

        TextFieldTitle(title: 'contact'.tr, textOpacity: 0.8),
        CustomTextField(
          isCodePicker: true,
          isCodePickerFillColor: false,
          borderRadius: 10,
          showBorder: false,
          hintText: 'contact_number'.tr,
          fillColor:  Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColor.withValues(alpha:0.04),
          controller: widget.isSender ? parcelController.senderContactController : parcelController.receiverContactController,
          focusNode: widget.isSender ? parcelController.senderContactNode : parcelController.receiverContactNode,
          nextFocus: widget.isSender ? parcelController.senderNameNode : parcelController.receiverNameNode,
          inputType: TextInputType.phone,
          countryDialCode: widget.isSender
              ? parcelController.getSenderCountryCode
              : parcelController.getReceiverCountryDialCode,

          onCountryChanged: (CountryCode countryCode){
            if(widget.isSender) {
              parcelController.onChangeSenderCountryCode(countryCode.dialCode);

            }else {
              parcelController.onChangeReceiverCountryCode(countryCode.dialCode);

            }
          },
          ),

        TextFieldTitle(title: 'name'.tr, textOpacity: 0.8),
        CustomTextField(
          prefixIcon: Images.editProfilePhone,
          borderRadius: 10,
          showBorder: false,
          prefix: false,
          capitalization: TextCapitalization.words,
          hintText: 'name'.tr,
          fillColor: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColor.withValues(alpha:0.04),
          controller: widget.isSender ? parcelController.senderNameController : parcelController.receiverNameController,
          focusNode: widget.isSender ? parcelController.senderNameNode : parcelController.receiverNameNode,
          nextFocus: widget.isSender ? parcelController.senderAddressNode : parcelController.receiverAddressNode,
          inputType: TextInputType.text,
          onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey)),

        TextFieldTitle(title: 'address'.tr, textOpacity: 0.8),

        InkWell(
          onTap: () => RouteHelper.goPageAndHideTextField(context, PickMapScreen(
            type: widget.isSender? LocationType.senderLocation : LocationType.receiverLocation,
            address: widget.isSender? Get.find<LocationController>().parcelSenderAddress : Get.find<LocationController>().parcelReceiverAddress,
          )),
          child: CustomTextField(
            prefix: false,
            suffixIcon: Images.location,
            borderRadius: 10,
            isEnabled: false,
            showBorder: false,
            textColor: Theme.of(context).textTheme.bodyLarge!.color,
            hintText: 'location'.tr,
            fillColor:  Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColor.withValues(alpha:0.04),
            controller: widget.isSender ? parcelController.senderAddressController : parcelController.receiverAddressController,
            focusNode: widget.isSender ? parcelController.senderAddressNode : parcelController.receiverAddressNode,
            inputType: TextInputType.text,
            inputAction: TextInputAction.done,
            onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey),
          ),
        ),

        if(Get.find<AddressController>().addressList?.isNotEmpty ?? false)
          TextFieldTitle(title: 'saved_address'.tr, textOpacity: 0.8),

        GetBuilder<AddressController>(builder: (addressController){
          return addressController.addressList != null ?
          addressController.addressList!.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: SizedBox(
              height: Get.width * 0.075,
              child: ListView.builder(
                itemCount: addressController.addressList?.length,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index) {
                  return InkWell(
                    onTap: () {
                      final locationController = Get.find<LocationController>();
                      locationController.getZone(addressController.addressList![index].latitude.toString(), addressController.addressList![index].longitude.toString()).then((value){
                        if(value.isSuccess){
                          if(widget.isSender) {
                            locationController.setSenderAddress(addressController.addressList?[index]);
                          }else {
                            locationController.setReceiverAddress(addressController.addressList?[index]);
                          }
                        }else{
                          showCustomSnackBar('service_not_available_in_this_area'.tr);
                        }
                      });

                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color:Get.isDarkMode ?
                          Theme.of(context).hintColor :
                          Theme.of(context).primaryColor.withValues(alpha:0.4),width:0.5,
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Image.asset(
                          addressController.addressList?[index].addressLabel == 'home' ? Images.homeIcon :
                          addressController.addressList?[index].addressLabel == 'office' ? Images.workIcon : Images.otherIcon,
                          color: Get.find<ThemeController>().darkTheme ?
                          Theme.of(context).primaryColor :
                          Theme.of(context).hintColor,
                          height: 16,width: 16,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(addressController.addressList![index].addressLabel!.tr,style: textBold),

                      ]),
                    ),
                  );
                },
              ),
            ),
          ) :
          const SizedBox(height: Dimensions.paddingSizeSmall) :
          const SizedBox(height: Dimensions.paddingSizeSmall);
        }),


        ButtonWidget(buttonText: "next".tr,
          onPressed: () {
            PhoneNumber senderNumber = PhoneNumber.parse('${parcelController.getSenderCountryCode}${parcelController.senderContactController.text}');


            if(parcelController.tabController.index == 0) {
              if(parcelController.senderContactController.text.isEmpty){
                showCustomSnackBar('enter_sender_contact_number'.tr);
                FocusScope.of(context).requestFocus(parcelController.senderContactNode);

              }else if(!senderNumber.isValid(type: PhoneNumberType.mobile)) {
                showCustomSnackBar('enter_valid_contact_number'.tr);
                FocusScope.of(context).requestFocus(parcelController.senderContactNode);

              }else if(parcelController.senderNameController.text.isEmpty){
                showCustomSnackBar('enter_sender_name'.tr);
                FocusScope.of(context).requestFocus(parcelController.senderNameNode);
                parcelController.focusOnBottomSheet(widget.expandableKey);

              } else if(parcelController.senderAddressController.text.isEmpty){
                showCustomSnackBar('enter_sender_address'.tr);
                RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                  type: LocationType.senderLocation,
                  address: Get.find<LocationController>().parcelSenderAddress,
                ));

              }else {
                parcelController.updateTabControllerIndex(1);

                if(parcelController.getReceiverCountryDialCode == null) {
                  parcelController.onChangeReceiverCountryCode(parcelController.getSenderCountryCode);
                }
              }
            }
            else {
              PhoneNumber reviverNumber = PhoneNumber.parse('${parcelController.getReceiverCountryDialCode}${parcelController.receiverContactController.text}');

              if(parcelController.receiverContactController.text.isEmpty){
                showCustomSnackBar('enter_receiver_contact_number'.tr);
                FocusScope.of(context).requestFocus(parcelController.receiverContactNode);
              }else if(!reviverNumber.isValid(type: PhoneNumberType.mobile)){
                showCustomSnackBar('enter_valid_contact_number'.tr);
                FocusScope.of(context).requestFocus(parcelController.receiverContactNode);

              } else if(parcelController.receiverNameController.text.isEmpty){
                showCustomSnackBar('enter_receiver_name'.tr);
                FocusScope.of(context).requestFocus(parcelController.receiverNameNode);
                parcelController.focusOnBottomSheet(widget.expandableKey);

              } else if(parcelController.receiverAddressController.text.isEmpty){
                showCustomSnackBar('enter_receiver_address'.tr);
                RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                  type: LocationType.receiverLocation,
                  address: Get.find<LocationController>().parcelReceiverAddress,
                ));

              }else if(parcelController.senderContactController.text.isEmpty){
                showCustomSnackBar('enter_sender_contact_number'.tr);

              }else if(parcelController.senderNameController.text.isEmpty){
                showCustomSnackBar('enter_sender_name'.tr);

              } else if(parcelController.senderAddressController.text.isEmpty){
                showCustomSnackBar('enter_sender_address'.tr);
                parcelController.updateTabControllerIndex(0);
                RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                    type: LocationType.senderLocation,
                    address: Get.find<LocationController>().parcelSenderAddress
                ));

              }else {
                Get.find<MapController>().notifyMapController();
                parcelController.updateParcelState(ParcelDeliveryState.addOtherParcelDetails);

              }
            }
          },
        ),

      ]);
    });
  }
}
