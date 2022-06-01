import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/screens/order/order_details_screen.dart';
import 'package:sixam_mart/view/screens/order/widget/order_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: GetBuilder<OrderController>(builder: (orderController) {
        PaginatedOrderModel paginatedOrderModel;
        if(orderController.runningOrderModel != null && orderController.historyOrderModel != null) {
          paginatedOrderModel = isRunning ? orderController.runningOrderModel : orderController.historyOrderModel;
        }

        return paginatedOrderModel != null ? paginatedOrderModel.orders.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            if(isRunning) {
              await orderController.getRunningOrders(1);
            }else {
              await orderController.getHistoryOrders(1);
            }
          },
          child: Scrollbar(child: SingleChildScrollView(
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: PaginatedListView(
                  scrollController: scrollController,
                  onPaginate: (int offset) {
                    if(isRunning) {
                      Get.find<OrderController>().getRunningOrders(offset);
                    }else {
                      Get.find<OrderController>().getHistoryOrders(offset);
                    }
                  },
                  totalSize: paginatedOrderModel != null ? paginatedOrderModel.totalSize : null,
                  offset: paginatedOrderModel != null ? paginatedOrderModel.offset : null,
                  itemView: ListView.builder(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    itemCount: paginatedOrderModel.orders.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      bool _isParcel = paginatedOrderModel.orders[index].orderType == 'parcel';

                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            RouteHelper.getOrderDetailsRoute(paginatedOrderModel.orders[index].id),
                            arguments: OrderDetailsScreen(
                              orderId: paginatedOrderModel.orders[index].id,
                              orderModel: paginatedOrderModel.orders[index],
                            ),
                          );
                        },
                        child: Container(
                          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
                          margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL) : null,
                          decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                          ) : null,
                          child: Column(children: [

                            Row(children: [

                              Stack(children: [
                                Container(
                                  height: 60, width: 60, alignment: Alignment.center,
                                  decoration: _isParcel ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                                  ) : null,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    child: CustomImage(
                                      image: _isParcel ? '${Get.find<SplashController>().configModel.baseUrls.parcelCategoryImageUrl}'
                                          '/${paginatedOrderModel.orders[index].parcelCategory != null ? paginatedOrderModel.orders[index].parcelCategory.image : ''}'
                                          : '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${paginatedOrderModel.orders[index].store.logo}',
                                      height: _isParcel ? 35 : 60, width: _isParcel ? 35 : 60, fit: _isParcel ? null : BoxFit.cover,
                                    ),
                                  ),
                                ),
                                _isParcel ? Positioned(left: 0, top: 10, child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(right: Radius.circular(Dimensions.RADIUS_SMALL)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Text('parcel'.tr, style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white,
                                  )),
                                )) : SizedBox(),
                              ]),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Text(
                                      '${_isParcel ? 'delivery_id'.tr : 'order_id'.tr}:',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text('#${paginatedOrderModel.orders[index].id}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  ]),
                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  Text(
                                    DateConverter.dateTimeStringToDateTime(paginatedOrderModel.orders[index].createdAt),
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ]),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Text(paginatedOrderModel.orders[index].orderStatus.tr, style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                                  )),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                isRunning ? InkWell(
                                  onTap: () => Get.toNamed(RouteHelper.getOrderTrackingRoute(paginatedOrderModel.orders[index].id)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    ),
                                    child: Row(children: [
                                      Image.asset(Images.tracking, height: 15, width: 15, color: Theme.of(context).primaryColor),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(_isParcel ? 'track_delivery'.tr : 'track_order'.tr, style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                      )),
                                    ]),
                                  ),
                                ) : Text(
                                  '${paginatedOrderModel.orders[index].detailsCount} ${paginatedOrderModel.orders[index].detailsCount > 1 ? 'items'.tr : 'item'.tr}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                ),
                              ]),

                            ]),

                            (index == paginatedOrderModel.orders.length-1 || ResponsiveHelper.isDesktop(context)) ? SizedBox() : Padding(
                              padding: EdgeInsets.only(left: 70),
                              child: Divider(
                                color: Theme.of(context).disabledColor, height: Dimensions.PADDING_SIZE_LARGE,
                              ),
                            ),

                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )),
        ) : NoDataScreen(text: 'no_order_found'.tr, showFooter: true) : OrderShimmer(orderController: orderController);
      }),
    );
  }
}
