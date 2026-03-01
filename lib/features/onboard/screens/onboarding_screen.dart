import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/onboard/controllers/on_board_page_controller.dart';
import 'package:ride_sharing_user_app/features/onboard/widget/pager_content.dart';
import 'package:ride_sharing_user_app/localization/language_selection_screen.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  final Map<String,dynamic>? notificationData;
  final String? userName;
  const OnBoardingScreen({super.key, required this.notificationData, required this.userName});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with SingleTickerProviderStateMixin {
  late final PageController _pageController = PageController()..addListener(_handlePageChanged);
  late final ValueNotifier<int> _currentPage = ValueNotifier(0)..addListener(() => setState(() {}));

  late AnimationController _controller;
  late Animation _animation;

  final List<Widget> pages = AppConstants.onBoardPagerData.map((data) => PagerContent(
    image: data.image,
    text1: data.title1,
    text2: data.title2,
    text3: data.title3,
    text4: data.title4,
    index: AppConstants.onBoardPagerData.indexOf(data),
  )).toList();


  @override
  void initState() {

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free resources
    _pageController.dispose(); // Dispose PageController as well if not used elsewhere
    super.dispose();
  }



  void _handlePageChanged() {
    int newPage = _pageController.page?.round() ?? 0;
    _currentPage.value = newPage;
  }

  void _handleSemanticSwipe(int dir) {
    _pageController.animateToPage((_pageController.page ?? 0).round() + dir,
        duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: GetBuilder<OnBoardController>(builder: (onBoardController) {
            return Column(children: [
              Expanded(child: MergeSemantics(
                child: Semantics(
                  onIncrease: () => _handleSemanticSwipe(1),
                  onDecrease: () => _handleSemanticSwipe(-1),
                  child: Stack(children: [
                    if(onBoardController.pageIndex != 3)
                      Positioned(
                        bottom: 0,
                        child: SvgPicture.asset(Images.backgroundFrame, width: Get.width),
                      ),

                      if(onBoardController.pageIndex != 3) Positioned(bottom: 100, right: 0, left: -100, child: SizedBox(
                        width: 1200,
                        height: (onBoardController.pageIndex != 1 ? (Get.height * 0.2) : 0) + (300 * double.tryParse(_animation.value.toString())!),
                        child: SvgPicture.asset(
                            Images.splashSvgBackground,
                            alignment: onBoardController.pageIndex == 0
                                ? Alignment.centerLeft
                                : onBoardController.pageIndex == 1
                                ? Alignment.centerRight
                                : Alignment.center,
                        ),
                      )),

                      PageView(
                        controller: _pageController,
                        children: pages,
                        onPageChanged: (value) {
                          onBoardController.onPageChanged(value);
                          _controller.reset(); // Reset the animation to start over
                          _controller.forward(); // Start the animation
                        },
                      ),

                  ]),
                ),
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SizedBox(
                height: 20,
                child: ListView.separated(
                  itemCount: AppConstants.onBoardPagerData.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index){
                    return Container(
                        height: Dimensions.paddingSizeExtraSmall, width: Dimensions.paddingSizeExtraSmall,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == onBoardController.pageIndex ? Theme.of(context).primaryColor : Theme.of(context).hintColor
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index){
                    return const SizedBox(width: Dimensions.paddingSizeExtraSmall);
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: onBoardController.pageIndex == 3
                    ? _GetStartedButtonWidget(notificationData: widget.notificationData, userName: widget.userName)
                    : _NavigationButtonWidget(pageController: _pageController, notificationData: widget.notificationData, userName: widget.userName),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

            ]);
          }),
        ),
      ),
    );
  }

}

class _GetStartedButtonWidget extends StatelessWidget {
  final Map<String,dynamic>? notificationData;
  final String? userName;
  const _GetStartedButtonWidget({required this.notificationData, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ButtonWidget(
        textColor: Theme.of(context).cardColor,
        showBorder: true,
        radius: 100,
        borderColor: Theme.of(context).primaryColor.withValues(alpha:0.5),
        buttonText: 'get_started'.tr,
        onPressed: () {
          Get.find<ConfigController>().disableIntro();
          _checkNavigationRoute(notificationData, userName);
        },
      ),
    );
  }
}

void _checkNavigationRoute(Map<String,dynamic>? notificationData, String? userName){
  if(Get.find<LocalizationController>().haveLocalLanguageCode()){
    Get.offAll(() => const SignInScreen());
  }else{
    Get.offAll(()=> LanguageSelectionScreen(userName: userName, notificationData: notificationData));
  }
}


class _NavigationButtonWidget extends StatelessWidget {
  final Map<String,dynamic>? notificationData;
  final String? userName;
  final PageController pageController;
  const _NavigationButtonWidget({required this.pageController, required this.notificationData, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: Dimensions.paddingSizeExtraLarge),

      TextButton(
          onPressed: () {
            Get.find<ConfigController>().disableIntro();
            _checkNavigationRoute(notificationData, userName);
          },
          child: Text('skip'.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ),

      const Spacer(),

      InkWell(
        onTap: (){
           if (AppConstants.onBoardPagerData.length - 1 == Get.find<OnBoardController>().pageIndex) {
            Get.find<ConfigController>().disableIntro();
            _checkNavigationRoute(notificationData, userName);
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 3),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)
          ),
          child: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).cardColor),
        ),
      ),
      const SizedBox(width: Dimensions.paddingSizeExtraLarge),
    ]);
  }
}

