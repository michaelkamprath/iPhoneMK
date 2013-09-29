//
//  MKTouchTrackingView.m
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
#error "MKSocialShareTableViewCell is designed to be used with ARC. Please add '-fobjc-arc' to the compiler flags of MKSocialShareTableViewCell.m."
#endif // __has_feature(objc_arc)

#import "MKTouchTrackingView.h"

@interface MKTouchTrackingView () {
	BOOL _curTouchInTrackingRect;
    BOOL _simulatedTouchUp;
    
    NSTimer* _simulatedTouchUpTimer;
}

-(void)invalidateTouchTimer;

@end
@implementation MKTouchTrackingView
@synthesize delayForSimulatedTouchUp;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
        self.delayForSimulatedTouchUp = 0;
    }
    return self;
}


-(void)invalidateTouchTimer {
    if (_simulatedTouchUpTimer != nil ) {
        [_simulatedTouchUpTimer invalidate];
        _simulatedTouchUpTimer = nil;
    }
}

-(void)startTouchTimer {
    if ( self.delayForSimulatedTouchUp > 0 ) {
        _simulatedTouchUp = NO;
        
        _simulatedTouchUpTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayForSimulatedTouchUp
                                                                   target:self
                                                                 selector:@selector(simulateTouchUp:)
                                                                 userInfo:nil
                                                                  repeats:NO];
    }
}

- (void)simulateTouchUp:(NSTimer*)theTimer {
    _simulatedTouchUp = YES;
    [self touchUpInView];
    _simulatedTouchUpTimer = nil;
}

#pragma mark -- Touch Handling --

- (BOOL)pointInside:(CGPoint)localPoint withEvent:(UIEvent *)event {
    
    BOOL pointInside = [self isPtInViewCoreArea:localPoint];
    
    return pointInside;
}


- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
	[self invalidateTouchTimer];
    
	UITouch *touch = [inTouches anyObject];
	
	if ( touch.view == self && [self isPtInViewCoreArea:[touch locationInView:self]] )
	{
		_curTouchInTrackingRect = YES;
        
		[self touchInViewBegan];
        
        
        [self startTouchTimer];
	}
	
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
	
	UITouch *touch = [inTouches anyObject];
	
	if ( touch.view == self && !_simulatedTouchUp ) {
		
		BOOL touchInRect = [self isPtInViewTrackingArea:[touch locationInView:self]];
		
		
		if ( touchInRect != _curTouchInTrackingRect ) {
			if ( touchInRect ) {
				[self touchTrackedIntoView];
                [self startTouchTimer];
                
			}
			else {
                [self invalidateTouchTimer];
				[self touchTrackedOutOfView];
			}
			[self setNeedsDisplay];
			
			_curTouchInTrackingRect = touchInRect;
		}
		
	}
}

- (void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
	
	UITouch *touch = [inTouches anyObject];
	
	if ( touch.view == self && !_simulatedTouchUp ) {
        [self invalidateTouchTimer];
        
		if ([self isPtInViewTrackingArea:[touch locationInView:self]]) {
			[self touchUpInView];
		}
		else {
			[self touchTrackedOutOfView];
		}
		
		_curTouchInTrackingRect = NO;
	}
	_simulatedTouchUp = NO;
}

-(void)touchInViewBegan {
}

-(void)touchTrackedIntoView {
}

-(void)touchTrackedOutOfView {
}

-(void)touchUpInView {
}


-(BOOL)isPtInViewCoreArea:(CGPoint)inPt {
	return CGRectContainsPoint(self.bounds, inPt);
}

-(BOOL)isPtInViewTrackingArea:(CGPoint)inPt {
	CGRect trackingRect = CGRectInset( self.bounds, -self.bounds.size.width, -self.bounds.size.height );
	return CGRectContainsPoint(trackingRect, inPt);
}

@end
