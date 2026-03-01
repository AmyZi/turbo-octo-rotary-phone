import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

enum RiseFare{ride, parcel}

class RiseFareWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  final RiseFare fromPage;
  const RiseFareWidget({super.key, required this.fromPage, required this.expandableKey});

  @override
  State<RiseFareWidget> createState() => _RiseFareWidgetState();
}



class _RiseFareWidgetState extends State<RiseFareWidget> {
  TextEditingController riseFareController = TextEditingController();

  @override
  void initState() {
    if(widget.fromPage == RiseFare.ride){
      riseFareController.text = PriceConverter.convertPrice(
          Get.find<RideController>().tripDetails == null ?
          Get.find<RideController>().estimatedFare : Get.find<RideController>().tripDetails!.estimatedFare!
      );
    }else{
      riseFareController.text = PriceConverter.convertPrice(Get.find<RideController>().parcelEstimatedFare!.data!.estimatedFare!);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<ParcelController>(builder: (parcelController) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: Text('current_fare'.tr,style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor.withValues(alpha:0.6),
            )),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: (){
                double price = double.parse(
                    riseFareController.text.trim().replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '').replaceAll(' ', '').replaceAll(',', '')
                );

                if(price > 5){
                  riseFareController.text = PriceConverter.convertPrice(price - 5);
                  setState(() {});
                }

              },
              child: Container(width: Get.width * 0.15, height: Get.height * 0.04,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree),
                    border: Border.all(color: Theme.of(context).primaryColor)
                ),
                child: Center(
                  child: Text(
                    '-', style: textRegular.copyWith(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Container(width: Get.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: IntrinsicWidth(child: TextFormField(
                textAlign: TextAlign.center,
                style: textRobotoRegular.copyWith(color: Theme.of(context).primaryColor),
                onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey),
                controller: riseFareController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'-'))
                ],
                decoration: InputDecoration(
                    hintText: 'enter_amount'.tr,
                    hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha:.5)),
                    border: InputBorder.none
                ),
                onChanged: (String amount){
                  riseFareController.text = '${Get.find<ConfigController>().config?.currencySymbol ?? '\$'}'
                      '${amount.replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '')}';
                },
              )),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            InkWell(
              onTap: (){
                riseFareController.text = PriceConverter.convertPrice(double.parse(
                    riseFareController.text.trim().replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '').replaceAll(' ', '').replaceAll(',', '')
                )+5);
                setState(() {});
              },
              child: Container(width: Get.width * 0.15, height: Get.height * 0.04,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree),
                    border: Border.all(color: Theme.of(context).primaryColor)
                ),
                child: Center(
                  child: Text(
                    '+', style: textRegular.copyWith(color: Theme.of(context).cardColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          rideController.isSubmit ?
          Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
          ButtonWidget(
              buttonText: 'rise_fare'.tr,
              radius: Dimensions.paddingSizeSmall,
              onPressed: () {
            String newFare = riseFareController.text.trim().replaceAll(Get.find<ConfigController>().config?.currencySymbol ?? '\$', '').replaceAll(' ', '').replaceAll(',', '');
            if(widget.fromPage == RiseFare.ride) {
              if(newFare.isEmpty){
                showCustomSnackBar('fare_amount_is_required'.tr);
              }else{
                rideController.setBidingAmount(newFare).then((value) {
                  rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
                    if(value.statusCode == 200){
                      rideController.updateRideCurrentState(RideState.findingRider);
                      Get.find<MapController>().notifyMapController();
                    }
                  });
                });
              }
            }else {
              rideController.setBidingAmount(newFare).then((value) {
                Get.find<ParcelController>().getSuggestedCategoryList().then((value) {
                  if(value.statusCode == 200){
                    Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.suggestVehicle);
                  }
                });
              });
            }
            Get.find<MapController>().notifyMapController();
          }),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          ButtonWidget(
            buttonText: 'cancel'.tr,
            transparent: true,
            borderWidth: 1,
            showBorder: true,
            radius: Dimensions.paddingSizeSmall,
            borderColor: Theme.of(Get.context!).primaryColor,
            onPressed: () {
                 if(widget.fromPage == RiseFare.ride) {
                   if(rideController.tripDetails == null){
                     Get.find<RideController>().updateRideCurrentState(RideState.initial);
                   }else{
                     Get.find<RideController>().updateRideCurrentState(RideState.findingRider);
                   }
                }else{
                  Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelInfoDetails);
                }
              Get.find<MapController>().notifyMapController();
            },
          )
        ]);
      });
    });
  }
}
