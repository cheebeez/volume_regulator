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
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "get":
                result(volumeRegulator.getVolume())
            case "set":
                volumeRegulator.setVolume(call.arguments as! Int)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
