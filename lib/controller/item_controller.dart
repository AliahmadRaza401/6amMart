import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/body/review_body.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/order_details_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/response_model.dart';
import 'package:sixam_mart/data/repository/item_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

class ItemController extends GetxController implements GetxService {
  final ItemRepo itemRepo;
  ItemController({@required this.itemRepo});

  // Latest products
  List<Item> _popularItemList;
  List<Item> _reviewedItemList;
  bool _isLoading = false;
  List<int> _variationIndex;
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];
  String _popularType = 'all';
  String _reviewedType = 'all';
  static List<String> _itemTypeList = ['all', 'veg', 'non_veg'];
  int _imageIndex = 0;
  int _cartIndex = -1;

  List<Item> get popularItemList => _popularItemList;
  List<Item> get reviewedItemList => _reviewedItemList;
  bool get isLoading => _isLoading;
  List<int> get variationIndex => _variationIndex;
  int get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;
  String get popularType => _popularType;
  String get reviewType => _reviewedType;
  List<String> get itemTypeList => _itemTypeList;
  int get imageIndex => _imageIndex;
  int get cartIndex => _cartIndex;

  Future<void> getPopularItemList(bool reload, String type, bool notify) async {
    _popularType = type;
    if(reload) {
      _popularItemList = null;
    }
    if(notify) {
      update();
    }
    if(_popularItemList == null || reload) {
      Response response = await itemRepo.getPopularItemList(type);
      if (response.statusCode == 200) {
        _popularItemList = [];
        _popularItemList.addAll(ItemModel.fromJson(response.body).items);
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getReviewedItemList(bool reload, String type, bool notify) async {
    _reviewedType = type;
    if(reload) {
      _reviewedItemList = null;
    }
    if(notify) {
      update();
    }
    if(_reviewedItemList == null || reload) {
      Response response = await itemRepo.getReviewedItemList(type);
      if (response.statusCode == 200) {
        _reviewedItemList = [];
        _reviewedItemList.addAll(ItemModel.fromJson(response.body).items);
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void initData(Item item, CartModel cart) {
    _variationIndex = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    if(cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if(cart.variation.length != null && cart.variation.length > 0 && cart.variation[0].type != null) {
        _variationTypes.addAll(cart.variation[0].type.split('-'));
      }
      int _varIndex = 0;
      item.choiceOptions.forEach((choiceOption) {
        for(int index=0; index<choiceOption.options.length; index++) {
          if(choiceOption.options[index].trim().replaceAll(' ', '') == _variationTypes[_varIndex].trim()) {
            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
      List<int> _addOnIdList = [];
      cart.addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      item.addOns.forEach((addOn) {
        if(_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cart.addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }else {
      _quantity = 1;
      item.choiceOptions.forEach((element) => _variationIndex.add(0));
      item.addOns.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });
      setExistInCart(item, notify: false);
    }
  }

  int setExistInCart(Item item, {bool notify = true}) {
    List<String> _variationList = [];
    for (int index = 0; index < item.choiceOptions.length; index++) {
      _variationList.add(item.choiceOptions[index].options[_variationIndex[index]].replaceAll(' ', ''));
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
    _cartIndex = Get.find<CartController>().isExistInCart(item.id, variationType, false, null);
    if(_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int> _addOnIdList = [];
      Get.find<CartController>().cartList[_cartIndex].addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      item.addOns.forEach((addOn) {
        if(_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(Get.find<CartController>().cartList[_cartIndex].addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }
    return _cartIndex;
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    update();
  }

  void setQuantity(bool isIncrement, int stock) {
    if (isIncrement) {
      if(Get.find<SplashController>().configModel.moduleConfig.module.stock && _quantity >= stock) {
        showCustomSnackBar('out_of_stock'.tr);
      }else {
        _quantity = _quantity + 1;
      }
    } else {
      _quantity = _quantity - 1;
    }
    update();
  }

  void setCartVariationIndex(int index, int i, Item item) {
    _variationIndex[index] = i;
    _quantity = 1;
    setExistInCart(item);
    update();
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    update();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    update();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    update();

    Response response = await itemRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _loadingList[index] = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    update();
    Response response = await itemRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  double getStartingPrice(Item item) {
    double _startingPrice = 0;
    if (item.choiceOptions.length != 0) {
      List<double> _priceList = [];
      item.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
    } else {
      _startingPrice = item.price;
    }
    return _startingPrice;
  }

  bool isAvailable(Item item) {
    return DateConverter.isAvailable(item.availableTimeStarts, item.availableTimeEnds);
  }

  double getDiscount(Item item) => item.storeDiscount == 0 ? item.discount : item.storeDiscount;

  String getDiscountType(Item item) => item.storeDiscount == 0 ? item.discountType : 'percent';

}
