//
//  TouchBeepingAnimationView.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 9/28/13.
//
//

#import "TouchBeepingAnimationView.h"

@interface TouchBeepingAnimationView ()
@property (strong,nonatomic) AVAudioPlayer* sound;

@end

@implementation TouchBeepingAnimationView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSString* filepath = [[NSBundle mainBundle] pathForResource:@"beep-timber" ofType:@"aif"];
        NSURL* fileURL = [NSURL fileURLWithPath:filepath];
        _sound = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [_sound prepareToPlay];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString* filepath = [[NSBundle mainBundle] pathForResource:@"beep-timber" ofType:@"aif"];
        NSURL* fileURL = [NSURL fileURLWithPath:filepath];
        _sound = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [_sound prepareToPlay];
    }
    return self;
}


-(void)touchInViewBegan {
    // because this class derives from MKTouchTrackingAnimationView, a touch only accors when
    // the touch is where the animation layer is, even when animating.
    
    [self.sound play];
}

@end
