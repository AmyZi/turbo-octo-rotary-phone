import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/set_destination/screens/set_destination_screen.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class AddressItemCard extends StatelessWidget {
  final Address address;
  const AddressItemCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString()).then((value){
          if(value.isSuccess){
            Get.to(() => SetDestinationScreen(address: address));
          }else{
            showCustomSnackBar('service_not_available_in_this_area'.tr);
          }
        });

      },
      child: Container(width: Get.width * 0.6,
        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
          border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha:0.4),width:1,
          ),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            address.addressLabel == 'home' ? Images.homeIcon :
            address.addressLabel == 'office' ? Images.workIcon : Images.otherIcon,
            color: Get.find<ThemeController>().darkTheme ?
            Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8) :
            Theme.of(context).hintColor,
            height: 16,width: 16,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(address.addressLabel!.tr,style: textBold.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null)),

              Text(address.address ?? '',style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8) : null),overflow: TextOverflow.ellipsis)
            ],
          )),

        ]),
      ),
    );
  }
}
