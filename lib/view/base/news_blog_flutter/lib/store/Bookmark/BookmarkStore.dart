import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/constant.dart';

part 'BookmarkStore.g.dart';

class BookmarkStore = _BookmarkStore with _$BookmarkStore;

abstract class _BookmarkStore with Store {
  @observable
  ObservableList<PostModel> mBookmark = ObservableList.of([]);

  @action
  Future<void> addToWishList(PostModel postModel) async {
    Map req = {
      'post_id': postModel.iD,
    };
    if (mBookmark.any((element) => element.iD == postModel.iD)) {
      mBookmark.remove(mBookmark.firstWhere((element) => element.iD == postModel.iD));

      await removeWishList(req).then((value) {
        //
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      mBookmark.add(postModel);
      await addWishList(req).then((value) {
        //
        //toast(value.message);
        //  getBookMarkList();
      }).catchError((e) {
        log(e.toString());
      });
    }
    storeBookmarkData();
  }

  bool isItemInWishlist(int id) {
    return mBookmark.any((element) => element.iD == id.validate());
  }

  @action
  Future<void> storeBookmarkData() async {
    if (mBookmark.isNotEmpty) {
      await setValue(WISHLIST_ITEM_LIST, jsonEncode(mBookmark));
    } else {
      await setValue(WISHLIST_ITEM_LIST, '');
    }
  }

  @action
  Future<void> clearBookmark() async {
    mBookmark.clear();
    storeBookmarkData();
  }

  @action
  Future<void> getBookMarkList() async {
    Map req = {};
    await getWishList(req, 0).then((value) {
      mBookmark = ObservableList.of(value.posts!);
    }).catchError((error) {
      log(error.toString());
    });
  }

  @action
  void addAllBookmark(List<PostModel> bookmarkList) {
    mBookmark.addAll(bookmarkList);
  }
}
