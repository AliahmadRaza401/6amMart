import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/parcel_category_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/screens/address/widget/address_widget.dart';
import 'package:sixam_mart/view/screens/location/pick_map_screen.dart';
import 'package:sixam_mart/view/screens/location/widget/serach_location_widget.dart';
import 'package:sixam_mart/view/screens/parcel/widget/receiver_details_botton_sheet.dart';

class ParcelLocationScreen extends StatefulWidget {
  final ParcelCategoryModel category;
  const ParcelLocationScreen({Key key, @required this.category}) : super(key: key);

  @override
  State<ParcelLocationScreen> createState() => _ParcelLocationScreenState();
}

class _ParcelLocationScreenState extends State<ParcelLocationScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<ParcelController>().setPickupAddress(Get.find<LocationController>().getUserAddress(), false);
    Get.find<ParcelController>().setIsPickedUp(false, false);
    if(Get.find<AuthController>().isLoggedIn() && Get.find<LocationController>().addressList == null) {
      Get.find<LocationController>().getAddressList();
    }
    if (Get.find<AuthController>().isLoggedIn() && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'parcel_location'.tr),
      endDrawer: MenuDrawer(),
      body: GetBuilder<ParcelController>(builder: (parcelController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: ResponsiveHelper.isDesktop(context) ? null : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: FooterView(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              SearchLocationWidget(
                mapController: null,
                pickedAddress: parcelController.pickupAddress.address,
                isEnabled: parcelController.isPickedUp,
                isPickedUp: true,
                hint: 'pick_up'.tr,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              SearchLocationWidget(
                mapController: null,
                pickedAddress: parcelController.destinationAddress != null ? parcelController.destinationAddress.address : '',
                isEnabled: !parcelController.isPickedUp,
                isPickedUp: false,
                hint: 'destination'.tr,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              CustomButton(
                buttonText: 'set_from_map'.tr,
                onPressed: () => Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                  fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) {
                  if(parcelController.isPickedUp) {
                    parcelController.setPickupAddress(address, true);
                  }else {
                    parcelController.setDestinationAddress(address);
                  }
                },
                )),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Get.find<AuthController>().isLoggedIn() ? Text('saved_address'.tr, style: robotoMedium) : SizedBox(),
              SizedBox(height: Get.find<AuthController>().isLoggedIn() ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
              GetBuilder<LocationController>(builder: (locationController) {
                return Get.find<AuthController>().isLoggedIn() ? locationController.addressList != null
                ? locationController.addressList.length > 0 ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: locationController.addressList.length,
                  itemBuilder: (context, index) {
                    if(locationController.addressList[index].zoneId == locationController.getUserAddress().zoneId) {
                      return Center(child: SizedBox(width: 700, child: AddressWidget(
                        address: locationController.addressList[index],
                        fromAddress: false,
                        onTap: () {
                          if(parcelController.isPickedUp) {
                            parcelController.setPickupAddress(locationController.addressList[index], true);
                          }else {
                            parcelController.setDestinationAddress(locationController.addressList[index]);
                          }
                        },
                      )));
                    }else {
                      return SizedBox();
                    }
                  },
                ) : NoDataScreen(text: 'no_saved_address_found'.tr) : Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: CircularProgressIndicator()),
                ) : SizedBox();
              }),

              SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0),
              ResponsiveHelper.isDesktop(context) ? _bottomButton(parcelController) : SizedBox(),

            ]))),
          )),

          ResponsiveHelper.isDesktop(context) ? SizedBox() : _bottomButton(parcelController),

        ]);
      }),
    );
  }

  Widget _bottomButton(ParcelController parcelController) {
    return CustomButton(
      margin: ResponsiveHelper.isDesktop(context) ? null : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      buttonText: 'save_and_continue'.tr,
      onPressed: () {
        if(parcelController.pickupAddress == null) {
          showCustomSnackBar('select_pickup_address'.tr);
        }else if(parcelController.destinationAddress == null) {
          showCustomSnackBar('select_destination_address'.tr);
        }else {
          if(ResponsiveHelper.isDesktop(context)) {
            Get.dialog(Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
              insetPadding: EdgeInsets.all(30),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: ReceiverDetailsBottomSheet(category: widget.category),
            ));
          }else {
            Get.bottomSheet(ReceiverDetailsBottomSheet(category: widget.category));
          }
        }
      },
    );
  }

}
