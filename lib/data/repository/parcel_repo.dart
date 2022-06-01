import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';

class ParcelRepo {
  final ApiClient apiClient;
  ParcelRepo({@required this.apiClient});

  Future<Response> getParcelCategory() {
    return apiClient.getData(AppConstants.PARCEL_CATEGORY_URI);
  }

  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID');
  }

}