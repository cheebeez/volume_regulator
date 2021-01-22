/*
 *  VolumeRegulator.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 19.01.2021.
 */

import MediaPlayer
import AVKit

class VolumeRegulator {

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onVolumeChange(_:)), name: 
                NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }

    func getVolume() -> Int {
        return Int(AVAudioSession.sharedInstance().outputVolume * 100)
    }

    func setVolume(_ value: Int) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first as? UISlider

        // Delay for ios 11+.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.setValue(Float(value) / 100, animated: false)
        }
    }

    @objc private func onVolumeChange(_ notification: NSNotification) {
        let volume = Int(notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float * 100)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "volume_changed"), object: nil, userInfo: ["value": volume])
    }
}
