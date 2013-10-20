//
//  MKParentalGateTouchTargetView.h
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 10/19/13.
//
//

#import "MKTouchTrackingAnimationView.h"

@class MKParentalGateTouchTargetView;

@protocol MKParentalGateTouchTargetDelegate <NSObject>

@required
-(void)handleTargetTouchDown:(MKParentalGateTouchTargetView*)inTargetView;
-(void)handleTargetTouchUp:(MKParentalGateTouchTargetView*)inTargetView;

@end

@interface MKParentalGateTouchTargetView : MKTouchTrackingAnimationView

- (id)initWithFrame:(CGRect)frame stopIcon:(UIImage*)inStopIcon goIcon:(UIImage*)inGoIcon delegate:(id<MKParentalGateTouchTargetDelegate>)inDelegate;

-(void)startAnimation;
-(void)pauseAnimation;
-(void)resumeAnimation;

@end
