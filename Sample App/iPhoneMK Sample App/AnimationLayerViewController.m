//
//  AnimationLayerViewController.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationLayerViewController.h"
#import "MKSoundCoordinatedAnimationLayer.h"
#import "AnimationConfigModel.h"
#import "TouchBeepingAnimationView.h"

@interface AnimationLayerViewController ()

@end

@implementation AnimationLayerViewController
@synthesize animationAreaView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Animation Layer";
        self.tabBarItem.image = [UIImage imageNamed:@"fourth"];
        if ( [self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        _config = [[AnimationConfigModel alloc] init];
        
        

    }
    return self;
}

-(void)dealloc {
    [_animationLayer removeFromSuperlayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _animationLayer = [[MKSoundCoordinatedAnimationLayer alloc] init];
    
    UIImage* aniImage = [UIImage imageNamed:@"animating_shape.png"];
    
    
    CGRect bounds = CGRectMake(0, 0, aniImage.size.width, aniImage.size.height);
    
    _animationLayer.bounds = bounds;
    
      
    _animationLayer.stillImage = aniImage;
    

    CGPoint position = CGPointMake( self.animationAreaView.bounds.size.width/2.0, 
                                   self.animationAreaView.bounds.size.height - _animationLayer.bounds.size.height );
    
    _animationLayer.position = position; 
   
    self.animationAreaView.animationLayer = _animationLayer;
    
  }


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [_animationLayer removeFromSuperlayer];
    _animationLayer = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Interaction

-(IBAction)animateButtonOne:(id)sender {
    NSString* animationKey = [_config.animationKeyList objectAtIndex:0];
    
    NSDictionary* aniConfig = [_config animationConfigForKey:animationKey];
    
    _animationLayer.config = aniConfig;
    
    [_animationLayer animateOnceWithCompletionInvocation:nil];
}
-(IBAction)animateButtonTwo:(id)sender {
    
    NSString* animationKey = [_config.animationKeyList objectAtIndex:1];
    
    NSDictionary* aniConfig = [_config animationConfigForKey:animationKey];
    
    _animationLayer.config = aniConfig;
    
    [_animationLayer animateOnceWithCompletionInvocation:nil];
}
-(IBAction)animateButtonThree:(id)sender {

    NSString* animationKey = [_config.animationKeyList objectAtIndex:2];
    
    NSDictionary* aniConfig = [_config animationConfigForKey:animationKey];
    
    _animationLayer.config = aniConfig;
    
    [_animationLayer animateOnceWithCompletionInvocation:nil];
}

@end
