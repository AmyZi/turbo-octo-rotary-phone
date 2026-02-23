import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/home/controllers/banner_controller.dart';
import 'package:ride_sharing_user_app/features/home/widgets/banner_shimmer.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerView extends StatefulWidget {
  const BannerView({super.key});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    String baseurl = Get.find<ConfigController>().config!.imageBaseUrl!.banner!;
    return GetBuilder<BannerController>(
      builder: (bannerController) {

        return  bannerController.bannerList != null? bannerController.bannerList!.isNotEmpty?
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 130, width: MediaQuery.of(context).size.width,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  disableCenter: true,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    activeIndex = index;
                    setState(() {
                    });
                  },
                ),
                itemCount: bannerController.bannerList!.length,
                itemBuilder: (context, index, _) {
                  return InkWell(onTap: (){
                    bannerController.updateBannerClickCount(bannerController.bannerList![index].id!);
                    debugPrint("=click===> ${bannerController.bannerList![index].redirectLink!}");
                    if(bannerController.bannerList![index].redirectLink != null){
                      _launchUrl(Uri.parse(bannerController.bannerList![index].redirectLink!));
                    }},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                        child: ImageWidget(image: '$baseurl/${bannerController.bannerList![index].image}', fit: BoxFit.cover)),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
          SizedBox(height: 5,width: Get.width,
            child: Center(child: ListView.separated(shrinkWrap: true,padding: EdgeInsets.zero,scrollDirection: Axis.horizontal,
              itemCount: bannerController.bannerList!.length,itemBuilder: (context,index){
                return Center(child: Container(height: 5,width: index == activeIndex ? 10 : 5,decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100)
                ),));},

              separatorBuilder: (context,index){
                return const Padding(padding: EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall));
              },
            ),
            ),)
          ],
        ):const SizedBox() : const BannerShimmer();
      },
    );
  }


}
Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}