/*
 *  VolumeRegulator.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 19.01.2021.
 */
 
import MediaPlayer
import AVKit

class VolumeRegulator: NSObject {
    let audioSession = AVAudioSession.sharedInstance()

    override init() {
        super.init()
        try? audioSession.setActive(true)
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }

    func getVolume() -> Int {
        return Int(audioSession.outputVolume * 100)
    }

    func setVolume(_ value: Int) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first as? UISlider

        // Delay for ios 11+.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.setValue(Float(value) / 100, animated: false)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            let volume = Int(audioSession.outputVolume * 100)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "volume_changed"), object: nil, userInfo: ["value": volume])
        }
    }
}
