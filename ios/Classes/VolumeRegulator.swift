/*
 *  VolumeRegulator.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 19.01.2021.
 */

import MediaPlayer
import AVKit
import AVFoundation

class VolumeRegulator {
    var outputVolumeObserve: NSKeyValueObservation?

    init() {
        listenVolumeButton()
    }

    func getVolume() -> Int {
        return Int(AVAudioSession.sharedInstance().outputVolume * 100)
    }

    func setVolume(_ value: Int) {
        MPVolumeView.setVolume(Float(value) / 100)
    }

    func listenVolumeButton() {
        try? AVAudioSession.sharedInstance().setActive(true)

        outputVolumeObserve = AVAudioSession.sharedInstance().observe(\.outputVolume) { (audioSession, changes) in
            print(Int(audioSession.outputVolume * 100))
        }
    }
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView(frame: .zero)
        let slider = volumeView.subviews.first as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.setValue(volume, animated: false)
        }
    }
}
