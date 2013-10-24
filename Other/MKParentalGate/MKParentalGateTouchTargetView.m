//
//  MKParentalGateTouchTargetView.m
//
// Copyright 2013 Michael F. Kamprath
// michael@claireware.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
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
#error "MKParentalGate is designed to be used with ARC. Please add '-fobjc-arc' to the compiler flags of MKParentalGateViewController.m."
#endif // __has_feature(objc_arc)

#import "MKParentalGateTouchTargetView.h"
@interface MKParentalGateTouchTargetView ()
@property (strong,nonatomic) UIImage* stopIcon;
@property (weak,nonatomic) id<MKParentalGateTouchTargetDelegate> delegate;
@end

@implementation MKParentalGateTouchTargetView

- (id)initWithFrame:(CGRect)frame targetIcon:(UIImage*)inTargetIcon delegate:(id<MKParentalGateTouchTargetDelegate>)inDelegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.stopIcon = inTargetIcon;
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

-(void)resetAnimationLayerFrame {
    self.animationLayer.frame = CGRectMake(0, 0, self.animationLayer.frame.size.width, self.animationLayer.frame.size.height);
}

#pragma mark - Animation

-(void)startAnimation {
    [self.animationLayer startAnimating];
}

-(void)stopAnimation {
    [self.animationLayer stopAnimatingImmeditely:YES];
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

-(void)touchUpOutOfView {
    [self.delegate handleTargetTouchUp:self];
}

-(void)touchTrackedOutOfView {
    [self.delegate handleTargetTouchUp:self];
}

-(void)touchTrackedIntoView {
    [self.delegate handleTargetTouchDown:self];
}

@end
