package com.example.gokul_portfolio

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createLeadsChannel()
    }

    /// FCM notification messages are shown by the system on this channel (its id
    /// is set as the default in AndroidManifest and by the notify-new-lead
    /// function). HIGH importance makes new-enquiry alerts heads-up.
    private fun createLeadsChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            "new_leads",
            "New enquiries",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply { description = "Alerts when a visitor submits the contact form" }
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }
}
