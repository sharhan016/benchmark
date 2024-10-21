package com.techiez.benchmark

import android.content.Context
import android.os.Build
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "benchmark-imei"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getImei") {
                println("MainActivity getImei")
                val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                val imei = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    telephonyManager.imei
                } else {
                    telephonyManager.deviceId
                }
                result.success(imei)
            } else {
                result.notImplemented()
            }
        }
    }
}