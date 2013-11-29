//
//  MKContinuousSoundLoop.m
//
// Copyright 2013 Michael F. Kamprath
// michael@claireware.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if !(__has_feature(objc_arc) && __clang_major__ >= 3)
#error "MKContinuousSoundLoop is designed to be used with ARC. Please add '-fobjc-arc' to the compiler flags of MKContinuousSoundLoop.m."
#endif // __has_feature(objc_arc)

#import <AVFoundation/AVFoundation.h>
#import "MKContinuousSoundLoop.h"

@interface MKContinuousSoundLoop () <AVAudioPlayerDelegate>
@property (strong,nonatomic) NSArray* soundFileList;
@property (strong,nonatomic) NSArray* soundPlayerList;
@property (weak,nonatomic) AVAudioPlayer* currentlyPlayingSound;
@property (weak,nonatomic) AVAudioPlayer* nextSoundToPlay;
@property (assign,nonatomic) NSUInteger currentSoundIndex;

-(AVAudioPlayer*)nextSound;

@end

@implementation MKContinuousSoundLoop


-(id)initWithSoundFiles:(NSArray*)inSoundFileList {
    self = [super init];
    
    if ( nil != self ) {
        self.soundFileList = inSoundFileList;
        
        if ( nil != inSoundFileList ) {
            NSMutableArray* soundObjects = [NSMutableArray arrayWithCapacity:self.soundFileList.count];
            
            for ( NSString* filename in self.soundFileList ) {
                NSBundle* mainBundle = [NSBundle mainBundle];
                NSString* pathStr = [mainBundle pathForResource:filename ofType:nil];
                NSURL* soundURL = [NSURL fileURLWithPath:pathStr];
                
                NSError* error = nil;
                
                AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
                
                if ( nil == error && nil != player ) {
                    [player prepareToPlay];
                    [soundObjects addObject:player];
                }
            }
            self.soundPlayerList = [NSArray arrayWithArray:soundObjects];
            self.currentSoundIndex = self.soundPlayerList.count;
        }
        self.randomOrder = YES;
        _volume = 1.0;
    }
    
    return self;
}

-(void)dealloc {
    [self stop];
}

-(void)play {
    if ( nil != self.currentlyPlayingSound && self.currentlyPlayingSound.isPlaying ) {
        return;
    }
    
    if ( nil == self.currentlyPlayingSound ) {
        if ( nil == self.nextSoundToPlay ) {
            self.currentlyPlayingSound = [self nextSound];
            [self.currentlyPlayingSound prepareToPlay];
        }
        else {
            self.currentlyPlayingSound = self.nextSoundToPlay;
            self.nextSoundToPlay = nil;
        }
    }
    
    if ( nil != self.currentlyPlayingSound) {
        self.currentlyPlayingSound.delegate = self;
        
        [self.currentlyPlayingSound play];
        
        self.nextSoundToPlay = [self nextSound];
        [self.nextSoundToPlay prepareToPlay];
    }
}
-(void)stop {
    if ( nil != self.currentlyPlayingSound ) {
        [self.currentlyPlayingSound pause];
    }
}
-(void)reset {
    if ( nil != self.currentlyPlayingSound ) {
        [self.currentlyPlayingSound stop];
    }
    
    self.currentlyPlayingSound = nil;
    self.nextSoundToPlay = nil;
    self.currentSoundIndex = self.soundPlayerList.count;
}

-(AVAudioPlayer*)nextSound {
    if (nil == self.soundPlayerList) {
        return nil;
    }
    
    if (self.randomOrder) {
        
        if ( self.soundPlayerList.count > 1 ) {
            NSMutableArray* nonPlayingSoundIndexes = [NSMutableArray arrayWithCapacity:self.soundPlayerList.count];
            
            for ( NSUInteger i = 0; i < self.soundPlayerList.count; ++i ) {
                AVAudioPlayer* sound = [self.soundPlayerList objectAtIndex:i];
                if ( sound != self.currentlyPlayingSound ) {
                    [nonPlayingSoundIndexes addObject:[NSNumber numberWithUnsignedInteger:i]];
                }
            }
            
            NSNumber* randomIndex = [nonPlayingSoundIndexes objectAtIndex:(random()%nonPlayingSoundIndexes.count)];
            
            self.currentSoundIndex = [randomIndex unsignedIntegerValue];
        }
        else {
            self.currentSoundIndex = 0;
        }
    }
    else {
        if ( self.currentSoundIndex >= self.soundPlayerList.count - 1 ) {
            self.currentSoundIndex = 0;
        }
        else {
            self.currentSoundIndex++;
        }
    }
    
    AVAudioPlayer* sound = [self.soundPlayerList objectAtIndex:self.currentSoundIndex];
    
    sound.volume = self.volume;
    
    return sound;
}


-(BOOL)isPlaying {
    return ( nil != self.currentlyPlayingSound && [self.currentlyPlayingSound isPlaying] );
}

-(void)setVolume:(float)inVolume {
    _volume = inVolume;
    
    if (nil != self.currentlyPlayingSound ) {
        self.currentlyPlayingSound.volume = inVolume;
    }
}


#pragma mark - Sound PlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.currentlyPlayingSound.delegate = nil;
    self.currentlyPlayingSound = self.nextSoundToPlay;
    self.currentlyPlayingSound.delegate = self;
    [self.currentlyPlayingSound play];
    self.nextSoundToPlay = [self nextSound];
    [self.nextSoundToPlay prepareToPlay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self reset];
}

@end
