#import "VolumeRegulatorPlugin.h"
#if __has_include(<volume_regulator/volume_regulator-Swift.h>)
#import <volume_regulator/volume_regulator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "volume_regulator-Swift.h"
#endif

@implementation VolumeRegulatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVolumeRegulatorPlugin registerWithRegistrar:registrar];
}
@end
