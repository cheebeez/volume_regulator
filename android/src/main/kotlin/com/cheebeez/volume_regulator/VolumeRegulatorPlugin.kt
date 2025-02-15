/*
 *  VolumeRegulatorPlugin.kt
 *
 *  Created by Ilia Chirkunov <xc@yar.net> on 16.01.2021.
 */

package com.cheebeez.volume_regulator

import androidx.annotation.NonNull
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler

/** VolumeRegulatorPlugin */
class VolumeRegulatorPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private val volumeRegulator: VolumeRegulator by lazy { 
        VolumeRegulator(context, Handler())
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "volume_regulator")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "volume_regulator/volumeEvents")
        eventChannel.setStreamHandler(volumeStreamHandler)
    
        context.contentResolver.registerContentObserver(android.provider.Settings.System.CONTENT_URI, true, volumeRegulator)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context.contentResolver.unregisterContentObserver(volumeRegulator)
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "get" -> {
                result.success(volumeRegulator.getVolume())
            }
            "set" -> {
                volumeRegulator.setVolume(call.arguments as Int)
                result.success(1)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /** Handler for volume changes, passed to setStreamHandler() */
    private var volumeStreamHandler = object : StreamHandler {
        private var eventSink: EventSink? = null

        override fun onListen(arguments: Any?, events: EventSink?) {
            eventSink = events
            LocalBroadcastManager.getInstance(context).registerReceiver(broadcastReceiver, 
                    IntentFilter(VolumeRegulator.ACTION_VOLUME_CHANGED))
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
            LocalBroadcastManager.getInstance(context).unregisterReceiver(broadcastReceiver)
        }

        // Broadcast receiver for volume changes, passed to registerReceiver()
        private var broadcastReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent != null) {
                    val received = intent.getIntExtra(VolumeRegulator.ACTION_VOLUME_CHANGED_EXTRA, 0)
                    eventSink?.success(received)
                }
            }
        }
    }
}
