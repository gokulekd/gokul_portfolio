package com.example.gokul_portfolio

import android.Manifest
import android.app.ActivityManager
import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.IconCompat
import com.google.firebase.messaging.RemoteMessage
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService

/// Receives the notify-new-lead push (a data-only FCM message for Android) and
/// builds the notification itself so it can carry the owner's photo as the large
/// icon — a plain FCM `notification` payload can't set a large icon, and Android
/// only ever tints the small icon to a flat color.
///
/// Extends the Flutter plugin's own service so token refreshes and
/// foreground delivery to Dart keep working (it replaces that service in the
/// manifest). While the app is on screen the in-app snackbar covers the alert,
/// so nothing is posted then.
class LeadMessagingService : FlutterFirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        val title = message.data["title"]
        if (title.isNullOrEmpty() || isAppInForeground()) {
            super.onMessageReceived(message)
            return
        }
        showLeadNotification(title, message.data["body"].orEmpty(), message.data["submissionId"])
    }

    private fun isAppInForeground(): Boolean {
        val processes = getSystemService(ActivityManager::class.java).runningAppProcesses ?: return false
        return processes.any {
            it.processName == packageName &&
                it.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
        }
    }

    private fun showLeadNotification(title: String, body: String, submissionId: String?) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
            != PackageManager.PERMISSION_GRANTED
        ) return
        LeadNotifications.ensureChannel(this)

        val tapIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(MainActivity.EXTRA_OPEN_INBOX, true)
        }
        val tag = submissionId ?: "lead"
        val contentIntent = PendingIntent.getActivity(
            this,
            tag.hashCode(),
            tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        // Styled as a conversation so Android shows the sender's avatar (the owner's
        // photo) on the LEFT, with the small bell as a badge on it. A plain
        // notification can only show a photo as a right-hand large icon, because the
        // left-hand small icon is always a flat tinted glyph.
        val avatar = BitmapFactory.decodeResource(resources, R.drawable.notification_avatar)
        val sender = Person.Builder()
            .setName(title)
            .setKey("owner-avatar")
            .setIcon(IconCompat.createWithBitmap(avatar))
            .build()
        val style = NotificationCompat.MessagingStyle(Person.Builder().setName("You").build())
            .addMessage(body, System.currentTimeMillis(), sender)

        val notification = NotificationCompat.Builder(this, LeadNotifications.CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_lead)
            .setColor(ContextCompat.getColor(this, R.color.notification_accent))
            .setLargeIcon(avatar)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(style)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setAutoCancel(true)
            .setContentIntent(contentIntent)
            .build()

        NotificationManagerCompat.from(this).notify(tag, 0, notification)
    }
}
