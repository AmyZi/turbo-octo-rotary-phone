import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/helper/country_code_helper.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/test_field_title.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/domain/models/prediction_model.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelInfoWidget extends StatefulWidget {
  final bool isSender;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelInfoWidget(
      {super.key, required this.isSender, required this.expandableKey});

  @override
  State<ParcelInfoWidget> createState() => _ParcelInfoWidgetState();
}

class _ParcelInfoWidgetState extends State<ParcelInfoWidget> {
  // ── Inline search state (shared pattern for sender & receiver) ────────────
  final TextEditingController _senderSearchController = TextEditingController();
  final TextEditingController _receiverSearchController = TextEditingController();
  final FocusNode _senderSearchFocus = FocusNode();
  final FocusNode _receiverSearchFocus = FocusNode();

  List<Suggestions> _senderSuggestions = [];
  List<Suggestions> _receiverSuggestions = [];

  bool _showSenderDropdown = false;
  bool _showReceiverDropdown = false;

  bool _searchingSender = false;
  bool _searchingReceiver = false;

  // FEATURE: track whether address was confirmed via dropdown (required for map sync)
  // These are local flags — validation also checks LocationController as fallback
  bool _senderAddressConfirmed = false;
  bool _receiverAddressConfirmed = false;
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final parcelController = Get.find<ParcelController>();

