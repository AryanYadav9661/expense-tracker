
package com.expense_tracker_plus

import android.content.Intent
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

class UpiNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        try {
            val pkg = sbn.packageName ?: return
            val extras = sbn.notification.extras
            val title = extras.getString("android.title") ?: ""
            val big = extras.getCharSequence("android.bigText")?.toString() ?: ""
            val text = extras.getCharSequence("android.text")?.toString() ?: ""
            val content = (title + " " + big + " " + text).trim()

            val knownPackages = listOf(
                "net.one97.paytm",
                "com.phonepe.app",
                "com.google.android.apps.nbu.paisa.user",
                "in.org.npci.upiapp"
            )

            if (knownPackages.contains(pkg) || content.contains("UPI", ignoreCase = true)
                || content.contains("debited", ignoreCase = true)
                || content.contains("credited", ignoreCase = true)
                || content.contains("paid", ignoreCase = true)) {

                val i = Intent("com.expensetracker.UPI_NOTIFICATION")
                i.putExtra("text", content)
                i.putExtra("package", pkg)
                sendBroadcast(i)
            }
        } catch (e: Exception) {
            // ignore
        }
    }
}
