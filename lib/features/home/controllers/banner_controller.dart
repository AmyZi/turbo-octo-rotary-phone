import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/home/domain/models/banner_model.dart';
import 'package:ride_sharing_user_app/features/home/domain/repositories/banner_repo.dart';


class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});


  int? _currentIndex = 0;
  int? get currentIndex => _currentIndex;
  bool isLoading = false;
  List<Banner>? bannerList;


  @override
  void onInit() {
    super.onInit();
    getBannerList();
  }

  Future<void> getBannerList() async {
    isLoading = true;
    Response? response = await bannerRepo.getBannerList();
    if(response!.statusCode == 200){
      bannerList = [];
      isLoading = false;
      bannerList!.addAll(BannerModel.fromJson(response.body).data!);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();

  }

  Future<void> updateBannerClickCount( String bannerId) async {
    Response? response = await bannerRepo.updateBannerClickCount(bannerId);
    if(response!.statusCode == 200){

    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}