    if (widget.isSender) {
      // Pre-fill phone and name from profile
      final phone = Get.find<ProfileController>().profileModel?.data?.phone;
      if (phone != null) {
        parcelController.onChangeSenderCountryCode(
            CountryCodeHelper.getCountryCode(phone), isUpdate: false);
      }
      parcelController.senderContactController.text =
          phone?.replaceAll(parcelController.getSenderCountryCode ?? '', '') ?? '';
      parcelController.senderNameController.text =
          Get.find<ProfileController>().customerName();

      // FEATURE: auto-fetch current location and pre-fill sender address with coordinates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final loc = Get.find<LocationController>();
        final currentAddress = loc.fromAddress;
        final addr = currentAddress?.address ?? loc.address;

        if (addr.isNotEmpty && parcelController.senderAddressController.text.isEmpty) {
          setState(() {
            _senderSearchController.text = addr;
            parcelController.senderAddressController.text = addr;
            if (currentAddress != null) {
              loc.setSenderAddress(currentAddress);
              _senderAddressConfirmed = true;
            }
          });
          parcelController.update();
        }

        // Restore existing confirmed state if user navigated back
        if (parcelController.senderAddressController.text.isNotEmpty) {
          setState(() {
            _senderSearchController.text = parcelController.senderAddressController.text;
            if (loc.parcelSenderAddress != null) {
              _senderAddressConfirmed = true;
            }
          });
        }
      });
    } else {
      // Restore receiver field if already set
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final loc = Get.find<LocationController>();
        if (parcelController.receiverAddressController.text.isNotEmpty) {
          setState(() {
            _receiverSearchController.text = parcelController.receiverAddressController.text;
            if (loc.parcelReceiverAddress != null) {
              _receiverAddressConfirmed = true;
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _senderSearchController.dispose();
    _receiverSearchController.dispose();
    _senderSearchFocus.dispose();
    _receiverSearchFocus.dispose();
    super.dispose();
  }

  // ── Search handlers ───────────────────────────────────────────────────────

  Future<void> _onSenderSearchChanged(String text) async {
    final parcelController = Get.find<ParcelController>();
    parcelController.senderAddressController.text = text;
    _senderAddressConfirmed = false;

    if (text.isEmpty) {
      setState(() { _senderSuggestions = []; _showSenderDropdown = false; });
      return;
    }
    setState(() => _searchingSender = true);
    final results = await Get.find<LocationController>()
        .searchLocation(context, text, type: LocationType.senderLocation);
    if (mounted) {
      setState(() {
        _senderSuggestions = results ?? [];
        _showSenderDropdown = _senderSuggestions.isNotEmpty;
        _searchingSender = false;
      });
    }
  }

  Future<void> _onReceiverSearchChanged(String text) async {
    final parcelController = Get.find<ParcelController>();
    parcelController.receiverAddressController.text = text;
    _receiverAddressConfirmed = false;

    if (text.isEmpty) {
      setState(() { _receiverSuggestions = []; _showReceiverDropdown = false; });
      return;
    }
    setState(() => _searchingReceiver = true);
    final results = await Get.find<LocationController>()
        .searchLocation(context, text, type: LocationType.receiverLocation);
    if (mounted) {
      setState(() {
        _receiverSuggestions = results ?? [];
        _showReceiverDropdown = _receiverSuggestions.isNotEmpty;
        _searchingReceiver = false;
      });
    }
  }

  Future<void> _onSenderSuggestionTap(Suggestions suggestion) async {
    final loc = Get.find<LocationController>();
    final parcelController = Get.find<ParcelController>();
    final placeId = suggestion.placePrediction?.placeId ?? '';
    final description = suggestion.placePrediction?.text?.text ?? '';

    setState(() { _showSenderDropdown = false; _searchingSender = true; });
    _senderSearchFocus.unfocus();

    final address = await loc.setLocation(placeId, description, null,
        type: LocationType.senderLocation, fromSearch: true);

    if (address != null) {
      loc.setSenderAddress(address);
      parcelController.senderAddressController.text = description;
      _senderSearchController.text = description;
      _senderAddressConfirmed = true;
      parcelController.update();
    }
    if (mounted) setState(() => _searchingSender = false);
  }

  Future<void> _onReceiverSuggestionTap(Suggestions suggestion) async {
    final loc = Get.find<LocationController>();
    final parcelController = Get.find<ParcelController>();
    final placeId = suggestion.placePrediction?.placeId ?? '';
    final description = suggestion.placePrediction?.text?.text ?? '';

    setState(() { _showReceiverDropdown = false; _searchingReceiver = true; });
    _receiverSearchFocus.unfocus();

    final address = await loc.setLocation(placeId, description, null,
        type: LocationType.receiverLocation, fromSearch: true);

    if (address != null) {
      loc.setReceiverAddress(address);
      parcelController.receiverAddressController.text = description;
      _receiverSearchController.text = description;
      _receiverAddressConfirmed = true;
      parcelController.update();
    }
    if (mounted) setState(() => _searchingReceiver = false);
  }

  // ── Helper: check if sender address has valid coordinates ─────────────────
  bool _isSenderAddressValid() {
    return _senderAddressConfirmed ||
        Get.find<LocationController>().parcelSenderAddress != null;
  }

  // ── Helper: check if receiver address has valid coordinates ───────────────
  bool _isReceiverAddressValid() {
    return _receiverAddressConfirmed ||
        Get.find<LocationController>().parcelReceiverAddress != null;
  }

  Widget _buildInlineSearchField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isSearching,
    required bool showDropdown,
    required List<Suggestions> suggestions,
    required Function(String) onChanged,
    required Function(Suggestions) onSuggestionTap,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Theme.of(context).cardColor
              : Theme.of(context).primaryColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: textRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          decoration: InputDecoration(
            hintText: 'search_location'.tr,
            hintStyle: textRegular.copyWith(
              color: Theme.of(context).hintColor,
              fontSize: Dimensions.fontSizeDefault,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeDefault,
            ),
            suffixIcon: isSearching
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Image.asset(Images.location, width: 20, height: 20,
                    color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      if (showDropdown)
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final s = suggestions[index];
              final text = s.placePrediction?.text?.text ?? '';
              return InkWell(
                onTap: () => onSuggestionTap(s),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  child: Row(children: [
                    Icon(Icons.location_on_outlined, size: 18,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(
                        text,
                        style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Contact ────────────────────────────────────────────────────────
          TextFieldTitle(title: 'contact'.tr, textOpacity: 0.8),
          CustomTextField(
            isCodePicker: true,
            isCodePickerFillColor: false,
            borderRadius: 10,
            showBorder: false,
            hintText: 'contact_number'.tr,
            fillColor: Get.isDarkMode
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor.withValues(alpha: 0.04),
            controller: widget.isSender
                ? parcelController.senderContactController
                : parcelController.receiverContactController,
            focusNode: widget.isSender
                ? parcelController.senderContactNode
                : parcelController.receiverContactNode,
            nextFocus: widget.isSender
                ? parcelController.senderNameNode
                : parcelController.receiverNameNode,
            inputType: TextInputType.phone,
            countryDialCode: widget.isSender
                ? parcelController.getSenderCountryCode
                : parcelController.getReceiverCountryDialCode,
            onCountryChanged: (CountryCode countryCode) {
              widget.isSender
                  ? parcelController.onChangeSenderCountryCode(countryCode.dialCode)
                  : parcelController.onChangeReceiverCountryCode(countryCode.dialCode);
            },
          ),

          // ── Name ──────────────────────────────────────────────────────────
          TextFieldTitle(title: 'name'.tr, textOpacity: 0.8),
          CustomTextField(
            prefixIcon: Images.editProfilePhone,
            borderRadius: 10,
            showBorder: false,
            prefix: false,
            capitalization: TextCapitalization.words,
            hintText: 'name'.tr,
            fillColor: Get.isDarkMode
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor.withValues(alpha: 0.04),
            controller: widget.isSender
                ? parcelController.senderNameController
                : parcelController.receiverNameController,
            focusNode: widget.isSender
                ? parcelController.senderNameNode
                : parcelController.receiverNameNode,
            nextFocus: widget.isSender
                ? parcelController.senderAddressNode
                : parcelController.receiverAddressNode,
            inputType: TextInputType.text,
            onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey),
          ),

          // ── Address (inline search for both sender & receiver) ─────────────
          TextFieldTitle(title: 'address'.tr, textOpacity: 0.8),
          widget.isSender
              ? _buildInlineSearchField(
                  context: context,
                  controller: _senderSearchController,
                  focusNode: _senderSearchFocus,
                  isSearching: _searchingSender,
                  showDropdown: _showSenderDropdown,
                  suggestions: _senderSuggestions,
                  onChanged: _onSenderSearchChanged,
                  onSuggestionTap: _onSenderSuggestionTap,
                )
              : _buildInlineSearchField(
                  context: context,
                  controller: _receiverSearchController,
                  focusNode: _receiverSearchFocus,
                  isSearching: _searchingReceiver,
                  showDropdown: _showReceiverDropdown,
                  suggestions: _receiverSuggestions,
                  onChanged: _onReceiverSearchChanged,
                  onSuggestionTap: _onReceiverSuggestionTap,
                ),

          // ── Saved addresses ────────────────────────────────────────────────
          if (Get.find<AddressController>().addressList?.isNotEmpty ?? false)
            TextFieldTitle(title: 'saved_address'.tr, textOpacity: 0.8),

          GetBuilder<AddressController>(builder: (addressController) {
            if (addressController.addressList == null ||
                addressController.addressList!.isEmpty) {
              return const SizedBox(height: Dimensions.paddingSizeSmall);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: SizedBox(
                height: Get.width * 0.075,
                child: ListView.builder(
                  itemCount: addressController.addressList!.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final saved = addressController.addressList![index];
                    return InkWell(
                      onTap: () {
                        final loc = Get.find<LocationController>();
                        loc.getZone(saved.latitude.toString(),
                            saved.longitude.toString()).then((value) {
                          if (value.isSuccess) {
                            if (widget.isSender) {
                              loc.setSenderAddress(saved);
                              _senderSearchController.text = saved.address ?? '';
                              parcelController.senderAddressController.text = saved.address ?? '';
                              setState(() => _senderAddressConfirmed = true);
                            } else {
                              loc.setReceiverAddress(saved);
                              _receiverSearchController.text = saved.address ?? '';
                              parcelController.receiverAddressController.text = saved.address ?? '';
                              setState(() => _receiverAddressConfirmed = true);
                            }
                          } else {
                            showCustomSnackBar('service_not_available_in_this_area'.tr);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Theme.of(context).hintColor
                                : Theme.of(context).primaryColor.withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Image.asset(
                            saved.addressLabel == 'home'
                                ? Images.homeIcon
                                : saved.addressLabel == 'office'
                                    ? Images.workIcon
                                    : Images.otherIcon,
                            color: Get.find<ThemeController>().darkTheme
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).hintColor,
                            height: 16, width: 16,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Text(saved.addressLabel!.tr, style: textBold),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            );
          }),

          // ── Next button ────────────────────────────────────────────────────
          ButtonWidget(
            buttonText: 'next'.tr,
            onPressed: () {
              final isSenderTab = parcelController.tabController.index == 0;

              if (isSenderTab) {
                final senderNumber = PhoneNumber.parse(
                    '${parcelController.getSenderCountryCode}${parcelController.senderContactController.text}');

                if (parcelController.senderContactController.text.isEmpty) {
                  showCustomSnackBar('enter_sender_contact_number'.tr);
                  FocusScope.of(context).requestFocus(parcelController.senderContactNode);
                } else if (!senderNumber.isValid(type: PhoneNumberType.mobile)) {
                  showCustomSnackBar('enter_valid_contact_number'.tr);
                  FocusScope.of(context).requestFocus(parcelController.senderContactNode);
                } else if (parcelController.senderNameController.text.isEmpty) {
                  showCustomSnackBar('enter_sender_name'.tr);
                  FocusScope.of(context).requestFocus(parcelController.senderNameNode);
                  parcelController.focusOnBottomSheet(widget.expandableKey);
                } else if (parcelController.senderAddressController.text.isEmpty) {
                  showCustomSnackBar('enter_sender_address'.tr);
                // FIX: check local flag OR controller coordinates as fallback
                } else if (!_isSenderAddressValid()) {
                  showCustomSnackBar('please_select_a_valid_address_from_the_suggestions'.tr);
                } else {
                  parcelController.updateTabControllerIndex(1);
                  if (parcelController.getReceiverCountryDialCode == null) {
                    parcelController.onChangeReceiverCountryCode(
                        parcelController.getSenderCountryCode);
                  }
                }
              } else {
                final receiverNumber = PhoneNumber.parse(
                    '${parcelController.getReceiverCountryDialCode}${parcelController.receiverContactController.text}');

                if (parcelController.receiverContactController.text.isEmpty) {
                  showCustomSnackBar('enter_receiver_contact_number'.tr);
                  FocusScope.of(context).requestFocus(parcelController.receiverContactNode);
                } else if (!receiverNumber.isValid(type: PhoneNumberType.mobile)) {
                  showCustomSnackBar('enter_valid_contact_number'.tr);
                  FocusScope.of(context).requestFocus(parcelController.receiverContactNode);
                } else if (parcelController.receiverNameController.text.isEmpty) {
                  showCustomSnackBar('enter_receiver_name'.tr);
                  FocusScope.of(context).requestFocus(parcelController.receiverNameNode);
                  parcelController.focusOnBottomSheet(widget.expandableKey);
                } else if (parcelController.receiverAddressController.text.isEmpty) {
                  showCustomSnackBar('enter_receiver_address'.tr);
                // FIX: check local flag OR controller coordinates as fallback
                } else if (!_isReceiverAddressValid()) {
                  showCustomSnackBar('please_select_a_valid_address_from_the_suggestions'.tr);
                } else if (parcelController.senderContactController.text.isEmpty) {
                  showCustomSnackBar('enter_sender_contact_number'.tr);
                } else if (parcelController.senderNameController.text.isEmpty) {
                  showCustomSnackBar('enter_sender_name'.tr);
                } else if (parcelController.senderAddressController.text.isEmpty) {
                  showCustomSnackBar('enter_sender_address'.tr);
                  parcelController.updateTabControllerIndex(0);
                // FIX: check local flag OR controller coordinates as fallback
                } else if (!_isSenderAddressValid()) {
                  showCustomSnackBar('please_select_a_valid_address_from_the_suggestions'.tr);
                  parcelController.updateTabControllerIndex(0);
                } else {
                  Get.find<MapController>().notifyMapController();
                  parcelController.updateParcelState(
                      ParcelDeliveryState.addOtherParcelDetails);
                }
              }
            },
          ),
        ],
      );
    });
  }
}