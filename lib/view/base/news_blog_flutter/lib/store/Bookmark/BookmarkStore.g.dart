// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookmarkStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BookmarkStore on _BookmarkStore, Store {
  final _$mBookmarkAtom = Atom(name: '_BookmarkStore.mBookmark');

  @override
  ObservableList<PostModel> get mBookmark {
    _$mBookmarkAtom.reportRead();
    return super.mBookmark;
  }

  @override
  set mBookmark(ObservableList<PostModel> value) {
    _$mBookmarkAtom.reportWrite(value, super.mBookmark, () {
      super.mBookmark = value;
    });
  }

  final _$addToWishListAsyncAction =
      AsyncAction('_BookmarkStore.addToWishList');

  @override
  Future<void> addToWishList(PostModel postModel) {
    return _$addToWishListAsyncAction.run(() => super.addToWishList(postModel));
  }

  final _$storeBookmarkDataAsyncAction =
      AsyncAction('_BookmarkStore.storeBookmarkData');

  @override
  Future<void> storeBookmarkData() {
    return _$storeBookmarkDataAsyncAction.run(() => super.storeBookmarkData());
  }

  final _$clearBookmarkAsyncAction =
      AsyncAction('_BookmarkStore.clearBookmark');

  @override
  Future<void> clearBookmark() {
    return _$clearBookmarkAsyncAction.run(() => super.clearBookmark());
  }

  final _$getBookMarkListAsyncAction =
      AsyncAction('_BookmarkStore.getBookMarkList');

  @override
  Future<void> getBookMarkList() {
    return _$getBookMarkListAsyncAction.run(() => super.getBookMarkList());
  }

  final _$_BookmarkStoreActionController =
      ActionController(name: '_BookmarkStore');

  @override
  void addAllBookmark(List<PostModel> bookmarkList) {
    final _$actionInfo = _$_BookmarkStoreActionController.startAction(
        name: '_BookmarkStore.addAllBookmark');
    try {
      return super.addAllBookmark(bookmarkList);
    } finally {
      _$_BookmarkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mBookmark: ${mBookmark}
    ''';
  }
}
