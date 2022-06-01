import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class StoreRepo {
  final ApiClient apiClient;
  StoreRepo({@required this.apiClient});

  Future<Response> getStoreList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.STORE_URI}/$filterBy?offset=$offset&limit=10');
  }

  Future<Response> getPopularStoreList(String type) async {
    return await apiClient.getData('${AppConstants.POPULAR_STORE_URI}?type=$type');
  }

  Future<Response> getLatestStoreList(String type) async {
    return await apiClient.getData('${AppConstants.LATEST_STORE_URI}?type=$type');
  }

  Future<Response> getFeaturedStoreList() async {
    return await apiClient.getData('${AppConstants.STORE_URI}/all?featured=1&offset=1&limit=50');
  }

  Future<Response> getStoreDetails(String storeID) async {
    return await apiClient.getData('${AppConstants.STORE_DETAILS_URI}$storeID');
  }

  Future<Response> getStoreItemList(int storeID, int offset, int categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.STORE_ITEM_URI}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=10&type=$type',
    );
  }

  Future<Response> getStoreSearchItemList(String searchText, String storeID, int offset, String type) async {
    return await apiClient.getData(
      '${AppConstants.SEARCH_URI}items/search?store_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type',
    );
  }

  Future<Response> getStoreReviewList(String storeID) async {
    return await apiClient.getData('${AppConstants.STORE_REVIEW_URI}?store_id=$storeID');
  }

}