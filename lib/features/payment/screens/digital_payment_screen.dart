import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/animated_dialog_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/digital_payment_dialog.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/payment/screens/review_screen.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';

class DigitalPaymentScreen extends StatefulWidget {
  final String tripId;
  final String paymentMethod;
  final bool fromParcel;
  final String tips;
  const DigitalPaymentScreen({super.key,  required this.tripId, required this.paymentMethod,  this.fromParcel = false, required this.tips});

  @override
  DigitalPaymentScreenState createState() => DigitalPaymentScreenState();
}

class DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
  String? selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;


  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();

    selectedUrl = '${AppConstants.baseUrl}${AppConstants.digitalPayment}?trip_request_id=${widget.tripId}&payment_method=${widget.paymentMethod}&tips=${widget.tips}';
    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(context, widget.tripId, widget.fromParcel);
    final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(javaScriptEnabled: true, isInspectable: kDebugMode, useShouldOverrideUrlLoading: true, useOnLoadResource: true),
    );




    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl!)),
      settings: settings,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(canPop: false,
        onPopInvokedWithResult: (didPop, val) async {
          Get.off(() => const PaymentScreen(fromParcel: true));
          return ;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text(''),backgroundColor: Theme.of(context).cardColor),
          body: Center(child: _isLoading ? SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,) : const SizedBox.shrink()),
        ),
      ),
    );
  }

}

class MyInAppBrowser extends InAppBrowser {
  final bool fromParcel;
  final String tripId;
  final BuildContext context;

  MyInAppBrowser(this.context, this.tripId, this.fromParcel, {
    super.windowId,
    super.initialUserScripts,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      Get.back();


      animatedDialogWidget(context, DigitalPaymentDialog(
        icon: Icons.clear,
        title: 'payment_failed'.tr,
        description: 'your_payment_failed'.tr,
        isFailed: true,
      ), dismissible: false, isFlip: true);
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }





  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    if(_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl);
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);
      if(isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
      if(isSuccess){
        if(fromParcel){
          Get.find<RideController>().updateRideCurrentState(RideState.afterAcceptRider);
          Get.find<RideController>().getRideDetails(tripId).then((value){
            Get.offAll(() => const MapScreen(fromScreen: MapScreenType.parcel));
          });
        }else {
          if(Get.find<ConfigController>().config!.reviewStatus!){
            Get.offAll(()=> ReviewScreen(tripId: tripId));

          }else{
            Get.find<RideController>().clearRideDetails();
            Get.offAll(()=> const DashboardScreen());
          }

        }
        animatedDialogWidget(context, DigitalPaymentDialog(
          icon: Icons.done,
          title: 'payment_done'.tr,
          description: 'your_payment_successfully_done'.tr,
        ), dismissible: false, isFlip: true);
      }else if(isFailed) {
        Get.back();
        animatedDialogWidget(context, DigitalPaymentDialog(
          icon: Icons.clear,
          title: 'payment_failed'.tr,
          description: 'your_payment_failed'.tr,
          isFailed: true,
        ), dismissible: false, isFlip: true);
      }else if(isCancel) {
        Get.back();
        animatedDialogWidget(context, DigitalPaymentDialog(
          icon: Icons.clear,
          title: 'payment_cancelled'.tr,
          description: 'your_payment_cancelled'.tr,
          isFailed: true,
        ), dismissible: false, isFlip: true);
      }
    }
  }
}