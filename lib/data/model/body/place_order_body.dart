import 'dart:convert';

import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:flutter/material.dart';

class PlaceOrderBody {
  List<Cart> _cart;
  double _couponDiscountAmount;
  double _orderAmount;
  String _orderType;
  String _paymentMethod;
  String _orderNote;
  String _couponCode;
  int _storeId;
  double _distance;
  String _scheduleAt;
  double _discountAmount;
  double _taxAmount;
  String _address;
  String _latitude;
  String _longitude;
  String _contactPersonName;
  String _contactPersonNumber;
  AddressModel _receiverDetails;
  String _addressType;
  String _parcelCategoryId;
  String _chargePayer;

  PlaceOrderBody(
      {@required List<Cart> cart,
        @required double couponDiscountAmount,
        @required String couponCode,
        @required double orderAmount,
        @required String orderType,
        @required String paymentMethod,
        @required int storeId,
        @required double distance,
        @required String scheduleAt,
        @required double discountAmount,
        @required double taxAmount,
        @required String orderNote,
        @required String address,
        @required AddressModel receiverDetails,
        @required String latitude,
        @required String longitude,
        @required String contactPersonName,
        @required String contactPersonNumber,
        @required String addressType,
        @required String parcelCategoryId,
        @required String chargePayer,
      }) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._storeId = storeId;
    this._distance = distance;
    this._scheduleAt = scheduleAt;
    this._discountAmount = discountAmount;
    this._taxAmount = taxAmount;
    this._address = address;
    this._receiverDetails = receiverDetails;
    this._latitude = latitude;
    this._longitude = longitude;
    this._contactPersonName = contactPersonName;
    this._contactPersonNumber = contactPersonNumber;
    this._addressType = addressType;
    this._parcelCategoryId = parcelCategoryId;
    this._chargePayer = chargePayer;
  }

  List<Cart> get cart => _cart;
  double get couponDiscountAmount => _couponDiscountAmount;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  int get storeId => _storeId;
  double get distance => _distance;
  String get scheduleAt => _scheduleAt;
  double get discountAmount => _discountAmount;
  double get taxAmount => _taxAmount;
  String get address => _address;
  AddressModel get receiverDetails => _receiverDetails;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;
  String get parcelCategoryId => _parcelCategoryId;
  String get chargePayer => _chargePayer;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _storeId = json['store_id'];
    _distance = json['distance'];
    _scheduleAt = json['schedule_at'];
    _discountAmount = json['discount_amount'].toDouble();
    _taxAmount = json['tax_amount'].toDouble();
    _address = json['address'];
    _receiverDetails = json['receiver_details'] != null ? new AddressModel.fromJson(json['receiver_details']) : null;
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _addressType = json['address_type'];
    _parcelCategoryId = json['parcel_category_id'];
    _chargePayer = json['charge_payer'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    if (this._cart != null) {
      data['cart'] = jsonEncode(this._cart.map((v) => v.toJson()).toList());
    }
    if(this._couponDiscountAmount != null) {
      data['coupon_discount_amount'] = this._couponDiscountAmount.toString();
    }
    data['order_amount'] = this._orderAmount.toString();
    data['order_type'] = this._orderType;
    data['payment_method'] = this._paymentMethod;
    if(this._orderNote != null && this._orderNote.isNotEmpty) {
      data['order_note'] = this._orderNote;
    }
    if(this._couponCode != null) {
      data['coupon_code'] = this._couponCode;
    }
    if(this._storeId != null) {
      data['store_id'] = this._storeId.toString();
    }
    data['distance'] = this._distance.toString();
    if(this._scheduleAt != null) {
      data['schedule_at'] = this._scheduleAt;
    }
    data['discount_amount'] = this._discountAmount.toString();
    data['tax_amount'] = this._taxAmount.toString();
    data['address'] = this._address;
    if (this._receiverDetails != null) {
      data['receiver_details'] = jsonEncode(this._receiverDetails.toJson());
    }
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['contact_person_name'] = this._contactPersonName;
    data['contact_person_number'] = this._contactPersonNumber;
    data['address_type'] = this._addressType;
    if (this._parcelCategoryId != null) {
      data['parcel_category_id'] = this._parcelCategoryId;
    }
    if (this._chargePayer != null) {
      data['charge_payer'] = this._chargePayer;
    }
    return data;
  }
}

class Cart {
  int _itemId;
  int _itemCampaignId;
  String _price;
  String _variant;
  List<Variation> _variation;
  int _quantity;
  List<int> _addOnIds;
  List<AddOns> _addOns;
  List<int> _addOnQtys;

  Cart(
      int itemId,
      int itemCampaignId,
        String price,
        String variant,
        List<Variation> variation,
        int quantity,
        List<int> addOnIds,
        List<AddOns> addOns,
        List<int> addOnQtys) {
    this._itemId = itemId;
    this._itemCampaignId = itemCampaignId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._quantity = quantity;
    this._addOnIds = addOnIds;
    this._addOns = addOns;
    this._addOnQtys = addOnQtys;
  }

  int get itemId => _itemId;
  int get itemCampaignId => _itemCampaignId;
  String get price => _price;
  String get variant => _variant;
  List<Variation> get variation => _variation;
  int get quantity => _quantity;
  List<int> get addOnIds => _addOnIds;
  List<AddOns> get addOns => _addOns;
  List<int> get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _itemId = json['item_id'];
    _itemCampaignId = json['item_campaign_id'];
    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _quantity = json['quantity'];
    _addOnIds = json['add_on_ids'].cast<int>();
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this._itemId;
    data['item_campaign_id'] = this._itemCampaignId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['quantity'] = this._quantity;
    data['add_on_ids'] = this._addOnIds;
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}
