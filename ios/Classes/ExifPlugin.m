#import "ExifPlugin.h"

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
            NSDictionary *attributes = call.arguments[@"attributes"];
            
            NSNumber *latitude = attributes[@"GPSLatitude"];
            NSNumber *longitude = attributes[@"GPSLongitude"];
            NSString *dateTimeOriginal = attributes[@"DateTimeOriginal"];
            NSString *userComment = attributes[@"UserComment"];
            
            
            NSURL *url = [NSURL fileURLWithPath:path];
            UIImage *img = [UIImage imageWithContentsOfFile: path];
            SYMetadata *metadata = [SYMetadata metadataWithFileURL:url];
            
            if(!metadata.metadataGPS) metadata.metadataGPS = [[SYMetadataGPS alloc] init];
            if(!metadata.metadataExif) metadata.metadataExif = [[SYMetadataGPS alloc] init];
            
            if(latitude) metadata.metadataGPS.latitude = latitude;
            if(longitude) metadata.metadataGPS.longitude = longitude;
            if(userComment) metadata.metadataExif.userComment = userComment;
            if(dateTimeOriginal) metadata.metadataExif.dateTimeOriginal = dateTimeOriginal;
            
            CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, kUTTypeJPEG, 1, NULL);
            CGImageDestinationAddImage(imageDestination, img.CGImage, (__bridge CFDictionaryRef) metadata.generatedDictionary);

            if (CGImageDestinationFinalize(imageDestination) == NO) {
                result(NULL);
            }

            CFRelease(imageDestination);
            result(NULL);
        }
    }];
}
@end
