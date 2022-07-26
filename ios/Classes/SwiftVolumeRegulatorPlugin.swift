/*
 *  SwiftVolumeRegulatorPlugin.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 19.01.2021.
 */

import Flutter
import UIKit

public class SwiftVolumeRegulatorPlugin: NSObject, FlutterPlugin {
    private var volumeRegulator = VolumeRegulator()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "volume_regulator", binaryMessenger: registrar.messenger())
        let instance = SwiftVolumeRegulatorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let eventChannel = FlutterEventChannel.init(name: "volume_regulator/volumeEvents", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(VolumeStreamHandler())
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "get":
                result(volumeRegulator.getVolume())
            case "set":
                volumeRegulator.setVolume(call.arguments as! Int)
                result(1)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}

/** Handler for volume changes, passed to setStreamHandler() */
class VolumeStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieve(_:)), name: NSNotification.Name(rawValue: "volume_changed"), object: nil)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    // Notification receiver for volume changes, passed to addObserver()
    @objc private func onRecieve(_ notification: Notification) {
        if let volume = notification.userInfo!["value"] {
            eventSink?(volume)
        }
    }
}