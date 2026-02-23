import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class DigitalAddFundScreen extends StatefulWidget {
  final String paymentMethod;
  final double totalAmount;
  const DigitalAddFundScreen({super.key, required this.paymentMethod, required this.totalAmount});

  @override
  State<DigitalAddFundScreen> createState() => _DigitalAddFundScreenState();
}

class _DigitalAddFundScreenState extends State<DigitalAddFundScreen> {
  String? selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;


  PullToRefreshController? pullToRefreshController;
  late AddFundInAppBrowser browser;

  @override
  void initState() {
    super.initState();

    selectedUrl = '${AppConstants.baseUrl}${AppConstants.digitalAddFund}?user_id=${Get.find<ProfileController>().profileModel?.data?.id}&amount=${widget.totalAmount}&payment_method=${widget.paymentMethod}';
    _initData();
  }

  void _initData() async {
    browser = AddFundInAppBrowser(context);
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
      child: Scaffold(
        appBar: AppBar(title: const Text(''),backgroundColor: Theme.of(context).cardColor),
        body: Center(child: _isLoading ? SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,) : const SizedBox.shrink()),
      ),
    );
  }
}


class AddFundInAppBrowser extends InAppBrowser {
  final BuildContext context;

  AddFundInAppBrowser(this.context,  {
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

      Future.delayed(Duration(microseconds: 500)).then((_){
        showCustomSnackBar('${'transaction_failed'.tr} !');
      });
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
      bool isGatewayInactive = url.contains('gateway-inactive');
      if(isSuccess || isFailed || isCancel || isGatewayInactive) {
        _canRedirect = false;
        close();
      }
      if(isSuccess){
        Get.back();
        showCustomSnackBar('${'add_fund_successfully'.tr} !', isError: false);
        Get.find<ProfileController>().getProfileInfo();
        Get.find<WalletController>().getTransactionList(1);
      }else if(isFailed) {
        Get.back();
        Future.delayed(Duration(microseconds: 500)).then((_){
          showCustomSnackBar('${'transaction_failed'.tr} !');
        });

      }else if(isCancel) {
        Get.back();
        Future.delayed(Duration(microseconds: 500)).then((_){
          showCustomSnackBar('${'transaction_failed'.tr} !');
        });

      }else if(isGatewayInactive) {
        Get.back();
        Get.find<PaymentController>().getPaymentGetWayList();
        Future.delayed(Duration(microseconds: 500)).then((_){
          showCustomSnackBar('${'something_went_wrong_please_try_again'.tr} !');
        });

      }
    }
  }
}