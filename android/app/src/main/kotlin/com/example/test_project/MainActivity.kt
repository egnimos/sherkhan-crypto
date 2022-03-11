package com.example.test_project

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.test_project/native"
    private val result: MethodChannel.Result? = null
    private val REQUESTCODE = 120

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            val methodName = call.method
            Log.d("nativeLog", "this method is running")
            Log.d("nativeLog", "method name: $methodName")
            result.success(502)
        }
    }
}
