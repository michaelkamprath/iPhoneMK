//
//  FirstViewController.h
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"

@interface NumberBadgeViewController : UIViewController {
    
}
@property (retain) IBOutlet MKNumberBadgeView* badgeOne;
@property (retain) IBOutlet MKNumberBadgeView* badgeTwo;
@property (retain) IBOutlet MKNumberBadgeView* badgeThree;
@property (retain) IBOutlet MKNumberBadgeView* badgeFour;
@property (retain) IBOutlet UISlider* valueSlider;

@property (retain) MKNumberBadgeView* badgeFive;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonFive;

@property (retain) MKNumberBadgeView* badgeSix;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonSix;

@property (retain, nonatomic) IBOutlet UIToolbar* myToolbar;
@property (retain, nonatomic) MKNumberBadgeView*  badgeSeven;
@property (retain, nonatomic) MKNumberBadgeView*  badgeEight;

-(IBAction)slideValueChanged:(id)sender;

@end

