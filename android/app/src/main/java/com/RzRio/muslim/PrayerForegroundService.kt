//package com.RzRio.muslim
//
//
//import android.app.*
//import android.content.Context
//import android.content.Intent
//import android.os.*
//import androidx.core.app.NotificationCompat
//import com.RzRio.muslim.R
//
//class PrayerForegroundService : Service() {
//    private val CHANNEL_ID = "PrayerForegroundServiceChannel"
//    private val NOTIFICATION_ID = 1
//    private var counter = 1
//    private var isRunning = true
//    private var wakeLock: PowerManager.WakeLock? = null
//
//    override fun onBind(intent: Intent?): IBinder? = null
//
//    override fun onCreate() {
//        super.onCreate()
//        createNotificationChannel()
//
//        // Keep CPU Awake (Prevents Android from stopping the service)
//        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
//        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "PrayerService::WakeLock")
//        wakeLock?.acquire()
//
//        // Start the foreground service with initial notification
//        startForeground(NOTIFICATION_ID, createNotification(counter))
//
//        // Start counter in a separate thread
//        startCounterThread()
//    }
//
//    private fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val serviceChannel = NotificationChannel(
//                CHANNEL_ID,
//                "Prayer Foreground Service Channel",
//                NotificationManager.IMPORTANCE_LOW
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager.createNotificationChannel(serviceChannel)
//        }
//    }
//
//    private fun createNotification(counter: Int): Notification {
//        val notificationIntent = Intent(this, MainActivity::class.java)
//        val pendingIntent = PendingIntent.getActivity(
//            this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE
//        )
//
//        return NotificationCompat.Builder(this, CHANNEL_ID)
//            .setContentTitle("ISHA")
//            .setContentText("Counter: $counter")
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setContentIntent(pendingIntent)
//            .setOngoing(true) // Prevents the user from accidentally swiping it away
//            .build()
//    }
//
//    private fun startCounterThread() {
//        Thread {
//            while (isRunning) {
//                // Update the notification
//                val notification = createNotification(counter++)
//                val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
//                notificationManager.notify(NOTIFICATION_ID, notification)
//
//                // Sleep for 1 second before updating again
//                try {
//                    Thread.sleep(1000)
//                } catch (e: InterruptedException) {
//                    e.printStackTrace()
//                }
//            }
//        }.start()
//    }
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        return START_STICKY // Ensures the service restarts if killed
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        isRunning = false // Stop the counter loop
//        wakeLock?.release()
//    }
//}
