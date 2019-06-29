import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPluginQrcode {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_qrcode');

  static Future<String> get getQRCode async {
    final String version = await _channel.invokeMethod('getQRCode');
    return version;
  }
}
