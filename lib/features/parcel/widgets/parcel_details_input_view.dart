import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_category_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/test_field_title.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelDetailInputView extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelDetailInputView({super.key, required this.expandableKey});

  @override
  State<ParcelDetailInputView> createState() => _ParcelDetailInputViewState();
}
class _ParcelDetailInputViewState extends State<ParcelDetailInputView> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: GetBuilder<ParcelController>(builder: (parcelController){
        return GetBuilder<RideController>(builder: (rideController) {
          return Stack(clipBehavior: Clip.none, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  const ParcelCategoryView(isDetails: true),

                  TextFieldTitle(title: 'parcel_weight'.tr, textOpacity: 0.8),

                  CustomTextField(
                    prefixIcon: Images.editProfilePhone,
                    borderRadius: 50,
                    showBorder: true,
                    hintText: '${'parcel_weight_hint'.tr} ${Get.find<ConfigController>().config?.parcelWeightUnit}',
                    fillColor:
                    _showErrorWeightCapacity() ?
                    Theme.of(context).colorScheme.error.withValues(alpha:0.04) :
                    Get.isDarkMode ?
                    Theme.of(context).cardColor :
                    Theme.of(context).primaryColor.withValues(alpha:0.04),
                    controller: parcelController.parcelWeightController,
                    focusNode: parcelController.parcelWeightNode,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.done,
                    isAmount: true,
                    prefix: false,
                    onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey),
                    focusBorderColor: _showErrorWeightCapacity() ?
                    Theme.of(context).colorScheme.error :
                    null,
                    onChanged: (_){
                      _showErrorWeightCapacity();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(_showErrorWeightCapacity())
                  Align(alignment: Alignment.centerRight, child: Text(
                      'Max Capacity ${Get.find<ConfigController>().config?.maximumParcelWeightCapacity} Kg',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).colorScheme.error),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  rideController.isEstimate ?
                  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                  ButtonWidget(
                    buttonText: "save_details".tr,
                    backgroundColor: _showErrorWeightCapacity() ? Theme.of(context).hintColor : null,
                    onPressed: () {
                      if(parcelController.parcelWeightController.text.trim().isEmpty) {
                        FocusScope.of(context).requestFocus(parcelController.parcelWeightNode);
                        parcelController.focusOnBottomSheet(widget.expandableKey);
                        showCustomSnackBar('parcel_weight_is_required'.tr);
                      }else if(_showErrorWeightCapacity()){
                        setState(() {});
                      }else{
                        rideController.getEstimatedFare(true).then((value) {
                          if(value.statusCode == 200) {
                            parcelController.updateParcelState(ParcelDeliveryState.parcelInfoDetails);
                            parcelController.updateParcelDetailsStatus();
                          }
                        });
                      }
                    },
                  ),

                ]),

            Positioned(right: 0, child: Align(
              child: InkWell(
                onTap: () => parcelController.updateParcelState(ParcelDeliveryState.initial),
                child: Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).primaryColorDark : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.keyboard_backspace, color: Theme.of(context).hintColor),
                    ),
                ),
              ),
            )),
          ]);
        });
      }),
    );
  }

  bool _showErrorWeightCapacity(){
    if(Get.find<ConfigController>().config?.maximumParcelWeightStatus ?? false){
      if((Get.find<ConfigController>().config?.maximumParcelWeightCapacity ?? 0) < (double.tryParse(Get.find<ParcelController>().parcelWeightController.text.trim()) ?? 0)){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
}
