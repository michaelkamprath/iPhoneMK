//
//  MKParentalGateTouchTargetView.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 10/19/13.
//
//

#import "MKParentalGateTouchTargetView.h"
@interface MKParentalGateTouchTargetView ()
@property (strong,nonatomic) UIImage* goIcon;
@property (strong,nonatomic) UIImage* stopIcon;
@property (weak,nonatomic) id<MKParentalGateTouchTargetDelegate> delegate;
@end

@implementation MKParentalGateTouchTargetView

- (id)initWithFrame:(CGRect)frame stopIcon:(UIImage*)inStopIcon goIcon:(UIImage*)inGoIcon delegate:(id<MKParentalGateTouchTargetDelegate>)inDelegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.goIcon = inGoIcon;
        self.stopIcon = inStopIcon;
        self.delegate = inDelegate;
        
        MKSoundCoordinatedAnimationLayer* aniLayer = [[MKSoundCoordinatedAnimationLayer alloc] init];
        aniLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
 
        self.animationLayer = aniLayer;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Animation

-(void)startAnimation {
    [self.animationLayer startAnimating];
}

-(void)pauseAnimation {
    [self.animationLayer pauseAnimation];
}

-(void)resumeAnimation {
    [self.animationLayer resumeAnimation];
}
#pragma mark - Touch Tracking

-(void)touchInViewBegan {
    [self.delegate handleTargetTouchDown:self];
}

-(void)touchUpInView {
    [self.delegate handleTargetTouchUp:self];
}

-(void)touchTrackedOutOfView {
    [self.delegate handleTargetTouchUp:self];
    [self cancelTouchTracking];
}
@end
