package com.RzRio.muslim

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.view.View
import android.widget.LinearLayout
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Implementation of App Widget functionality.
 */
class PrayerWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            var widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.prayer_widget)
            val prayerName = widgetData.getString("prayerName", "PrayerName")
            val prayerTime = widgetData.getString("prayerTime", "PrayerTime")

            if (prayerName != "PrayerName" && prayerTime != "PrayerTime") {
                views.setTextViewText(R.id.prayerName, "صلاة $prayerName")
                views.setViewVisibility(R.id.prayerTime, View.VISIBLE)
//                println(convertTo12HourFormat(prayerTime))
                views.setTextViewText(R.id.prayerTime, convertTo12HourFormat(prayerTime))
                appWidgetManager.updateAppWidget(appWidgetId, views)
            }
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    fun convertTo12HourFormat(time: String?): String {
        // Check if the input is null or empty
        if (time.isNullOrEmpty()) {
            return "Invalid time format"
        }

        // Parse the time with spaces around the colon (e.g., "14 : 30")
        val inputFormat = SimpleDateFormat("HH : mm", Locale.getDefault()) // 24-hour format with space
        val outputFormat = SimpleDateFormat("hh : mm a", Locale.getDefault()) // 12-hour format with AM/PM

        return try {
            // Safely parse the time
            val date: Date? = inputFormat.parse(time.trim())

            if (date != null) {
                // Return formatted time in 12-hour format, preserving the space around the colon
                outputFormat.format(date)
            } else {
                // Return error message if parsing fails
                "Invalid time format"
            }
        } catch (e: Exception) {
            // Handle any unexpected errors (like an invalid time string)
            "Invalid time format"
        }
    }

}