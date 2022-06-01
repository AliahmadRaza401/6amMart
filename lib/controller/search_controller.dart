import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/data/repository/search_repo.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  SearchController({@required this.searchRepo});

  List<Item> _searchItemList;
  List<Item> _allItemList;
  List<Item> _suggestedItemList;
  List<Store> _searchStoreList;
  List<Store> _allStoreList;
  String _searchText = '';
  String _storeResultText = '';
  String _itemResultText = '';
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];
  bool _isSearchMode = true;
  List<String> _sortList = ['ascending'.tr, 'descending'.tr];
  int _sortIndex = -1;
  int _rating = -1;
  bool _isStore = false;
  bool _isAvailableItems = false;
  bool _isDiscountedItems = false;
  bool _veg = false;
  bool _nonVeg = false;
  String _searchHomeText = '';

  List<Item> get searchItemList => _searchItemList;
  List<Item> get allItemList => _allItemList;
  List<Item> get suggestedItemList => _suggestedItemList;
  List<Store> get searchStoreList => _searchStoreList;
  String get searchText => _searchText;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;
  bool get isSearchMode => _isSearchMode;
  List<String> get historyList => _historyList;
  List<String> get sortList => _sortList;
  int get sortIndex => _sortIndex;
  int get rating => _rating;
  bool get isStore => _isStore;
  bool get isAvailableItems => _isAvailableItems;
  bool get isDiscountedItems => _isDiscountedItems;
  bool get veg => _veg;
  bool get nonVeg => _nonVeg;
  String get searchHomeText => _searchHomeText;

  void toggleVeg() {
    _veg = !_veg;
    update();
  }

  void toggleNonVeg() {
    _nonVeg = !_nonVeg;
    update();
  }

  void toggleAvailableItems() {
    _isAvailableItems = !_isAvailableItems;
    update();
  }

  void toggleDiscountedItems() {
    _isDiscountedItems = !_isDiscountedItems;
    update();
  }

  void setStore(bool isStore) {
    _isStore = isStore;
    update();
  }

  void setSearchMode(bool isSearchMode) {
    _isSearchMode = isSearchMode;
    if(isSearchMode) {
      _searchText = '';
      _itemResultText = '';
      _storeResultText = '';
      _allStoreList = null;
      _allItemList = null;
      _searchItemList = null;
      _searchStoreList = null;
      _sortIndex = -1;
      _isDiscountedItems = false;
      _isAvailableItems = false;
      _veg = false;
      _nonVeg = false;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
    }
    update();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }

  void sortItemSearchList() {
    _searchItemList= [];
    _searchItemList.addAll(_allItemList);
    if(_upperValue > 0) {
      _searchItemList.removeWhere((product) => (product.price) <= _lowerValue || (product.price) > _upperValue);
    }
    if(_rating != -1) {
      _searchItemList.removeWhere((product) => product.avgRating < _rating);
    }
    if(!_veg && _nonVeg) {
      _searchItemList.removeWhere((product) => product.veg == 1);
    }
    if(!_nonVeg && _veg) {
      _searchItemList.removeWhere((product) => product.veg == 0);
    }
    if(_isAvailableItems || _isDiscountedItems) {
      if(_isAvailableItems) {
        _searchItemList.removeWhere((product) => !DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds));
      }
      if(_isDiscountedItems) {
        _searchItemList.removeWhere((product) => product.discount == 0);
      }
    }
    if(_sortIndex != -1) {
      if(_sortIndex == 0) {
        _searchItemList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }else {
        _searchItemList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        Iterable iterable = _searchItemList.reversed;
        _searchItemList = iterable.toList();
      }
    }
    update();
  }

  void sortStoreSearchList() {
    _searchStoreList = [];
    _searchStoreList.addAll(_allStoreList);
    if(_rating != -1) {
      _searchStoreList.removeWhere((store) => store.avgRating < _rating);
    }
    if(!_veg && _nonVeg) {
      _searchStoreList.removeWhere((product) => product.nonVeg == 0);
    }
    if(!_nonVeg && _veg) {
      _searchStoreList.removeWhere((product) => product.veg == 0);
    }
    if(_isAvailableItems || _isDiscountedItems) {
      if(_isAvailableItems) {
        _searchStoreList.removeWhere((store) => store.open == 0);
      }
      if(_isDiscountedItems) {
        _searchStoreList.removeWhere((store) => store.discount == null);
      }
    }
    if(_sortIndex != -1) {
      if(_sortIndex == 0) {
        _searchStoreList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }else {
        _searchStoreList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        Iterable iterable = _searchStoreList.reversed;
        _searchStoreList = iterable.toList();
      }
    }
    update();
  }

  void setSearchText(String text) {
    _searchText = text;
    update();
  }

  void getSuggestedItems() async {
    Response response = await searchRepo.getSuggestedItems();
    if(response.statusCode == 200) {
      _suggestedItemList = [];
      response.body.forEach((suggestedItem) => _suggestedItemList.add(Item.fromJson(suggestedItem)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void searchData(String query, bool fromHome) async {
    if((_isStore && query.isNotEmpty && query != _storeResultText) || (!_isStore && query.isNotEmpty && (query != _itemResultText || fromHome))) {
      _searchHomeText = query;
      _searchText = query;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
      if (_isStore) {
        _searchStoreList = null;
        _allStoreList = null;
      } else {
        _searchItemList = null;
        _allItemList = null;
      }
      if (!_historyList.contains(query)) {
        _historyList.insert(0, query);
      }
      searchRepo.saveSearchHistory(_historyList);
      _isSearchMode = false;
      if(!fromHome) {
        update();
      }

      Response response = await searchRepo.getSearchData(query, _isStore);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          if (_isStore) {
            _searchStoreList = [];
          } else {
            _searchItemList = [];
          }
        } else {
          if (_isStore) {
            _storeResultText = query;
            _searchStoreList = [];
            _allStoreList = [];
            _searchStoreList.addAll(StoreModel.fromJson(response.body).stores);
            _allStoreList.addAll(StoreModel.fromJson(response.body).stores);
          } else {
            _itemResultText = query;
            _searchItemList = [];
            _allItemList = [];
            _searchItemList.addAll(ItemModel.fromJson(response.body).items);
            _allItemList.addAll(ItemModel.fromJson(response.body).items);
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void getHistoryList() {
    _isSearchMode = true;
    _searchText = '';
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
  }

  void removeHistory(int index) {
    _historyList.removeAt(index);
    searchRepo.saveSearchHistory(_historyList);
    update();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchHistory();
    _historyList = [];
    update();
  }

  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void resetFilter() {
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableItems = false;
    _isDiscountedItems = false;
    _veg = false;
    _nonVeg = false;
    _sortIndex = -1;
    update();
  }

  void clearSearchHomeText() {
    _searchHomeText = '';
    update();
  }

}
