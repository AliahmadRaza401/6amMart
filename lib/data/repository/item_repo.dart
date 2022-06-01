import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/body/review_body.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemRepo extends GetxService {
  final ApiClient apiClient;
  ItemRepo({@required this.apiClient});

  Future<Response> getPopularItemList(String type) async {
    return await apiClient.getData('${AppConstants.POPULAR_ITEM_URI}?type=$type');
  }

  Future<Response> getReviewedItemList(String type) async {
    return await apiClient.getData('${AppConstants.REVIEWED_ITEM_URI}?type=$type');
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.REVIEW_URI, reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.DELIVER_MAN_REVIEW_URI, reviewBody.toJson());
  }
}
