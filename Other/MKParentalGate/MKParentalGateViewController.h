//
//  MKParentalGateViewController.h
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 10/19/13.
//
//

#import <UIKit/UIKit.h>
#import "MKParentalGate.h"

@interface MKParentalGateViewController : UIViewController

- (id)initWithStopIcon:(UIImage*)inStopIcon goIcon:(UIImage*)inGoIcon successBlock:(MKParentalGateSuccessBlock)inSuccessBlock failureBlock:(MKParentalGateFailureBlock)inFailureBlock;

@end
