//
//  FirstViewController.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberBadgeViewController.h"

@implementation NumberBadgeViewController
@synthesize badgeOne;
@synthesize badgeTwo;
@synthesize badgeThree;
@synthesize badgeFour;
@synthesize valueSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Number Badge";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        if ( [self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Badge One is default (no config)
    
    // Badge Two
    self.badgeTwo.fillColor = [UIColor purpleColor];
    self.badgeTwo.hideWhenZero = YES;
    
    //Badge Three
    self.badgeThree.fillColor = [UIColor blackColor];
    self.badgeThree.strokeColor = [UIColor yellowColor];
    self.badgeThree.textColor = [UIColor yellowColor];
    
    // Badge Four
    self.badgeFour.shine = NO;
    self.badgeFour.shadow = NO;

    // Badge Five
    self.badgeFive = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.buttonLeft.frame.size.width - 22,
                                                                         -20,
                                                                         44,
                                                                         40)];
    [self.buttonLeft addSubview:self.badgeFive];

    // Badge Six
    self.badgeSix = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( -37,
                                                                         -20,
                                                                         74,
                                                                         40)];
    [self.buttonRight addSubview:self.badgeSix];

    
    
    // set up
    [self slideValueChanged:self];
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.badgeFive = nil;
    self.badgeSix = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)slideValueChanged:(id)sender {
    
    NSUInteger sliderValue = self.valueSlider.value;
    
    self.badgeOne.value = sliderValue;
    self.badgeTwo.value = sliderValue;
    self.badgeThree.value = sliderValue;
    self.badgeFour.value = sliderValue;
    self.badgeFive.value = sliderValue;
    self.badgeSix.value = sliderValue * 1000;
}

@end
