/*
 *  VolumeRegulator.kt
 *
 *  Created by Ilia Chirkunov <xc@yar.net> on 18.01.2021.
 */

package com.cheebeez.volume_regulator

import androidx.localbroadcastmanager.content.LocalBroadcastManager
import android.content.Context
import android.content.Intent
import android.database.ContentObserver
import android.media.AudioManager
import android.net.Uri
import android.os.Handler
import kotlin.math.roundToInt

/** This class allows to observe and adjust the volume of the device from 0 to 100. */
class VolumeRegulator(val context: Context, handler: Handler) : ContentObserver(handler) {

    companion object {
        const val ACTION_VOLUME_CHANGED = "volume_changed"
        const val ACTION_VOLUME_CHANGED_EXTRA = "volume"
    }

    private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    private val localBroadcastManager = LocalBroadcastManager.getInstance(context)
    private val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
    private var appVolume = 0
    private var oldVolume = 0

    fun appToNative(value: Int): Int {
        return (maxVolume * value / 100.0).roundToInt()
    }

    fun nativeToApp(value: Int): Int {
        return (100.0 * value / maxVolume).roundToInt()
    }

    fun getVolume(): Int {
        val nativeVolume: Int = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)

        // The stored variable has a higher priority.
        return if (appToNative(appVolume) == nativeVolume) appVolume 
                else nativeToApp(nativeVolume)
    }

    fun setVolume(value: Int) {
        appVolume = value
        audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, appToNative(appVolume), 0)

        // Send a volume change event.
        onChange(false)
    }

    override fun onChange(selfChange: Boolean) {
        super.onChange(selfChange)
        val volume = getVolume()

        // Prevent re-sending the same value.
        oldVolume = if (volume != oldVolume) volume else return

        // Save a new value as appVolume.
        appVolume = volume

        val volumeIntent = Intent(ACTION_VOLUME_CHANGED)
        volumeIntent.putExtra(ACTION_VOLUME_CHANGED_EXTRA, volume)
        localBroadcastManager.sendBroadcast(volumeIntent)
    }
}
