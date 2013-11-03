//
//  MKTouchTrackingAnimationView.m
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
#error "MKTouchTrackingAnimationView is designed to be used with ARC. Please add '-fobjc-arc' to the compiler flags of MKTouchTrackingAnimationView.m."
#endif // __has_feature(objc_arc)

#import "MKTouchTrackingAnimationView.h"

@interface MKTouchTrackingAnimationView ()

@end
@implementation MKTouchTrackingAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


-(void)setAnimationLayer:(MKSoundCoordinatedAnimationLayer *)inAnimationLayer {
    
    if ( nil != _animationLayer ) {
        [_animationLayer removeFromSuperlayer];
        _animationLayer = nil;
    }
    
    
    if ( nil != inAnimationLayer) {
        _animationLayer = inAnimationLayer;
        [self.layer addSublayer:_animationLayer];
    }
}

#pragma mark - Touch Tracking

-(BOOL)isPtInViewCoreArea:(CGPoint)inPt {
    CALayer* presentationLayer = [self.animationLayer presentationLayer];
    
    CGRect currentFrame = presentationLayer.frame;
    
    
	return CGRectContainsPoint(currentFrame, inPt);
}

-(BOOL)isPtInViewTrackingArea:(CGPoint)inPt {
    CALayer* presentationLayer = [self.animationLayer presentationLayer];

    CGRect currentFrame = presentationLayer.frame;
    
	CGRect trackingRect = CGRectInset( currentFrame, -currentFrame.size.width, -currentFrame.size.height );
    
	return CGRectContainsPoint(trackingRect, inPt);
}

@end
