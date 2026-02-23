import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class OnBoardController extends GetxController  implements GetxService{
  int pageIndex = 0;

  void onPageChanged(int index){
    pageIndex = index;
    update();
  }

  void onPageIncrement(){
    if(AppConstants.onBoardPagerData.length-1>pageIndex){
      pageIndex++;
    }
    update();
  }
}