import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/models/parcel_category_model.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/models/parcel_list_model.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/models/suggested_vehicle_category_model.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/services/parcel_service_interface.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';

enum ParcelDeliveryState{initial, parcelInfoDetails, addOtherParcelDetails, riseFare, findingRider, suggestVehicle, acceptRider, otpSent, parcelOngoing, parcelComplete}

class ParcelController extends GetxController with GetSingleTickerProviderStateMixin implements GetxService {
  final ParcelServiceInterface parcelServiceInterface;
  ParcelController({required this.parcelServiceInterface});

  ParcelDeliveryState currentParcelState = ParcelDeliveryState.initial;
  late TabController tabController = TabController(length: 2, vsync: this);
  bool isLoading = false;
  bool parcelDetailsAvailable = false;
  int selectedParcelCategory = 0;
  bool payReceiver = false;
  SuggestedVehicleCategoryModel? suggestedVehicleCategoryModel;
  List<SuggestedCategory>? suggestedCategoryList;
  List<ParcelCategory>? parcelCategoryList;
  bool getSuggested = false;

  TextEditingController senderContactController = TextEditingController();
  TextEditingController senderNameController = TextEditingController();
  TextEditingController senderAddressController = TextEditingController();

  TextEditingController receiverContactController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverAddressController = TextEditingController();

  TextEditingController parcelDimensionController = TextEditingController();
  TextEditingController parcelWeightController = TextEditingController();
  TextEditingController parcelTypeController = TextEditingController();

  FocusNode senderContactNode = FocusNode();
  FocusNode senderNameNode = FocusNode();
  FocusNode senderAddressNode = FocusNode();

  FocusNode receiverContactNode = FocusNode();
  FocusNode receiverNameNode = FocusNode();
  FocusNode receiverAddressNode = FocusNode();

  FocusNode parcelDimensionNode = FocusNode();
  FocusNode parcelWeightNode = FocusNode();

  String? _senderCountryDialCode;
  String? _receiverCountryDialCode;

  String? get getSenderCountryCode => _senderCountryDialCode;
  String? get getReceiverCountryDialCode => _receiverCountryDialCode;

  String? get getSenderContactNumber => '$_senderCountryDialCode${senderContactController.text}';
  String? get getReceiverContactNumber => '$_receiverCountryDialCode${receiverContactController.text}';

  void onChangeSenderCountryCode(String? code, {bool isUpdate = true}) {
    _senderCountryDialCode = code;

    if(isUpdate) {
      update();
    }
  }
  void onChangeReceiverCountryCode(String? code) {
    _receiverCountryDialCode = code;
    update();
  }


  void initParcelData() {
    payReceiver = false;
    currentParcelState = ParcelDeliveryState.initial;
    tabController.index = 0;
    isLoading = false;
    parcelDetailsAvailable = false;
    getSuggested = false;
    selectedParcelCategory = 0;
    senderAddressController.text = '';
    senderContactController.text = '';
    senderNameController.text = '';
    receiverAddressController.text = '';
    receiverContactController.text = '';
    receiverNameController.text = '';
  }

  void updateParcelCategoryIndex(int newIndex) {
    selectedParcelCategory = newIndex;
    parcelTypeController.text = parcelCategoryList![selectedParcelCategory].name!;
    update();
  }

  void updateTabControllerIndex(int newIndex){
    tabController.index= newIndex;
    update();
  }

  void updateParcelDetailsStatus() {
    if(parcelWeightController.text.isNotEmpty && parcelDimensionController.text.isNotEmpty) {
      parcelDetailsAvailable = true;
    }else {
      parcelDetailsAvailable = false;
    }
    update();
  }

  void updateParcelState(ParcelDeliveryState newState) {
    currentParcelState = newState;
    update();
  }

  void updatePaymentPerson(bool newValue, {bool notify = true}) {
    payReceiver = newValue;
    if(newValue == true){
      Get.find<PaymentController>().setPaymentType(0);
    }
    if(notify){
      update();
    }

  }


  String parcelPrice = '0';

  Future<void> getParcelCategoryList({bool notify= true}) async {
    isLoading = true;
    Response response = await parcelServiceInterface.getParcelCategory();
    if(response.statusCode == 200 && response.body['data'] != null){
      parcelCategoryList = [];
      isLoading = false;
      parcelCategoryList!.addAll(ParcelCategoryModel.fromJson(response.body).data!);
      if(parcelCategoryList!.isNotEmpty) {
        parcelTypeController.text = parcelCategoryList!.first.name!;
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    if(notify){
      update();
    }
  }

  Future<Response> getSuggestedCategoryList() async {
    getSuggested = true;
    update();
    Response response = await parcelServiceInterface.getSuggestedVehicleCategory(parcelWeightController.text);
    if(response.statusCode == 200 ){
      suggestedCategoryList = [];
      isLoading = false;
      if(response.body['data'] != null){
        suggestedVehicleCategoryModel = SuggestedVehicleCategoryModel.fromJson(response.body);
        suggestedCategoryList!.addAll(SuggestedVehicleCategoryModel.fromJson(response.body).data!.data!);
      }
    }else{
      getSuggested = false;
      ApiChecker.checkApi(response);
    }
    getSuggested = false;
    update();
    return response;
  }


  ParcelListModel? parcelListModel;
  Future<Response> getRunningParcelList() async {
    isLoading = true;
    Response response = await parcelServiceInterface.getRunningParcelList(1);
    if(response.statusCode == 200 ){
      isLoading = false;
      if(response.body['data'] != null){
        parcelListModel = ParcelListModel.fromJson(response.body);
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  void clearParcelModel(){
    parcelListModel = null;
  }

  ParcelListModel? unpaidParcelListModel;
  Future<Response> getUnpaidParcelList() async {
    isLoading = true;
    Response response = await parcelServiceInterface.getUnpaidParcelList(1);
    if(response.statusCode == 200 ){
      isLoading = false;
      if(response.body['data'] != null){
        unpaidParcelListModel = ParcelListModel.fromJson(response.body);
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }


  Future<void> focusOnBottomSheet(GlobalKey<ExpandableBottomSheetState> key) async {
    if(key.currentState?.expansionStatus == ExpansionStatus.expanded) {
      // ignore: invalid_use_of_protected_member
      key.currentState?.reassemble();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    key.currentState?.expand(duration: 200);
  }

  void setParcelLoadingActive (int index){
    parcelListModel!.data![index].isLoading = true;
    update();
  }
  void setParcelLoadingDeactive (int index){
    parcelListModel!.data![index].isLoading = false;
    update();
  }

}