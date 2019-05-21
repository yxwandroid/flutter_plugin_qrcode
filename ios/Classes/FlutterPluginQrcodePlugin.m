#import "FlutterPluginQrcodePlugin.h"
#import <flutter_plugin_qrcode/flutter_plugin_qrcode-Swift.h>

@implementation FlutterPluginQrcodePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPluginQrcodePlugin registerWithRegistrar:registrar];
}
@end
