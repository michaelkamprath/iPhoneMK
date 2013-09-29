//
//  AnimationLayerViewController.h
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKSoundCoordinatedAnimationLayer;
@class AnimationConfigModel;
@class TouchBeepingAnimationView;

@interface AnimationLayerViewController : UIViewController {
    
    MKSoundCoordinatedAnimationLayer* _animationLayer;
    
    AnimationConfigModel* _config;
}
@property (retain,nonatomic) IBOutlet TouchBeepingAnimationView* animationAreaView;


-(IBAction)animateButtonOne:(id)sender;
-(IBAction)animateButtonTwo:(id)sender;
-(IBAction)animateButtonThree:(id)sender;

@end
