import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isStore;
  final bool isSearch;
  FavItemView({@required this.isStore, this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                child: ItemsView(
                  isStore: isStore, items: wishController.wishItemList, stores: wishController.wishStoreList,
                  noDataText: 'no_wish_data_found'.tr,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
