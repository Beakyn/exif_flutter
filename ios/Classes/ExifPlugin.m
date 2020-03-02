#import "ExifPlugin.h"
#if __has_include(<exif/exif-Swift.h>)
#import <exif/exif-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "exif-Swift.h"
#endif

#import "SYMetadata.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <PhotosUI/PhotosUI.h>

@implementation ExifPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftExifPlugin registerWithRegistrar:registrar];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"beakyn.com/exif" binaryMessenger: [registrar messenger]];
    
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if([call.method isEqualToString: @"getImageAttributes"]) {
            NSString *path = call.arguments[@"filePath"];
            NSURL *url = [NSURL fileURLWithPath:path];
            UIImage *img = [UIImage imageWithContentsOfFile: path];
            SYMetadata *metadata = [SYMetadata metadataWithFileURL:url];
            
            result(metadata.generatedDictionary);
        } else if ([call.method isEqualToString: @"setImageAttributes"]) {
            NSString *path = call.arguments[@"filePath"];
            NSNumber *longitude = call.arguments[@"longitude"];
            NSNumber *latitude = call.arguments[@"latitude"];
            NSURL *url = [NSURL fileURLWithPath:path];
            UIImage *img = [UIImage imageWithContentsOfFile: path];
            SYMetadata *metadata = [SYMetadata metadataWithFileURL:url];
            
            if(!metadata.metadataGPS) {
                metadata.metadataGPS = [[SYMetadataGPS alloc] init];
            }
            
            metadata.metadataGPS.longitude = longitude;
            metadata.metadataGPS.latitude = latitude;
            
            CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, kUTTypeJPEG, 1, NULL);
            CGImageDestinationAddImage(imageDestination, img.CGImage, (__bridge CFDictionaryRef) metadata.generatedDictionary);

            if (CGImageDestinationFinalize(imageDestination) == NO) {
                result([NSNumber numberWithBool: 0]);
            }

            CFRelease(imageDestination);
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
            } completionHandler: ^(BOOL success, NSError *error) {
                if (success){
                    result([NSNumber numberWithBool: 1]);
                } else {
                    result([NSNumber numberWithBool: 0]);
                }
            }];
        }
    }];
}
@end
