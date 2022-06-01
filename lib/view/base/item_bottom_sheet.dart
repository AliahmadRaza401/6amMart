import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/quantity_button.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemBottomSheet extends StatefulWidget {
  final Item item;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inStorePage;
  ItemBottomSheet({@required this.item, this.isCampaign = false, this.cart, this.cartIndex, this.inStorePage = false});

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {

  @override
  void initState() {
    super.initState();

    Get.find<ItemController>().initData(widget.item, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
            : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
      ),
      child: GetBuilder<ItemController>(builder: (itemController) {
        double _startingPrice;
        double _endingPrice;
        if (widget.item.choiceOptions.length != 0) {
          List<double> _priceList = [];
          widget.item.variations.forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = widget.item.price;
        }

        List<String> _variationList = [];
        for (int index = 0; index < widget.item.choiceOptions.length; index++) {
          _variationList.add(widget.item.choiceOptions[index].options[itemController.variationIndex[index]].replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = widget.item.price;
        Variation _variation;
        int _stock = widget.item.stock;
        for (Variation variation in widget.item.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            _stock = variation.stock;
            break;
          }
        }

        double _discount = (widget.isCampaign || widget.item.storeDiscount == 0) ? widget.item.discount : widget.item.storeDiscount;
        String _discountType = (widget.isCampaign || widget.item.storeDiscount == 0) ? widget.item.discountType : 'percent';
        double priceWithDiscount = PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity = priceWithDiscount * itemController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < widget.item.addOns.length; index++) {
          if (itemController.addOnActiveList[index]) {
            addonsCost = addonsCost + (widget.item.addOns[index].price * itemController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(id: widget.item.addOns[index].id, quantity: itemController.addOnQtyList[index]));
            _addOnsList.add(widget.item.addOns[index]);
          }
        }
        double priceWithAddons = priceWithQuantity + (Get.find<SplashController>().configModel.moduleConfig.module.addOn ? addonsCost : 0);
        // bool _isRestAvailable = DateConverter.isAvailable(widget.product.restaurantOpeningTime, widget.product.restaurantClosingTime);
        bool _isAvailable = DateConverter.isAvailable(widget.item.availableTimeStarts, widget.item.availableTimeEnds);

        CartModel _cartModel = CartModel(
          price, priceWithDiscount, _variation != null ? [_variation] : [],
          (price - PriceConverter.convertWithDiscount(price, _discount, _discountType)),
          itemController.quantity, _addOnIdList, _addOnsList, widget.isCampaign, _stock, widget.item,
        );

        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [

            InkWell(onTap: () => Get.back(), child: Padding(
              padding:  EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Icon(Icons.close),
            )),

            Padding(
              padding: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_DEFAULT, top: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_DEFAULT,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                //Product
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                  InkWell(
                    onTap: widget.isCampaign ? null : () {
                      if(!widget.isCampaign) {
                        Get.toNamed(RouteHelper.getItemImagesRoute(widget.item));
                      }
                    },
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: CustomImage(
                          image: '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl
                              : Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${widget.item.image}',
                          width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                          height: ResponsiveHelper.isMobile(context) ? 100 : 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DiscountTag(discount: _discount, discountType: _discountType, fromTop: 20),
                    ]),
                  ),
                  SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        widget.item.name, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () {
                          if(widget.inStorePage) {
                            Get.back();
                          }else {
                            Get.offNamed(RouteHelper.getStoreRoute(widget.item.storeId, 'item'));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: Text(
                            widget.item.storeName,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      RatingBar(rating: widget.item.avgRating, size: 15, ratingCount: widget.item.ratingCount),
                      Text(
                        '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount,
                            discountType: _discountType)}' : ''}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      price > priceWithDiscount ? Text(
                        '${PriceConverter.convertPrice(_startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                        style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                      ) : SizedBox(),
                    ]),
                  ),

                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    ((Get.find<SplashController>().configModel.moduleConfig.module.unit && widget.item.unitType != null)
                    || (Get.find<SplashController>().configModel.moduleConfig.module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg)) ? Container(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        Get.find<SplashController>().configModel.moduleConfig.module.unit ? widget.item.unitType ?? ''
                            : widget.item.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                      ),
                    ) : SizedBox(),
                    SizedBox(height: Get.find<SplashController>().configModel.toggleVegNonVeg ? 50 : 0),
                    widget.isCampaign ? SizedBox(height: 25) : GetBuilder<WishListController>(builder: (wishList) {
                      return InkWell(
                        onTap: () {
                          if(Get.find<AuthController>().isLoggedIn()) {
                            wishList.wishItemIdList.contains(widget.item.id) ? wishList.removeFromWishList(widget.item.id, false)
                                : wishList.addToWishList(widget.item, null, false);
                          }else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Icon(
                          wishList.wishItemIdList.contains(widget.item.id) ? Icons.favorite : Icons.favorite_border,
                          color: wishList.wishItemIdList.contains(widget.item.id) ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                        ),
                      );
                    }),
                  ]),

                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                (widget.item.description != null && widget.item.description.isNotEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr, style: robotoMedium),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(widget.item.description, style: robotoRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                ) : SizedBox(),

                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.item.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.item.choiceOptions[index].title, style: robotoMedium),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 3 : 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: (1 / 0.25),
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: widget.item.choiceOptions[index].options.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              itemController.setCartVariationIndex(index, i, widget.item);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                color:
                                itemController.variationIndex[index] != i ? Theme.of(context).backgroundColor : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                border:
                                itemController.variationIndex[index] != i ? Border.all(color: Theme.of(context).disabledColor, width: 2) : null,
                              ),
                              child: Text(
                                widget.item.choiceOptions[index].options[i].trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  color: itemController.variationIndex[index] != i ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: index != widget.item.choiceOptions.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                    ]);
                  },
                ),
                SizedBox(height: widget.item.choiceOptions.length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

                // Quantity
                Row(children: [
                  Text('quantity'.tr, style: robotoMedium),
                  Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButton(
                      onTap: () {
                        if (itemController.quantity > 1) {
                          itemController.setQuantity(false, _stock);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(itemController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    QuantityButton(
                      onTap: () => itemController.setQuantity(true, _stock),
                      isIncrement: true,
                    ),
                  ]),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // Addons
                (Get.find<SplashController>().configModel.moduleConfig.module.addOn && widget.item.addOns.length > 0) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('addons'.tr, style: robotoMedium),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: (1 / 1.1),
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.item.addOns.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (!itemController.addOnActiveList[index]) {
                              itemController.addAddOn(true, index);
                            } else if (itemController.addOnQtyList[index] == 1) {
                              itemController.addAddOn(false, index);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: itemController.addOnActiveList[index] ? 2 : 20),
                            decoration: BoxDecoration(
                              color: itemController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              border: itemController.addOnActiveList[index] ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                              boxShadow: itemController.addOnActiveList[index]
                                  ? [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)] : null,
                            ),
                            child: Column(children: [
                              Expanded(
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(widget.item.addOns[index].name,
                                    maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                    style: robotoMedium.copyWith(
                                      color: itemController.addOnActiveList[index] ? Colors.white : Colors.black,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    widget.item.addOns[index].price > 0 ? PriceConverter.convertPrice(widget.item.addOns[index].price) : 'free'.tr,
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith(
                                      color: itemController.addOnActiveList[index] ? Colors.white : Colors.black,
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                    ),
                                  ),
                                ]),
                              ),
                              itemController.addOnActiveList[index] ? Container(
                                height: 25,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).cardColor),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (itemController.addOnQtyList[index] > 1) {
                                          itemController.setAddOnQuantity(false, index);
                                        } else {
                                          itemController.addAddOn(false, index);
                                        }
                                      },
                                      child: Center(child: Icon(Icons.remove, size: 15)),
                                    ),
                                  ),
                                  Text(
                                    itemController.addOnQtyList[index].toString(),
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => itemController.setAddOnQuantity(true, index),
                                      child: Center(child: Icon(Icons.add, size: 15)),
                                    ),
                                  ),
                                ]),
                              )
                                  : SizedBox(),
                            ]),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  ],
                ) : SizedBox(),

                Row(children: [
                  Text('${'total_amount'.tr}:', style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(PriceConverter.convertPrice(priceWithAddons), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                //Add to cart Button

                _isAvailable ? SizedBox() : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Column(children: [
                    Text('not_available_now'.tr, style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                    )),
                    Text(
                      '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.item.availableTimeStarts)} '
                          '- ${DateConverter.convertTimeToTime(widget.item.availableTimeEnds)}',
                      style: robotoRegular,
                    ),
                  ]),
                ),

                (!widget.item.scheduleOrder && !_isAvailable) ? SizedBox() : Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 50),
                      primary: Theme.of(context).cardColor, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    ),
                    onPressed: () {
                      if(widget.inStorePage) {
                        Get.back();
                      }else {
                        Get.offNamed(RouteHelper.getStoreRoute(widget.item.storeId, 'item'));
                      }
                    },
                    child: Image.asset(Images.house, color: Theme.of(context).primaryColor, height: 30, width: 30),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: CustomButton(
                    width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width / 2.0 : null,
                    /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                        ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                    buttonText: (Get.find<SplashController>().configModel.moduleConfig.module.stock && _stock <= 0)
                        ? 'out_of_stock'.tr : widget.isCampaign ? 'order_now'.tr
                        : (widget.cart != null || itemController.cartIndex != -1) ? 'update_in_cart'.tr : 'add_to_cart'.tr,
                    onPressed: (Get.find<SplashController>().configModel.moduleConfig.module.stock && _stock <= 0) ? null : () {
                      Get.back();
                      if(widget.isCampaign) {
                        Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                          fromCart: false, cartList: [_cartModel],
                        ));
                      }else {
                        if (Get.find<CartController>().existAnotherStoreItem(_cartModel.item.storeId)) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.warning,
                            title: 'are_you_sure_to_reset'.tr,
                            description: Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                                ? 'if_you_continue'.tr : 'if_you_continue_without_another_store'.tr,
                            onYesPressed: () {
                              Get.back();
                              Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                              _showCartSnackBar(context);
                            },
                          ), barrierDismissible: false);
                        } else {
                          Get.find<CartController>().addToCart(
                            _cartModel, widget.cartIndex != null ? widget.cartIndex : itemController.cartIndex,
                          );
                          _showCartSnackBar(context);
                        }
                      }
                    },

                  )),
                ]),
              ]),
            ),
          ]),
        );
      }),
    );
  }

  void _showCartSnackBar(BuildContext context) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green,
      message: 'item_added_to_cart'.tr,
      mainButton: TextButton(
        onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
        child: Text('view_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
      ),
      onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
      duration: Duration(seconds: 3),
      maxWidth: Dimensions.WEB_MAX_WIDTH,
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}

