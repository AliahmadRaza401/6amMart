import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/coupon_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/model/body/place_order_body.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/image_picker_widget.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/not_logged_in_screen.dart';
import 'package:sixam_mart/view/screens/address/widget/address_widget.dart';
import 'package:sixam_mart/view/screens/cart/widget/delivery_option_button.dart';
import 'package:sixam_mart/view/screens/checkout/widget/payment_button.dart';
import 'package:sixam_mart/view/screens/checkout/widget/slot_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/view/screens/home/home_screen.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromCart;
  CheckoutScreen({@required this.fromCart, @required this.cartList});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double _taxPercent = 0;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      if(Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      if(Get.find<LocationController>().addressList == null) {
        Get.find<LocationController>().getAddressList();
      }
      _isCashOnDeliveryActive = Get.find<SplashController>().configModel.cashOnDelivery;
      _isDigitalPaymentActive = Get.find<SplashController>().configModel.digitalPayment;
      _cartList = [];
      widget.fromCart ? _cartList.addAll(Get.find<CartController>().cartList) : _cartList.addAll(widget.cartList);
      Get.find<StoreController>().initCheckoutData(_cartList[0].item.storeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Module _module = Get.find<SplashController>().configModel.moduleConfig.module;

    return Scaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      endDrawer: MenuDrawer(),
      body: _isLoggedIn ? GetBuilder<LocationController>(builder: (locationController) {
        List<DropdownMenuItem<int>> _addressList = [];
        _addressList.add(DropdownMenuItem<int>(value: -1, child: SizedBox(
          width: context.width > Dimensions.WEB_MAX_WIDTH ? Dimensions.WEB_MAX_WIDTH-50 : context.width-50,
          child: AddressWidget(
            address: Get.find<LocationController>().getUserAddress(),
            fromAddress: false, fromCheckout: true,
          ),
        )));
        if(locationController.addressList != null) {
          for(int index=0; index<locationController.addressList.length; index++) {
            if(locationController.addressList[index].zoneId == Get.find<LocationController>().getUserAddress().zoneId) {
              _addressList.add(DropdownMenuItem<int>(value: index, child: SizedBox(
                width: context.width > Dimensions.WEB_MAX_WIDTH ? Dimensions.WEB_MAX_WIDTH-50 : context.width-50,
                child: AddressWidget(
                  address: locationController.addressList[index],
                  fromAddress: false, fromCheckout: true,
                ),
              )));
            }
          }
        }

        return GetBuilder<StoreController>(builder: (storeController) {
          bool _todayClosed = false;
          bool _tomorrowClosed = false;
          if(storeController.store != null) {
            _todayClosed = storeController.isStoreClosed(true, storeController.store.active, storeController.store.schedules);
            _tomorrowClosed = storeController.isStoreClosed(false, storeController.store.active, storeController.store.schedules);
            _taxPercent = storeController.store.tax;
          }
          return GetBuilder<CouponController>(builder: (couponController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              double _deliveryCharge = -1;
              double _charge = -1;
              if(storeController.store != null && storeController.store.selfDeliverySystem == 1) {
                _deliveryCharge = storeController.store.deliveryCharge;
                _charge = storeController.store.deliveryCharge;
              }else if(storeController.store != null && orderController.distance != null && orderController.distance != -1) {
                _deliveryCharge = orderController.distance * Get.find<SplashController>().configModel.perKmShippingCharge;
                _charge = orderController.distance * Get.find<SplashController>().configModel.perKmShippingCharge;
                if(_deliveryCharge < Get.find<SplashController>().configModel.minimumShippingCharge) {
                  _deliveryCharge = Get.find<SplashController>().configModel.minimumShippingCharge;
                  _charge = Get.find<SplashController>().configModel.minimumShippingCharge;
                }
              }

              double _price = 0;
              double _discount = 0;
              double _couponDiscount = couponController.discount;
              double _tax = 0;
              double _addOns = 0;
              double _subTotal = 0;
              double _orderAmount = 0;
              if(storeController.store != null) {
                _cartList.forEach((cartModel) {
                  List<AddOns> _addOnList = [];
                  cartModel.addOnIds.forEach((addOnId) {
                    for (AddOns addOns in cartModel.item.addOns) {
                      if (addOns.id == addOnId.id) {
                        _addOnList.add(addOns);
                        break;
                      }
                    }
                  });

                  for (int index = 0; index < _addOnList.length; index++) {
                    _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
                  }
                  _price = _price + (cartModel.price * cartModel.quantity);
                  double _dis = (storeController.store.discount != null
                      && DateConverter.isAvailable(storeController.store.discount.startTime, storeController.store.discount.endTime))
                      ? storeController.store.discount.discount : cartModel.item.discount;
                  String _disType = (storeController.store.discount != null
                      && DateConverter.isAvailable(storeController.store.discount.startTime, storeController.store.discount.endTime))
                      ? 'percent' : cartModel.item.discountType;
                  _discount = _discount + ((cartModel.price - PriceConverter.convertWithDiscount(cartModel.price, _dis, _disType)) * cartModel.quantity);
                });
                if (storeController.store != null && storeController.store.discount != null) {
                  if (storeController.store.discount.maxDiscount != 0 && storeController.store.discount.maxDiscount < _discount) {
                    _discount = storeController.store.discount.maxDiscount;
                  }
                  if (storeController.store.discount.minPurchase != 0 && storeController.store.discount.minPurchase > (_price + _addOns)) {
                    _discount = 0;
                  }
                }
                _subTotal = _price + _addOns;
                _orderAmount = (_price - _discount) + _addOns - _couponDiscount;

                if (orderController.orderType == 'take_away' || storeController.store.freeDelivery
                    || (Get.find<SplashController>().configModel.freeDeliveryOver != null && _orderAmount
                        >= Get.find<SplashController>().configModel.freeDeliveryOver) || couponController.freeDelivery) {
                  _deliveryCharge = 0;
                }
              }

              _tax = PriceConverter.calculation(_orderAmount, _taxPercent, 'percent', 1);
              double _total = _subTotal + _deliveryCharge - _discount - _couponDiscount + _tax;

              return (orderController.distance != null && locationController.addressList != null) ? Column(
                children: [

                  Expanded(child: Scrollbar(child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: FooterView(child: SizedBox(
                      width: Dimensions.WEB_MAX_WIDTH,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        // Order type
                        Text('delivery_option'.tr, style: robotoMedium),
                        storeController.store.delivery ? DeliveryOptionButton(
                          value: 'delivery', title: 'home_delivery'.tr, charge: _charge, isFree: storeController.store.freeDelivery,
                        ) : SizedBox(),
                        storeController.store.takeAway ? DeliveryOptionButton(
                          value: 'take_away', title: 'take_away'.tr, charge: _deliveryCharge, isFree: true,
                        ) : SizedBox(),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        orderController.orderType != 'take_away' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('deliver_to'.tr, style: robotoMedium),
                            TextButton.icon(
                              onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(true)),
                              icon: Icon(Icons.add, size: 20),
                              label: Text('add'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ]),
                          DropdownButton(
                            value: orderController.addressIndex,
                            items: _addressList,
                            itemHeight: ResponsiveHelper.isMobile(context) ? 70 : 85, elevation: 0, iconSize: 30, underline: SizedBox(),
                            onChanged: (int index) {
                              if(storeController.store.selfDeliverySystem == 0) {
                                orderController.getDistanceInKM(
                                  LatLng(
                                    double.parse(index == -1 ? locationController.getUserAddress().latitude : locationController.addressList[index].latitude),
                                    double.parse(index == -1 ? locationController.getUserAddress().longitude : locationController.addressList[index].longitude),
                                  ),
                                  LatLng(double.parse(storeController.store.latitude), double.parse(storeController.store.longitude)),
                                );
                              }
                              orderController.setAddressIndex(index);
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        ]) : SizedBox(),

                        // Time Slot
                        storeController.store.scheduleOrder ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('preference_time'.tr, style: robotoMedium),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return SlotWidget(
                                  title: index == 0 ? 'today'.tr : 'tomorrow'.tr,
                                  isSelected: orderController.selectedDateSlot == index,
                                  onTap: () => orderController.updateDateSlot(index, storeController.store.orderPlaceToScheduleInterval),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(
                            height: 50,
                            child: ((orderController.selectedDateSlot == 0 && _todayClosed)
                            || (orderController.selectedDateSlot == 1 && _tomorrowClosed))
                            ? Center(child: Text(_module.showRestaurantText
                            ? 'restaurant_is_closed'.tr : 'store_is_closed'.tr)) : orderController.timeSlots != null
                            ? orderController.timeSlots.length > 0 ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: orderController.timeSlots.length,
                              itemBuilder: (context, index) {
                                return SlotWidget(
                                  title: (index == 0 && orderController.selectedDateSlot == 0
                                      && storeController.isStoreOpenNow(storeController.store.active, storeController.store.schedules)
                                      && (_module.orderPlaceToScheduleInterval ? storeController.store.orderPlaceToScheduleInterval == 0 : true))
                                      ? 'now'.tr : '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                                      '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                                  isSelected: orderController.selectedTimeSlot == index,
                                  onTap: () => orderController.updateTimeSlot(index),
                                );
                              },
                            ) : Center(child: Text('no_slot_available'.tr)) : Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        ]) : SizedBox(),

                        // Coupon
                        GetBuilder<CouponController>(
                          builder: (couponController) {
                            return Row(children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: TextField(
                                    controller: _couponController,
                                    style: robotoRegular.copyWith(height: ResponsiveHelper.isMobile(context) ? null : 2),
                                    decoration: InputDecoration(
                                      hintText: 'enter_promo_code'.tr,
                                      hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                      isDense: true,
                                      filled: true,
                                      enabled: couponController.discount == 0,
                                      fillColor: Theme.of(context).cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(Get.find<LocalizationController>().isLtr ? 10 : 0),
                                          right: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : 10),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  String _couponCode = _couponController.text.trim();
                                  if(couponController.discount < 1 && !couponController.freeDelivery) {
                                    if(_couponCode.isNotEmpty && !couponController.isLoading) {
                                      couponController.applyCoupon(_couponCode, (_price-_discount)+_addOns, _deliveryCharge,
                                          storeController.store.id).then((discount) {
                                        if (discount > 0) {
                                          showCustomSnackBar(
                                            '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                            isError: false,
                                          );
                                        }
                                      });
                                    } else if(_couponCode.isEmpty) {
                                      showCustomSnackBar('enter_a_coupon_code'.tr);
                                    }
                                  } else {
                                    couponController.removeCouponData(true);
                                  }
                                },
                                child: Container(
                                  height: 50, width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : 10),
                                      right: Radius.circular(Get.find<LocalizationController>().isLtr ? 10 : 0),
                                    ),
                                  ),
                                  child: (couponController.discount <= 0 && !couponController.freeDelivery) ? !couponController.isLoading ? Text(
                                    'apply'.tr,
                                    style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                                  ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                      : Icon(Icons.clear, color: Colors.white),
                                ),
                              ),
                            ]);
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Text('choose_payment_method'.tr, style: robotoMedium),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        _isCashOnDeliveryActive ? PaymentButton(
                          icon: Images.cash_on_delivery,
                          title: 'cash_on_delivery'.tr,
                          subtitle: 'pay_your_payment_after_getting_item'.tr,
                          isSelected: orderController.paymentMethodIndex == 0,
                          onTap: () => orderController.setPaymentMethod(0),
                        ) : SizedBox(),
                        _isDigitalPaymentActive ? PaymentButton(
                          icon: Images.digital_payment,
                          title: 'digital_payment'.tr,
                          subtitle: 'faster_and_safe_way'.tr,
                          isSelected: _isCashOnDeliveryActive ? orderController.paymentMethodIndex == 1 : orderController.paymentMethodIndex == 0,
                          onTap: () => orderController.setPaymentMethod(_isCashOnDeliveryActive ? 1 : 0),
                        ) : SizedBox(),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        CustomTextField(
                          controller: _noteController,
                          hintText: 'additional_note'.tr,
                          maxLines: 3,
                          inputType: TextInputType.multiline,
                          inputAction: TextInputAction.newline,
                          capitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Get.find<SplashController>().configModel.moduleConfig.module.orderAttachment ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text('prescription'.tr, style: robotoMedium),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(
                                '(${'max_size_2_mb'.tr})',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            ]),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ImagePickerWidget(
                              image: '', rawFile: orderController.rawAttachment,
                              onTap: () => orderController.pickImage(),
                            ),
                          ],
                        ) : SizedBox(),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(_module.addOn ? 'subtotal'.tr : 'item_price'.tr, style: robotoMedium),
                          Text(PriceConverter.convertPrice(_subTotal), style: robotoMedium),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('discount'.tr, style: robotoRegular),
                          Text('(-) ${PriceConverter.convertPrice(_discount)}', style: robotoRegular),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        (couponController.discount > 0 || couponController.freeDelivery) ? Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('coupon_discount'.tr, style: robotoRegular),
                            (couponController.coupon != null && couponController.coupon.couponType == 'free_delivery') ? Text(
                              'free_delivery'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
                            ) : Text(
                              '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                              style: robotoRegular,
                            ),
                          ]),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ]) : SizedBox(),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('vat_tax'.tr, style: robotoRegular),
                          Text('(+) ${PriceConverter.convertPrice(_tax)}', style: robotoRegular),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('delivery_fee'.tr, style: robotoRegular),
                          _deliveryCharge == -1 ? Text(
                            'calculating'.tr, style: robotoRegular.copyWith(color: Colors.red),
                          ) : (_deliveryCharge == 0 || (couponController.coupon != null && couponController.coupon.couponType == 'free_delivery')) ? Text(
                            'free'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
                          ) : Text(
                            '(+) ${PriceConverter.convertPrice(_deliveryCharge)}', style: robotoRegular,
                          ),
                        ]),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(
                            'total_amount'.tr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            PriceConverter.convertPrice(_total),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                        ]),

                        ResponsiveHelper.isDesktop(context) ? Padding(
                          padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                          child: _orderPlaceButton(
                            orderController, storeController, locationController, _todayClosed, _tomorrowClosed, _orderAmount, _deliveryCharge, _tax, _discount, _total,
                          ),
                        ) : SizedBox(),

                      ]),
                    )),
                  ))),

                  ResponsiveHelper.isDesktop(context) ? SizedBox() : _orderPlaceButton(
                    orderController, storeController, locationController, _todayClosed, _tomorrowClosed, _orderAmount, _deliveryCharge, _tax, _discount, _total,
                  ),

                ],
              ) : Center(child: CircularProgressIndicator());
            });
          });
        });
      }) : NotLoggedInScreen(),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.find<OrderController>().stopLoader();
      HomeScreen.loadData(true);
      if(_isCashOnDeliveryActive && Get.find<OrderController>().paymentMethodIndex == 0) {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success', false));
      }else {
       if(GetPlatform.isWeb) {
         Get.back();
         String hostname = html.window.location.hostname;
         String protocol = html.window.location.protocol;
         String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Get.find<UserController>()
             .userInfoModel.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID'
             '&type=${Get.find<OrderController>().orderType}&status=';
         html.window.open(selectedUrl,"_self");
       } else{
         Get.offNamed(RouteHelper.getPaymentRoute(
           orderID, Get.find<UserController>().userInfoModel.id, Get.find<OrderController>().orderType,
         ));
       }
      }
      Get.find<OrderController>().clearPrevData();
      Get.find<CouponController>().removeCouponData(false);
    }else {
      showCustomSnackBar(message);
    }
  }

  Widget _orderPlaceButton(OrderController orderController, StoreController storeController, LocationController locationController, bool todayClosed, bool tomorrowClosed,
      double orderAmount, double deliveryCharge, double tax, double discount, double total) {
    return Container(
      width: Dimensions.WEB_MAX_WIDTH,
      alignment: Alignment.center,
      padding: ResponsiveHelper.isDesktop(context) ? null : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: !orderController.isLoading ? CustomButton(buttonText: 'confirm_order'.tr, onPressed: () {
        bool _isAvailable = true;
        DateTime _scheduleStartDate = DateTime.now();
        DateTime _scheduleEndDate = DateTime.now();
        if(orderController.timeSlots == null || orderController.timeSlots.length == 0) {
          _isAvailable = false;
        }else {
          DateTime _date = orderController.selectedDateSlot == 0 ? DateTime.now() : DateTime.now().add(Duration(days: 1));
          DateTime _startTime = orderController.timeSlots[orderController.selectedTimeSlot].startTime;
          DateTime _endTime = orderController.timeSlots[orderController.selectedTimeSlot].endTime;
          _scheduleStartDate = DateTime(_date.year, _date.month, _date.day, _startTime.hour, _startTime.minute+1);
          _scheduleEndDate = DateTime(_date.year, _date.month, _date.day, _endTime.hour, _endTime.minute+1);
          for (CartModel cart in _cartList) {
            if (!DateConverter.isAvailable(
              cart.item.availableTimeStarts, cart.item.availableTimeEnds,
              time: storeController.store.scheduleOrder ? _scheduleStartDate : null,
            ) && !DateConverter.isAvailable(
              cart.item.availableTimeStarts, cart.item.availableTimeEnds,
              time: storeController.store.scheduleOrder ? _scheduleEndDate : null,
            )) {
              _isAvailable = false;
              break;
            }
          }
        }
        if(!_isCashOnDeliveryActive && !_isDigitalPaymentActive) {
          showCustomSnackBar('no_payment_method_is_enabled'.tr);
        }else if(orderAmount < storeController.store.minimumOrder) {
          showCustomSnackBar('${'minimum_order_amount_is'.tr} ${storeController.store.minimumOrder}');
        }else if((orderController.selectedDateSlot == 0 && todayClosed) || (orderController.selectedDateSlot == 1 && tomorrowClosed)) {
          showCustomSnackBar(Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
              ? 'restaurant_is_closed'.tr : 'store_is_closed'.tr);
        }else if (orderController.timeSlots == null || orderController.timeSlots.length == 0) {
          if(storeController.store.scheduleOrder) {
            showCustomSnackBar('select_a_time'.tr);
          }else {
            showCustomSnackBar(Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                ? 'restaurant_is_closed'.tr : 'store_is_closed'.tr);
          }
        }else if (!_isAvailable) {
          showCustomSnackBar('one_or_more_products_are_not_available_for_this_selected_time'.tr);
        }else if (orderController.orderType != 'take_away' && orderController.distance == -1 && deliveryCharge == -1) {
          showCustomSnackBar('delivery_fee_not_set_yet'.tr);
        }
        else {
          List<Cart> carts = [];
          for (int index = 0; index < _cartList.length; index++) {
            CartModel cart = _cartList[index];
            List<int> _addOnIdList = [];
            List<int> _addOnQtyList = [];
            cart.addOnIds.forEach((addOn) {
              _addOnIdList.add(addOn.id);
              _addOnQtyList.add(addOn.quantity);
            });
            carts.add(Cart(
              cart.isCampaign ? null : cart.item.id, cart.isCampaign ? cart.item.id : null,
              cart.discountedPrice.toString(), '', cart.variation,
              cart.quantity, _addOnIdList, cart.addOns, _addOnQtyList,
            ));
          }
          AddressModel _address = orderController.addressIndex == -1 ? Get.find<LocationController>().getUserAddress()
              : locationController.addressList[orderController.addressIndex];
          orderController.placeOrder(PlaceOrderBody(
            cart: carts, couponDiscountAmount: Get.find<CouponController>().discount, distance: orderController.distance,
            scheduleAt: !storeController.store.scheduleOrder ? null : (orderController.selectedDateSlot == 0
                && orderController.selectedTimeSlot == 0) ? null : DateConverter.dateToDateAndTime(_scheduleEndDate),
            orderAmount: total, orderNote: _noteController.text, orderType: orderController.orderType,
            paymentMethod: _isCashOnDeliveryActive ? orderController.paymentMethodIndex == 0 ? 'cash_on_delivery'
                : 'digital_payment' : 'digital_payment',
            couponCode: (Get.find<CouponController>().discount > 0 || (Get.find<CouponController>().coupon != null
                && Get.find<CouponController>().freeDelivery)) ? Get.find<CouponController>().coupon.code : null,
            storeId: _cartList[0].item.storeId,
            address: _address.address, latitude: _address.latitude, longitude: _address.longitude, addressType: _address.addressType,
            contactPersonName: _address.contactPersonName ?? '${Get.find<UserController>().userInfoModel.fName} '
                '${Get.find<UserController>().userInfoModel.lName}',
            contactPersonNumber: _address.contactPersonNumber ?? Get.find<UserController>().userInfoModel.phone,
            discountAmount: discount, taxAmount: tax, receiverDetails: null, parcelCategoryId: null, chargePayer: null,
          ), _callback);
        }
      }) : Center(child: CircularProgressIndicator()),
    );
  }

}
