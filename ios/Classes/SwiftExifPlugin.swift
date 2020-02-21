import Flutter
import UIKit

public class SwiftExifPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "beakyb.com/exif", binaryMessenger: registrar.messenger())
        let instance = SwiftExifPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getImageAttributes" {
            let params = call.arguments as? [String: String]
            result(getImageAttributes(filepath: params?["filePath"]))
        } else if call.method == "setImageAttributes" {
            if let params = call.arguments as? [String: Any] {
                let filepath: String? = params["filePath"] as? String
                let attributes: [String: String]? = params["attributes"] as? [String:String]
                result(setImageAttributes(filepath: filepath!, attributes: [:]))
            }
        }
    }
    
    public func getImageAttributes(filepath: String?) -> [AnyHashable: Any] {
        guard let path = filepath else { return [:] }
        let image: UIImage = UIImage(named: path)!
        let imageData: Data = image.jpegData(compressionQuality: 1)!

        let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let metadatas = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as! [AnyHashable: Any]
        
        return metadatas
    }
    
    public func setImageAttributes(filepath: String, attributes: [String: Any]) -> FlutterStandardTypedData {
        let image: UIImage = UIImage(named: filepath)!
        let imageData: Data = image.jpegData(compressionQuality: 1)!
        let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
        var metadatas = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any]
        
//        var metadata = metadatas?[(kCGImagePropertyExifDictionary as String)] as? [AnyHashable: Any]
//        if !(metadata != nil) { metadata = [AnyHashable: Any]() }
//        metadata?[(kCGImagePropertyExifUserComment as String)] = "Hello Aloc"
//        metadatas![kCGImagePropertyExifDictionary] = metadata

        let UTI: CFString = CGImageSourceGetType(imageSource)!
        let destinationData = NSMutableData(data: imageData)
        let destination: CGImageDestination = CGImageDestinationCreateWithData(destinationData as CFMutableData, UTI, 1, nil)!
        CGImageDestinationAddImageFromSource(destination, imageSource, 0, (metadatas as CFDictionary?))
        CGImageDestinationFinalize(destination)
//        let destinationImage: UIImage? = UIImage(data: destinationData as! Data)
//        let file: URL = URL(fileURLWithPath: filepath)
//
//        try? destinationImage?.jpegData(compressionQuality: 1.0)?.write(to: file)
        return FlutterStandardTypedData(bytes: destinationData as! Data)
    }

}
