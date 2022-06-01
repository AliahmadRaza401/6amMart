import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/body/place_order_body.dart';
import 'package:sixam_mart/data/model/response/distance_model.dart';
import 'package:sixam_mart/data/model/response/order_details_model.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/data/model/response/response_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/data/model/response/timeslote_model.dart';
import 'package:sixam_mart/data/repository/order_repo.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/network_info.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});

  PaginatedOrderModel _runningOrderModel;
  PaginatedOrderModel _historyOrderModel;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  bool _isLoading = false;
  bool _showCancelled = false;
  String _orderType = 'delivery';
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  int _selectedDateSlot = 0;
  int _selectedTimeSlot = 0;
  double _distance;
  int _addressIndex = -1;
  XFile _orderAttachment;
  Uint8List _rawAttachment;

  PaginatedOrderModel get runningOrderModel => _runningOrderModel;
  PaginatedOrderModel get historyOrderModel => _historyOrderModel;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  String get orderType => _orderType;
  List<TimeSlotModel> get timeSlots => _timeSlots;
  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;
  int get selectedDateSlot => _selectedDateSlot;
  int get selectedTimeSlot => _selectedTimeSlot;
  double get distance => _distance;
  int get addressIndex => _addressIndex;
  XFile get orderAttachment => _orderAttachment;
  Uint8List get rawAttachment => _rawAttachment;

  Future<void> getRunningOrders(int offset) async {
    if(offset == 1) {
      _runningOrderModel = null;
      update();
    }
    Response response = await orderRepo.getRunningOrderList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _runningOrderModel = PaginatedOrderModel.fromJson(response.body);
      }else {
        _runningOrderModel.orders.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _runningOrderModel.offset = PaginatedOrderModel.fromJson(response.body).offset;
        _runningOrderModel.totalSize = PaginatedOrderModel.fromJson(response.body).totalSize;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getHistoryOrders(int offset) async {
    if(offset == 1) {
      _historyOrderModel = null;
      update();
    }
    Response response = await orderRepo.getHistoryOrderList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _historyOrderModel = PaginatedOrderModel.fromJson(response.body);
      }else {
        _historyOrderModel.orders.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _historyOrderModel.offset = PaginatedOrderModel.fromJson(response.body).offset;
        _historyOrderModel.totalSize = PaginatedOrderModel.fromJson(response.body).totalSize;
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    if(_trackModel == null || _trackModel.orderType != 'parcel') {
      Response response = await orderRepo.getOrderDetails(orderID);
      _isLoading = false;
      if (response.statusCode == 200) {
        _orderDetails = [];
        response.body.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
      } else {
        ApiChecker.checkApi(response);
      }
    }else {
      _isLoading = false;
      _orderDetails = [];
    }
    update();
    return _orderDetails;
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    update();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      Response response = await orderRepo.trackOrder(orderID);
      if (response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(response.body);
        _responseModel = ResponseModel(true, response.body.toString());
      } else {
        _responseModel = ResponseModel(false, response.statusText);
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function(bool isSuccess, String message, String orderID) callback) async {
    _isLoading = true;
    update();
    print(placeOrderBody.toJson());
    Response response = await orderRepo.placeOrder(placeOrderBody, _orderAttachment);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID);
      _orderAttachment = null;
      _rawAttachment = null;
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1');
    }
    update();
  }

  void stopLoader() {
    _isLoading = false;
    update();
  }

  void clearPrevData() {
    _addressIndex = -1;
    _paymentMethodIndex = 0;
    _selectedDateSlot = 0;
    _selectedTimeSlot = 0;
    _distance = null;
    _orderAttachment = null;
    _rawAttachment = null;
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    update();
  }

  void cancelOrder(int orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.cancelOrder(orderID.toString());
    _isLoading = false;
    Get.back();
    if (response.statusCode == 200) {
      OrderModel orderModel;
      for(OrderModel order in _runningOrderModel.orders) {
        if(order.id == orderID) {
          orderModel = order;
          break;
        }
      }
      _runningOrderModel.orders.remove(orderModel);
      _showCancelled = true;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      print(response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      update();
    }
  }

  Future<void> initializeTimeSlot(Store store) async {
    _timeSlots = [];
    _allTimeSlots = [];
    int _minutes = 0;
    DateTime _now = DateTime.now();
    for(int index=0; index<store.schedules.length; index++) {
      DateTime _openTime = DateTime(
        _now.year, _now.month, _now.day, DateConverter.convertStringTimeToDate(store.schedules[index].openingTime).hour,
        DateConverter.convertStringTimeToDate(store.schedules[index].openingTime).minute,
      );
      DateTime _closeTime = DateTime(
        _now.year, _now.month, _now.day, DateConverter.convertStringTimeToDate(store.schedules[index].closingTime).hour,
        DateConverter.convertStringTimeToDate(store.schedules[index].closingTime).minute,
      );
      if(_closeTime.difference(_openTime).isNegative) {
        _minutes = _openTime.difference(_closeTime).inMinutes;
      }else {
        _minutes = _closeTime.difference(_openTime).inMinutes;
      }
      if(_minutes > Get.find<SplashController>().configModel.scheduleOrderSlotDuration) {
        DateTime _time = _openTime;
        for(;;) {
          if(_time.isBefore(_closeTime)) {
            DateTime _start = _time;
            DateTime _end = _start.add(Duration(minutes: Get.find<SplashController>().configModel.scheduleOrderSlotDuration));
            if(_end.isAfter(_closeTime)) {
              _end = _closeTime;
            }
            _timeSlots.add(TimeSlotModel(day: store.schedules[index].day, startTime: _start, endTime: _end));
            _allTimeSlots.add(TimeSlotModel(day: store.schedules[index].day, startTime: _start, endTime: _end));
            _time = _time.add(Duration(minutes: Get.find<SplashController>().configModel.scheduleOrderSlotDuration));
          }else {
            break;
          }
        }
      }else {
        _timeSlots.add(TimeSlotModel(day: store.schedules[index].day, startTime: _openTime, endTime: _closeTime));
        _allTimeSlots.add(TimeSlotModel(day: store.schedules[index].day, startTime: _openTime, endTime: _closeTime));
      }
    }
    validateSlot(_allTimeSlots, 0, store.orderPlaceToScheduleInterval, notify: false);
  }

  void updateTimeSlot(int index) {
    _selectedTimeSlot = index;
    update();
  }

  void updateDateSlot(int index, int interval) {
    _selectedDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index, interval);
    }
    update();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex, int interval, {bool notify = true}) {
    _timeSlots = [];
    DateTime _now = DateTime.now();
    if(Get.find<SplashController>().configModel.moduleConfig.module.orderPlaceToScheduleInterval) {
      _now = _now.add(Duration(minutes: interval));
    }
    int _day = 0;
    if(dateIndex == 0) {
      _day = DateTime.now().weekday;
    }else {
      _day = DateTime.now().add(Duration(days: 1)).weekday;
    }
    if(_day == 7) {
      _day = 0;
    }
    slots.forEach((slot) {
      if (_day == slot.day && (dateIndex == 0 ? slot.endTime.isAfter(_now) : true)) {
        _timeSlots.add(slot);
      }
    });
    if(notify) {
      update();
    }
  }

  Future<bool> switchToCOD(String orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.switchToCOD(orderID);
    bool _isSuccess;
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<double> getDistanceInKM(LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    Response response = await orderRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _distance = DistanceModel.fromJson(response.body).rows[0].elements[0].distance.value / 1000;
      } else {
        _distance = Geolocator.distanceBetween(
          originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
        ) / 1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
        originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
      ) / 1000;
    }
    update();
    return _distance;
  }

  void pickImage() async {
    _orderAttachment = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(_orderAttachment != null) {
      _orderAttachment = await NetworkInfo.compressImage(_orderAttachment);
      _rawAttachment = await _orderAttachment.readAsBytes();
    }
    update();
  }

}