import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/login_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';


class SplashScreen extends StatefulWidget {
  final Map<String,dynamic>? notificationData;
  final String? userName;
  const SplashScreen({super.key, this.notificationData, this.userName});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;
  late AnimationController _controller;
  late Animation _animation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });


    _controller.repeat(max: 1);
    _controller.forward();

    Get.find<ConfigController>().initSharedData();

    _checkConnectivity();
  }

  void _checkConnectivity(){
    bool isFirst = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);
      if(!isFirst || !isConnected) {
        ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(
            isConnected ? 'connected'.tr : 'no_connection'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(isConnected) {
          LoginHelper().handleIncomingLinks(widget.notificationData, widget.userName);

        }
      }else{
        ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        LoginHelper().handleIncomingLinks(widget.notificationData, widget.userName);
      }
      isFirst = false;
    });
  }



  @override
  void dispose() {
    _controller.dispose();
    _onConnectivityChanged?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        alignment: Alignment.bottomCenter,
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [

          Stack(alignment: AlignmentDirectional.bottomCenter, children: [

            Container(
              transform: Matrix4.translationValues(0, 320 - (320 * double.tryParse(_animation.value.toString())!), 0),
              child: Column(children: [
                Opacity(
                  opacity: _animation.value,
                  child: Padding(
                    padding: EdgeInsets.only(left: 120 - ((120 * double.tryParse(_animation.value.toString())!))),
                    child: SvgPicture.asset(Images.splashSvgLogo),
                  ),
                ),
                SizedBox(height: Get.height * 0.25),
                
                SvgPicture.asset(Images.splashSvgBackground)
              ]),
            ),

          ]),

        ]),
      ),
    );
  }
}
