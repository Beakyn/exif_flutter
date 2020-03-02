import Flutter
import UIKit

public class SwiftExifPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "beakyn.com/exif", binaryMessenger: registrar.messenger())
        let instance = SwiftExifPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    }
}
