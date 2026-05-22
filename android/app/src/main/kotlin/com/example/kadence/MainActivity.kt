package com.example.kadence

import android.content.ContentUris
import android.content.ContentValues
import android.provider.CalendarContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.kadence/calendar_color")
            .setMethodCallHandler { call, result ->
                if (call.method == "setEventColor") {
                    val eventId = call.argument<String>("eventId")
                    val color = (call.argument<Number>("color"))?.toInt()
                    if (eventId == null || color == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val values = ContentValues().apply {
                            put(CalendarContract.Events.EVENT_COLOR, color)
                        }
                        val uri = ContentUris.withAppendedId(
                            CalendarContract.Events.CONTENT_URI,
                            eventId.toLong(),
                        )
                        contentResolver.update(uri, values, null, null)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
