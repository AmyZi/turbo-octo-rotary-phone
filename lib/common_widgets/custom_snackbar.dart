import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

void customSnackBar(String? message, {bool isError = true, double margin = Dimensions.paddingSizeSmall}) {
  if(message != null && message.isNotEmpty) {
    ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    Get.showSnackbar(GetSnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      message: message,
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.only(
          top: Dimensions.paddingSizeSmall,
          left: Dimensions.paddingSizeSmall,
          right: Dimensions.paddingSizeSmall,
          bottom: margin),
      borderRadius: Dimensions.radiusSmall,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}