import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class OtpCarBikeAnimatedWidget extends StatefulWidget {
  const OtpCarBikeAnimatedWidget({super.key});

  @override
  State<OtpCarBikeAnimatedWidget> createState() => _OtpCarBikeAnimatedWidgetState();
}

class _OtpCarBikeAnimatedWidgetState extends State<OtpCarBikeAnimatedWidget> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<Offset> leftSlideAnimation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);

    leftSlideAnimation = Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease),
    );

    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 0.6),
      curve: Curves.ease,
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, widget) =>
         Center(child: Center(child: SlideTransition(
          position: leftSlideAnimation,
          child: SvgPicture.asset((Get.find<RideController>().tripDetails?.vehicleCategory?.type ?? 'car') == 'car' ? Images.animatedCar :
            Images.animatedBike,height: Get.height * 0.12,width: Get.width * 0.1,),
        ))),

    );
  }
}

