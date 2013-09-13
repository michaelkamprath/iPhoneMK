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
    self.badgeFive = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.buttonFive.frame.size.width - 22,
                                                                         -15,
                                                                         44,
                                                                         30)];
    [self.buttonFive addSubview:self.badgeFive];

    // Badge Six
    self.badgeSix = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.buttonSix.frame.size.width - 37,
                                                                         -15,
                                                                         74,
                                                                         30)];
    [self.buttonSix addSubview:self.badgeSix];

    // Badge Seven
    UIButton* buttonSeven = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [buttonSeven setTitle:@"seven" forState:UIControlStateNormal];
    [buttonSeven setBackgroundColor:[UIColor blueColor]];
    self.badgeSeven = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(buttonSeven.frame.size.width - 37,
                                                                          -15,
                                                                          74,
                                                                          30)];
    self.badgeSeven.font = [UIFont boldSystemFontOfSize:11];
    [buttonSeven addSubview:self.badgeSeven];

    // Badge Eight - Wrong way
    self.badgeEight = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(-22,
                                                                          -15,
                                                                          44,
                                                                          30)];
    self.badgeEight.font = [UIFont boldSystemFontOfSize:11];
    UISegmentedControl* segmentedControlEight =
    [[UISegmentedControl alloc] initWithItems:@[@"9a",@"9b",@"9c"]];
    segmentedControlEight.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControlEight.momentary = YES;
    [segmentedControlEight addSubview:self.badgeEight];
    UIBarButtonItem* buttonEight = [[UIBarButtonItem alloc] initWithCustomView:segmentedControlEight];

    // Badge Nine - Right Way
    self.badgeNine = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(-22,
                                                                         -15,
                                                                         44,
                                                                         30)];
    self.badgeNine.font = [UIFont boldSystemFontOfSize:11];
    UISegmentedControl* segmentedControlNine =
    [[UISegmentedControl alloc] initWithItems:@[@"9a",@"9b",@"9c"]];
    segmentedControlNine.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControlNine.momentary = YES;
    //segmentedControlNine.tintColor = [UIColor blackColor]; // may need to be set explicitly because of container indirection
    UIView* containerViewNine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    [containerViewNine addSubview:segmentedControlNine];
    [containerViewNine addSubview:self.badgeNine];
    UIBarButtonItem* buttonNine = [[UIBarButtonItem alloc] initWithCustomView:containerViewNine];

    // Add seven, eight and nine to the toolbar
    
    NSArray* toobarItems =
    @[
      [[UIBarButtonItem alloc] initWithCustomView:buttonSeven],
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      buttonEight,
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      buttonNine
    ];
    [self.myToolbar setItems:toobarItems];
    
    
    // set up
    [self slideValueChanged:self];
}

- (void)viewDidUnload
{
    [self setMyToolbar:nil];
    [self setButtonFive:nil];
    [self setButtonSix:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    self.badgeSeven.value = sliderValue * 1000;
    self.badgeEight.value = sliderValue;
    self.badgeNine.value = sliderValue;
}

@end
