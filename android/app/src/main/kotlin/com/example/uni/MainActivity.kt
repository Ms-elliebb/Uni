package com.example.uni

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "uni_app/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "getInstalledApps" -> {
                        val apps = getInstalledApps()
                        result.success(apps)
                    }
                    "uninstallApp" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName != null) {
                            uninstallApp(packageName)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARGUMENT", "Package name is null", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("ERROR", e.message, null)
            }
        }
    }

    private fun getInstalledApps(): List<Map<String, String>> {
        val pm = applicationContext.packageManager
        val apps = pm.getInstalledApplications(PackageManager.GET_META_DATA)
        val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
        
        return apps.map { app ->
            try {
                val appInfo = pm.getApplicationInfo(app.packageName, 0)
                val appName = pm.getApplicationLabel(appInfo).toString()
                
                mapOf(
                    "name" to appName,
                    "iconPath" to "", 
                    "size" to "10MB",
                    "lastUsed" to dateFormat.format(Date()),
                    "packageName" to app.packageName
                )
            } catch (e: Exception) {
                null
            }
        }.filterNotNull()
    }

    private fun uninstallApp(packageName: String) {
        val intent = Intent(Intent.ACTION_DELETE).apply {
            data = Uri.parse("package:$packageName")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }
}