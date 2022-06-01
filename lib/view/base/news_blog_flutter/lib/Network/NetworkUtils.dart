import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/constant.dart';

import '../main.dart';

Future<Map<String, String>> buildHeaderTokens({bool requireToken = false}) async {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
  };

  if (requireToken) {
    String token = getStringAsync(TOKEN);
    int? id = appStore.userId;
    print("Token" + token.toString());
    print("Token" + id.toString());
    header.putIfAbsent('token', () => token);
    header.putIfAbsent('id', () => id.toString());
  }
  return header;
}

getRequest(String endPoint, {bool requireToken = false}) async {
  if (await isNetworkAvailable()) {
    var header = await buildHeaderTokens(requireToken: requireToken);

    print(header);
    print('$BaseUrl$endPoint');

    Response response = await get(Uri.parse('$BaseUrl$endPoint'), headers: header);

    print('${response.statusCode} ${jsonDecode(response.body)}');
    return response;
  } else {
    throw noInternetMsg;
  }
}

Future<Response> postRequest(String endPoint, Map request, {bool requireToken = false}) async {
  if (await isNetworkAvailable()) {
    log('URL: $BaseUrl$endPoint');
    log('Request: $request');
    log('id: ${appStore.userId}');

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };

    if (requireToken) {
      var header = {"token": "${getStringAsync(TOKEN)}", "id": "${appStore.userId}"};
      headers.addAll(header);
    }
    log(headers);

    Response response = await post(Uri.parse('$BaseUrl$endPoint'), body: jsonEncode(request), headers: headers);
    log('Response: ${response.statusCode} ${response.body}');
    return response;
  } else {
    throw noInternetMsg;
  }
}

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw noInternetMsg;
  }
  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    if (response.body.isJson()) {
      throw parseHtmlString(jsonDecode(response.body)['message']);
    } else {
      //throw errorMsg;
      if (response.statusCode == 403) {
        if (response.body.contains('jwt_auth')) {
          throw "Login msg Test";
        }
      }
    }
  }
}
