import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/features/address/screens/add_new_address.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<AddressController>().getAddressList(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(

          appBar:AppBar(title: Text('my_address'.tr, style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Colors.white), maxLines: 1,textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              toolbarHeight: 90,
              automaticallyImplyLeading: false,
              excludeHeaderSemantics: true,
              titleSpacing: 0,
              leading: IconButton(icon: const Icon(Icons.arrow_back),
                color: Colors.white, onPressed: () => Get.back(),),),


          body: Container(height: Get.height,
              width: Dimensions.webMaxWidth,
              decoration:  BoxDecoration(borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                  color: Theme.of(context).cardColor),
            child: GetBuilder<AddressController>(builder: (addressController) {
              return addressController.addressList != null ? addressController.addressList!.isNotEmpty ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.78,
                    child: ListView.builder(
                      itemCount: addressController.addressList!.length,
                      shrinkWrap: true,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => AddressCard(address: addressController.addressList![index]),
                    ),
                  ),
                ],
              ) : const NoDataWidget(title: 'no_address_found',) : Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,));
            }),
          ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).cardColor,
          child: Icon(Icons.add_circle, color: Theme.of(context).primaryColor,size: Dimensions.iconSizeExtraLarge,),
          onPressed: () {
            Get.to(() =>  const AddNewAddress());
          }
        ),

      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, 0),
      child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.25))),
        child: Padding(padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.5))),
              child: Padding(padding: const EdgeInsets.all(8.0),
                child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(
                  address.addressLabel == 'home' ? Images.homeIcon : address.addressLabel == 'office'
                      ? Images.workIcon: Images.otherIcon,
                  color: Get.find<ThemeController>().darkTheme ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                )),
              ),
            ),

            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(address.addressLabel!.tr,
                  style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                Text(address.address!),
              ]),
            )),

            InkWell(
              onTap: ()=> Get.to(() =>  AddNewAddress(address: address)),
              child: SizedBox(width: Dimensions.iconSizeLarge,
                child: Image.asset(Images.editIcon)),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            InkWell(onTap: () {
              Get.bottomSheet(ConfirmationBottomsheetWidget(
                icon: Images.completeIcon,
                title: 'delete_address'.tr,
                description: 'are_you_sure_you_want_to_delete_address'.tr,
                iconColor: Theme.of(context).cardColor,
                onYesPressed: (){
                  Get.find<AddressController>().deleteAddress(address.id.toString());
                },
                onNoPressed: ()=> Get.back(),
              ));

            },
              child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.delete))),

          ]),
        ),
      ),
    );
  }
}
