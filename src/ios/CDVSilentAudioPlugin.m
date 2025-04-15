#import "CDVSilentAudioPlugin.h"

@interface CDVSilentAudioPlugin ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation CDVSilentAudioPlugin

- (void)pluginInitialize {
    [super pluginInitialize];
}

- (void)startSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];

        if (!self.audioPlayer) {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"silent" ofType:@"mp3"];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
            self.audioPlayer.numberOfLoops = -1;
            self.audioPlayer.volume = 0.0;
        }

        [self.audioPlayer play];

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)pauseSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (self.audioPlayer && self.audioPlayer.isPlaying) {
            [self.audioPlayer pause];
        }

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)stopSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (self.audioPlayer) {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
        }

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

@end
