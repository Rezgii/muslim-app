package com.RzRio.muslim

import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity()
//{
//    private val CHANNEL = "myService"
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "startService" -> {
//                    val prayerName = call.argument<String>("prayerName") ?: "Next Prayer"
//                    val countdownTime = call.argument<Int>("countdownTime") ?: 0
//
//                    val intent = Intent(this, PrayerForegroundService::class.java).apply {
//                        putExtra("prayerName", prayerName)
//                        putExtra("countdownTime", countdownTime)
//                    }
//
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                        startForegroundService(intent) // ✅ Required for Android 8+
//                    } else {
//                        startService(intent)
//                    }
//                    result.success(null)
//                }
//                "stopService" -> {
//                    stopService(Intent(this, PrayerForegroundService::class.java))
//                    result.success(null)
//                }
//                else -> result.notImplemented()
//            }
//        }
//    }
//}
