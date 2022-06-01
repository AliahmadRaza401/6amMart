import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/data/repository/item_repo.dart';
import 'package:sixam_mart/data/repository/wishlist_repo.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListController extends GetxController implements GetxService {
  final WishListRepo wishListRepo;
  final ItemRepo itemRepo;
  WishListController({@required this.wishListRepo, @required this.itemRepo});

  List<Item> _wishItemList;
  List<Store> _wishStoreList;
  List<int> _wishItemIdList = [];
  List<int> _wishStoreIdList = [];

  List<Item> get wishItemList => _wishItemList;
  List<Store> get wishStoreList => _wishStoreList;
  List<int> get wishItemIdList => _wishItemIdList;
  List<int> get wishStoreIdList => _wishStoreIdList;

  void addToWishList(Item product, Store store, bool isStore) async {
    Response response = await wishListRepo.addWishList(isStore ? store.id : product.id, isStore);
    if (response.statusCode == 200) {
      if(isStore) {
        _wishStoreIdList.add(store.id);
        _wishStoreList.add(store);
      }else {
        _wishItemList.add(product);
        _wishItemIdList.add(product.id);
      }
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeFromWishList(int id, bool isStore) async {
    Response response = await wishListRepo.removeWishList(id, isStore);
    if (response.statusCode == 200) {
      int _idIndex = -1;
      if(isStore) {
        _idIndex = _wishStoreIdList.indexOf(id);
        _wishStoreIdList.removeAt(_idIndex);
        _wishStoreList.removeAt(_idIndex);
      }else {
        _idIndex = _wishItemIdList.indexOf(id);
        _wishItemIdList.removeAt(_idIndex);
        _wishItemList.removeAt(_idIndex);
      }
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWishList() async {
    _wishItemList = [];
    _wishStoreList = [];
    _wishStoreIdList = [];
    Response response = await wishListRepo.getWishList();
    if (response.statusCode == 200) {
      update();
      response.body['item'].forEach((item) async {
        Item _item = Item.fromJson(item);
        _wishItemList.add(_item);
        _wishItemIdList.add(_item.id);
      });
      response.body['store'].forEach((store) async {
        Store _store = Store.fromJson(store);
        _wishStoreList.add(_store);
        _wishStoreIdList.add(_store.id);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeWishes() {
    _wishItemIdList = [];
    _wishStoreIdList = [];
  }
}
