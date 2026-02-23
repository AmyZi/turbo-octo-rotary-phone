import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/home/domain/models/categoty_model.dart';
import 'package:ride_sharing_user_app/features/home/domain/repositories/category_repo.dart';


class CategoryController extends GetxController implements GetxService{
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  int couponFilterIndex = 0;
  List<Category>? categoryList;
  bool isLoading = false;

  Future<void> getCategoryList() async {
    Response? response = await categoryRepo.getCategoryList();
    if(response!.statusCode == 200 && response.body['data'] != null) {
      categoryList = [];
      categoryList!.addAll(CategoryModel.fromJson(response.body).data!);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }


  void setCouponFilterIndex(int index, {bool isUpdate= true}){
    couponFilterIndex = index;
    Get.find<CouponController>().getCouponList(1, isUpdate: isUpdate);

    if(isUpdate){
      update();
    }
  }

}
