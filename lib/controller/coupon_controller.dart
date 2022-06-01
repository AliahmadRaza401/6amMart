import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/coupon_model.dart';
import 'package:sixam_mart/data/repository/coupon_repo.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponController extends GetxController implements GetxService {
  final CouponRepo couponRepo;
  CouponController({@required this.couponRepo});

  List<CouponModel> _couponList;
  CouponModel _coupon;
  double _discount = 0.0;
  bool _isLoading = false;
  bool _freeDelivery = false;

  CouponModel get coupon => _coupon;
  double get discount => _discount;
  bool get isLoading => _isLoading;
  bool get freeDelivery => _freeDelivery;
  List<CouponModel> get couponList => _couponList;

  Future<void> getCouponList() async {
    Response response = await couponRepo.getCouponList();
    if (response.statusCode == 200) {
      _couponList = [];
      response.body.forEach((category) => _couponList.add(CouponModel.fromJson(category)));
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<double> applyCoupon(String coupon, double order, double deliveryCharge, int storeID) async {
    _isLoading = true;
    _discount = 0;
    update();
    Response response = await couponRepo.applyCoupon(coupon, storeID);
    if (response.statusCode == 200) {
      _coupon = CouponModel.fromJson(response.body);
      if(_coupon.couponType == 'free_delivery') {
        if(deliveryCharge > 0) {
          if (_coupon.minPurchase < order) {
            _discount = 0;
            _freeDelivery = true;
          } else {
            showCustomSnackBar('${'the_minimum_item_purchase_amount_for_this_coupon_is'.tr} '
                '${PriceConverter.convertPrice(_coupon.minPurchase)} '
                '${'but_you_have'.tr} ${PriceConverter.convertPrice(order)}');
            _coupon = null;
            _discount = 0;
          }
        }else {
          showCustomSnackBar('invalid_code_or'.tr);
        }
      }else {
        if (_coupon.minPurchase != null && _coupon.minPurchase < order) {
          if (_coupon.discountType == 'percent') {
            if (_coupon.maxDiscount != null && _coupon.maxDiscount > 0) {
              _discount = (_coupon.discount * order / 100) < _coupon.maxDiscount ? (_coupon.discount * order / 100) : _coupon.maxDiscount;
            } else {
              _discount = _coupon.discount * order / 100;
            }
          } else {
            _discount = _coupon.discount;
          }
        } else {
          _discount = 0.0;
          showCustomSnackBar('${'the_minimum_item_purchase_amount_for_this_coupon_is'.tr} '
              '${PriceConverter.convertPrice(_coupon.minPurchase)} '
              '${'but_you_have'.tr} ${PriceConverter.convertPrice(order)}');
        }
      }
    } else {
      _discount = 0.0;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return _discount;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _freeDelivery = false;
    if(notify) {
      update();
    }
  }
}