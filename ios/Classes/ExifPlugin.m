#import "ExifPlugin.h"
#if __has_include(<exif/exif-Swift.h>)
#import <exif/exif-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "exif-Swift.h"
#endif

@implementation ExifPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftExifPlugin registerWithRegistrar:registrar];
}
@end
