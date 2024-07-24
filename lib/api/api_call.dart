// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tezda/api/endpoint.dart';
import 'package:tezda/api/error_handler.dart';
import 'package:tezda/helper/utilities.dart';

class CallApi {
  static var client = http.Client();

// get user orders
  callApi({
    required BuildContext context,
    required String? endpoint,
  }) async {
    var sendResponse;

    try {
      var url = Uri.https(
        EndPoint.baseUrl,
        endpoint!,
      );

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      http.Response res = await client.get(
        url,
        headers: requestHeaders,
      );

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () async {
            if (res.statusCode == 200) {
              var data = jsonDecode(res.body);
              sendResponse = data;
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      log('Error is ${e.toString()}');
    }

    return sendResponse;
  }
}
