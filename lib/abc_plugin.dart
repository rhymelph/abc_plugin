import 'dart:async';

import 'package:flutter/services.dart';

class AbcPlugin {
  static const MethodChannel _channel = const MethodChannel('abc_plugin');

  static Future<String> requestPay(
      String appId, String callbackId, String method, String tokenId) async {
    return await _channel.invokeMethod('requestPay', {
      "appId": appId,
      "callbackId": callbackId,
      "method": method,
      "tokenId": tokenId,
    });
  }

  static Future<bool> canPay() async {
    return await _channel.invokeMethod('canPay');
  }
}
