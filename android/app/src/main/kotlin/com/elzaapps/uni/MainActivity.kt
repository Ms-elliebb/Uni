package com.elzaapps.uni

import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ApplicationInfo
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.text.format.Formatter
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter

class MainActivity : FlutterActivity() {
    private val CHANNEL = "uni_app/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    val apps = packageManager.getInstalledPackages(PackageManager.GET_META_DATA)
                    val appList = apps
                        .filter { pkg ->
                            pkg.applicationInfo?.let { appInfo ->
                                (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0
                            } ?: false
                        }
                        .mapNotNull { packageInfo ->
                            packageInfo.applicationInfo?.let { appInfo ->
                                val appSize = try {
                                    val appFile = appInfo.sourceDir
                                    val size = java.io.File(appFile).length()
                                    Formatter.formatFileSize(context, size)
                                } catch (e: Exception) {
                                    "Unknown"
                                }
                                
                                val instant = Instant.ofEpochMilli(packageInfo.lastUpdateTime)
                                val formattedDate = DateTimeFormatter
                                    .ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .withZone(ZoneId.systemDefault())
                                    .format(instant)
                                
                                mapOf(
                                    "name" to packageManager.getApplicationLabel(appInfo).toString(),
                                    "packageName" to packageInfo.packageName,
                                    "size" to appSize,
                                    "lastUsed" to formattedDate,
                                    "iconPath" to ""
                                )
                            }
                        }
                    result.success(appList)
                }
                "uninstallApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val intent = Intent(Intent.ACTION_DELETE)
                        intent.data = Uri.parse("package:$packageName")
                        activity.startActivity(intent)
                        result.success(null)
                    } else {
                        result.error("INVALID_PACKAGE", "Package name is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}