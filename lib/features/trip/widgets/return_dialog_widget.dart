import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReturnDialogWidget extends StatelessWidget {
  const ReturnDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        surfaceTintColor: Theme.of(context).cardColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
        child: Container(
          padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(onTap: ()=> Get.back(), child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(
                    Images.crossIcon,
                    height: Dimensions.paddingSizeSmall,
                    width: Dimensions.paddingSizeSmall,
                    color: Theme.of(context).cardColor,
                  ),
                )),
              ),
              
              Image.asset(Images.parcelReturnSuccessIcon,height: 80,width: 80),

              Text('your_parcel_returned_successfully'.tr,style: textBold),

            ],
          ),
        )
    );
  }
}
