#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>

@interface CDVSilentAudioPlugin : CDVPlugin

- (void)startSilentAudio:(CDVInvokedUrlCommand*)command;
- (void)pauseSilentAudio:(CDVInvokedUrlCommand*)command;
- (void)stopSilentAudio:(CDVInvokedUrlCommand*)command;

@end
