import 'package:flutter/services.dart';

class DeviceInfoBridge {
  static const platform = MethodChannel('com.example.deviceinfosdk/device_info');

  static Future<void> initializeSDK(String serverUrl) async {
    try {
      await platform.invokeMethod('initializeSDK', {'serverUrl': serverUrl});
    } on PlatformException catch (e) {
      print("Failed to initialize SDK: '${e.message}'.");
    }
  }

  static Future<void> logData() async {
    try {
      await platform.invokeMethod('logData');
    } on PlatformException catch (e) {
      print("Failed to log data: '${e.message}'.");
    }
  }
}