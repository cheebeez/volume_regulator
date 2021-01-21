/*
 *  VolumeRegulator.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 19.01.2021.
 */

import MediaPlayer
import AVKit

class VolumeRegulator {
    var outputVolumeObserve: NSKeyValueObservation?

    init() {
        try? AVAudioSession.sharedInstance().setActive(true)
        outputVolumeObserve = AVAudioSession.sharedInstance().observe(\.outputVolume, changeHandler: onVolumeChange)
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

    func onVolumeChange(audioSession: AVAudioSession, changes: NSKeyValueObservedChange<Float>) {
        let volume = Int(audioSession.outputVolume * 100)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "volume_changed"), object: nil, userInfo: ["value": volume])
    }
}
