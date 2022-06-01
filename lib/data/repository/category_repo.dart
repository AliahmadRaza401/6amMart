import 'package:get/get.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:flutter/material.dart';

class CategoryRepo {
  final ApiClient apiClient;
  CategoryRepo({@required this.apiClient});

  Future<Response> getCategoryList(bool allCategory) async {
    return await apiClient.getData(AppConstants.CATEGORY_URI, headers: allCategory ? {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.MODULE_ID: '',
      AppConstants.LOCALIZATION_KEY: Get.find<LocalizationController>().locale.languageCode
          ?? AppConstants.languages[0].languageCode
    } : null);
  }

  Future<Response> getSubCategoryList(String parentID) async {
    return await apiClient.getData('${AppConstants.SUB_CATEGORY_URI}$parentID');
  }

  Future<Response> getCategoryItemList(String categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ITEM_URI}$categoryID?limit=10&offset=$offset&type=$type');
  }

  Future<Response> getCategoryStoreList(String categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_STORE_URI}$categoryID?limit=10&offset=$offset&type=$type');
  }

  Future<Response> getSearchData(String query, String categoryID, bool isStore, String type) async {
    return await apiClient.getData(
      '${AppConstants.SEARCH_URI}${isStore ? 'stores' : 'items'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  Future<Response> saveUserInterests(List<int> interests) async {
    return await apiClient.postData(AppConstants.INTEREST_URI, {"interest": interests});
  }

}