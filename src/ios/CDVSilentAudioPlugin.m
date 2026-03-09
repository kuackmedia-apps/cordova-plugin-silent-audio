#import "CDVSilentAudioPlugin.h"

@interface CDVSilentAudioPlugin ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL userStopped;
@end

@implementation CDVSilentAudioPlugin

- (void)pluginInitialize {
    [super pluginInitialize];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
}

- (void)audioSessionInterrupted:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];

    if (type == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"🔔 Silent audio: interruption began, pausing.");
        [self.audioPlayer pause];

    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        if (!self.userStopped && self.audioPlayer) {
            [self.audioPlayer play];
            NSLog(@"🔔 Silent audio: interruption ended, resumed.");
        } else {
            NSLog(@"🔔 Silent audio: interruption ended, not resumed (userStopped=%d).", self.userStopped);
        }
    }
}

- (void)startSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (!self.audioPlayer) {
            NSError *error = nil;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"silent" ofType:@"mp3"];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];

            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
            if (error || !self.audioPlayer) {
                NSLog(@"❌ Error creating silent audio player: %@", error);
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                            messageAsString:[error localizedDescription]];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                return;
            }
            self.audioPlayer.numberOfLoops = -1;
            self.audioPlayer.volume = 0.0;
            [self.audioPlayer prepareToPlay];
        }

        self.userStopped = NO;
        [self.audioPlayer play];
        NSLog(@"✅ Silent audio started.");

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)pauseSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (self.audioPlayer && self.audioPlayer.isPlaying) {
            self.userStopped = YES;
            [self.audioPlayer pause];
            NSLog(@"🔔 Silent audio paused.");
        }

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)stopSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (self.audioPlayer) {
            self.userStopped = YES;
            [self.audioPlayer stop];
            self.audioPlayer = nil;
            NSLog(@"🔔 Silent audio stopped.");
        }

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

@end
