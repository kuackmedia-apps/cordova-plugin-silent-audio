#import "CDVSilentAudioPlugin.h"

@interface CDVSilentAudioPlugin ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation CDVSilentAudioPlugin

- (void)pluginInitialize {
    [super pluginInitialize];

    // Observador claramente para interrupciones de audio
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
}

- (void)audioSessionInterrupted:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];

    if (type == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"🔔 Interrupción de audio iniciada, pausando claramente audio silencioso.");
        [self.audioPlayer pause];

    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];

        if (error == nil && self.audioPlayer) {
            NSLog(@"🔔 Interrupción claramente terminada, reanudando claramente audio silencioso.");
            [self.audioPlayer play];
        } else {
            NSLog(@"❌ Error reactivando audio tras interrupción: %@", error);
        }
    }
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
            [self.audioPlayer prepareToPlay];
        }

        if (!error && self.audioPlayer) {
            [self.audioPlayer play];
            NSLog(@"✅ Silent audio claramente iniciado.");
        } else {
            NSLog(@"❌ Error iniciando silent audio: %@", error);
        }

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)pauseSilentAudio:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (self.audioPlayer && self.audioPlayer.isPlaying) {
            [self.audioPlayer pause];
            NSLog(@"🔔 Audio silencioso pausado.");
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
            NSLog(@"🔔 Audio silencioso claramente detenido.");
        }

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

@end
