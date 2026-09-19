package com.example.gokul_portfolio

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var launchedFromLeadPush = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        LeadNotifications.ensureChannel(this)
        launchedFromLeadPush = intent?.getBooleanExtra(EXTRA_OPEN_INBOX, false) == true
    }

    /// Bridge so Dart (PushNavigation) can open the leads inbox when the owner
    /// taps a new-enquiry notification: `consumeLaunchAction` covers a cold
    /// start, `openInbox` is pushed to Dart if the app was already running.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).also {
            it.setMethodCallHandler { call, result ->
                if (call.method == "consumeLaunchAction") {
                    result.success(launchedFromLeadPush)
                    launchedFromLeadPush = false
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (intent.getBooleanExtra(EXTRA_OPEN_INBOX, false)) {
            channel?.invokeMethod("openInbox", null)
        }
    }

    companion object {
        const val EXTRA_OPEN_INBOX = "open_leads_inbox"
        const val CHANNEL_NAME = "gokul_portfolio/push"
    }
}
