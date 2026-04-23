package com.example.flutter_telegram_auth

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import org.telegram.login.TelegramLogin

class FlutterTelegramAuthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: Result? = null
    private var expectedHost: String? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_telegram_auth")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val clientId = call.argument<String>("clientId") ?: return result.error("INVALID_ARG", "clientId required", null)
                val redirectUri = call.argument<String>("redirectUri") ?: return result.error("INVALID_ARG", "redirectUri required", null)
                val scopes = call.argument<List<String>>("scopes") ?: listOf("profile", "phone")
                
                expectedHost = Uri.parse(redirectUri).host
                
                try {
                    TelegramLogin.init(
                        clientId = clientId,
                        redirectUri = redirectUri,
                        scopes = scopes
                    )
                    result.success(null)
                } catch (e: Exception) {
                    result.error("INIT_ERROR", e.message, null)
                }
            }
            "login" -> {
                if (activity == null) {
                    result.error("NO_ACTIVITY", "Activity is not available", null)
                    return
                }
                pendingResult = result
                try {
                    TelegramLogin.startLogin(activity!!)
                } catch (e: Exception) {
                    pendingResult?.error("LOGIN_ERROR", e.message, null)
                    pendingResult = null
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        val uri = intent.data ?: return false
        if (expectedHost != null && uri.host != expectedHost) return false
        
        TelegramLogin.handleLoginResponse(
            uri = uri,
            onSuccess = { loginData ->
                pendingResult?.success(loginData.idToken)
                pendingResult = null
            },
            onError = { error ->
                pendingResult?.error("AUTH_ERROR", error.message, null)
                pendingResult = null
            }
        )
        return true
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
