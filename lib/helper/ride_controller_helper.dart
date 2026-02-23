import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';

class RideControllerHelper{

  static DateTime dateFormatToShow(String? date){
    return DateFormat('yyyy-MM-dd').parse(
      date ?? DateTime.now().add(Duration(seconds: Get.find<ConfigController>().config?.minimumScheduleBookTime ?? 0)).toString(),
    );
  }

  static DateTime timeFormatToShow(DateTime? time){
    return time ?? DateTime.now().add(Duration(seconds: Get.find<ConfigController>().config?.minimumScheduleBookTime  ?? 0));
  }


}