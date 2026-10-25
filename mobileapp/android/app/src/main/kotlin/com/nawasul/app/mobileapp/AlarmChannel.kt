package com.nawasul.app.mobileapp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.os.Build
import android.provider.Settings

/**
 * Alarm-style channel for car alerts.
 * No full-screen intent and no Do Not Disturb bypass.
 * A repeating sound is set on the notification when push is connected.
 */
object AlarmChannel {
    const val ID = "nawasul_alarm"

    fun ensure(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(NotificationManager::class.java) ?: return
        val audio = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val channel = NotificationChannel(
            ID,
            "Car alerts",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Loud alerts when someone notifies you about your car."
            setSound(Settings.System.DEFAULT_ALARM_ALERT_URI, audio)
            enableVibration(true)
        }
        manager.createNotificationChannel(channel)
    }
}
