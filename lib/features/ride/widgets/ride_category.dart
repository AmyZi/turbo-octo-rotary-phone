import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/home/controllers/category_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/category_widget.dart';

class RideCategoryWidget extends StatelessWidget {
  final Function(void)? onTap;
  const RideCategoryWidget({super.key,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
        return GetBuilder<CategoryController>(builder: (categoryController) {
            return
              categoryController.categoryList != null ?
              categoryController.categoryList!.isNotEmpty ?
              SizedBox(height: 110, width: Get.width, child: ListView.builder(
                itemCount: categoryController.categoryList!.length,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                    child: CategoryWidget(index: index,
                      fromSelect: true,
                      category: categoryController.categoryList![index],
                      isSelected: rideController.rideCategoryIndex == index,onTap: onTap,
                    ),
                  );
                }
              )) :
              Center(child: Text('no_category_found'.tr)) :
              Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0));
          }
        );
      });
  }
}
