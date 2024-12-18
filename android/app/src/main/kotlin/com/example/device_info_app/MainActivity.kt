package com.example.device_info_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.deviceinfosdk.permissions.DataLogger
import com.example.deviceinfosdk.DeviceInfoSDK

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.deviceinfosdk/device_info"
    private lateinit var deviceInfoSDK: DeviceInfoSDK // Declare the instance

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize DeviceInfoSDK (no arguments needed)
        deviceInfoSDK = DeviceInfoSDK()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "initializeSDK" -> {
                        val serverUrl = call.argument<String>("serverUrl")
                        DataLogger.setServerUrl(serverUrl)
                        result.success(null)
                    }
                    "logData" -> {
                        // Call logData and ensure proper context is passed
                        DeviceInfoSDK.logData(this)  // Pass the activity context
                        result.success(null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }
}
