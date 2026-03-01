import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/address/widgets/address_item_card.dart';
import 'package:ride_sharing_user_app/features/home/widgets/address_shimmer.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/features/address/screens/add_new_address.dart';

enum AddressPage{home, sender, receiver}

class HomeMyAddress extends StatefulWidget {
  final String? title;
  final AddressPage? addressPage;
  const HomeMyAddress({super.key, this.title, this.addressPage});

  @override
  State<HomeMyAddress> createState() => _HomeMyAddressState();
}

class _HomeMyAddressState extends State<HomeMyAddress> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(builder: (addressController) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSize),
        decoration: BoxDecoration(
            color:
            (
                addressController.addressList != null &&
                    addressController.addressList!.isNotEmpty
            ) ?
            Theme.of(context).primaryColor.withValues(alpha:0.2) : null
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
             widget.title ?? 'my_address'.tr,
            style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
            color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null),
          ),

          if(addressController.addressList != null && addressController.addressList!.isNotEmpty)
            Text('saved_address_for_your_trip'.tr, style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null
            )),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          addressController.addressList != null ?
          addressController.addressList!.isNotEmpty ?
          SizedBox(
            height: Get.width *0.15,
            child: ListView.builder(
              itemCount: addressController.addressList?.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index) {
                return AddressItemCard(
                  address: addressController.addressList![index],
                );
              },
            ),
          ) :
          InkWell(
            onTap: ()=> Get.to(() =>   const AddNewAddress(address: null)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                color : Get.isDarkMode ?
                Theme.of(context).scaffoldBackgroundColor :
                Theme.of(context).colorScheme.onSecondary.withValues(alpha:.03),
                border: Border.all(
                    color: Get.isDarkMode ?
                    Theme.of(context).canvasColor :
                    Theme.of(context).primaryColor.withValues(alpha:.15),
                )
              ),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                    width: Dimensions.buttonSize, height: Dimensions.buttonSize,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).cardColor :
                      Theme.of(context).primaryColor.withValues(alpha:.07),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: Center(child: Icon(Icons.add, color: Theme.of(context).primaryColor)),
                  ),
                ),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('add_address'.tr, style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null
                  )),

                  Text(
                    'save_your_address_for_quick_trip'.tr,
                    style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8) : null
                    ),
                  ),
                ])),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: SizedBox(width: 100, child: Image.asset(Images.addNewAddress)),
                ),
              ]),
            ),
          ) :
          const AddressShimmer(),
        ]),
      );
    });
  }
}
