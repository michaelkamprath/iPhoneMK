//
//  MKParentalGateTouchCancelView.h
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

#import "MKTouchTrackingView.h"

@class MKParentalGateTouchCancelView;

@protocol MKParentalGateTouchCancelDelegate <NSObject>

@required
-(void)handleCancelTouchDown:(MKParentalGateTouchCancelView*)inTouchCancelView;
-(void)handleCancelTouchUp:(MKParentalGateTouchCancelView*)inTouchCancelView;

@end

@interface MKParentalGateTouchCancelView : MKTouchTrackingView
@property (weak,nonatomic) id<MKParentalGateTouchCancelDelegate> delegate;

@end
