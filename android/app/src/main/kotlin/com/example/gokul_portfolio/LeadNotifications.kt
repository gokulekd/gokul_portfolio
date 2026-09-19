package com.example.gokul_portfolio

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build

object LeadNotifications {
    const val CHANNEL_ID = "new_leads"

    /// Safe to call repeatedly. Called from both MainActivity and the messaging
    /// service, because a push can arrive before the app was ever opened.
    fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "New enquiries",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply { description = "Alerts when a visitor submits the contact form" }
        context.getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }
}
