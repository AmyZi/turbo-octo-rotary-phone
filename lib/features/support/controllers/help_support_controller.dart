import 'package:get/get.dart';

class HelpSupportController extends GetxController implements GetxService{
  List<String> helpAndSupportTabs = ['help_support','terms_and_policy'];
  int currentTabIndex = 0;

  void updateCurrentTabIndex(int index, {bool isUpdate = false}){
    currentTabIndex = index;
    if(isUpdate){
      update();
    }
  }
}