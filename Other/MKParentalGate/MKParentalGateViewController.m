//
//  MKParentalGateViewController.m
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

#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if !(__has_feature(objc_arc) && __clang_major__ >= 3)
#error "MKParentalGate is designed to be used with ARC. Please add '-fobjc-arc' to the compiler flags of MKParentalGateViewController.m."
#endif // __has_feature(objc_arc)

#import "MKParentalGateViewController.h"
#import "MKParentalGateTouchTargetView.h"
#import "MKParentalGateTouchCancelView.h"

@interface MKParentalGateViewController () <MKParentalGateTouchTargetDelegate,MKParentalGateTouchCancelDelegate> {
    BOOL _topTargetTouched;
    BOOL _bottomTargetTouched;
    __strong NSString* _titleText;
    __strong NSString* _explanatoryMessageText;
}

@property (weak,nonatomic) IBOutlet MKParentalGateTouchCancelView* topObjectView;
@property (weak,nonatomic) IBOutlet MKParentalGateTouchCancelView* bottomObjectView;
@property (weak,nonatomic) IBOutlet UILabel* titleLabel;
@property (weak,nonatomic) IBOutlet UILabel* explanatoryMessageLabel;
@property (strong,nonatomic) MKParentalGateTouchTargetView* topTarget;
@property (strong,nonatomic) MKParentalGateTouchTargetView* bottomTarget;
@property (strong,nonatomic) UIImage* topTargetIcon;
@property (strong,nonatomic) UIImage* bottomTargetIcon;
@property (strong,nonatomic) MKParentalGateSuccessBlock successBlock;
@property (strong,nonatomic) MKParentalGateFailureBlock failureBlock;

-(void)setUpTargetAnimation;

-(void)handleGateSuccess;
-(void)handleGateFailure;

-(NSDictionary*)topTouchTargetAnimation;
-(NSDictionary*)bottomTouchTargetAnimation;

@end

@implementation MKParentalGateViewController

-(id)initWithTopTargetIcon:(UIImage*)inTopTargetIcon bottomTargetIcon:(UIImage*)inBottomTargetIcon successBlock:(MKParentalGateSuccessBlock)inSuccessBlock failureBlock:(MKParentalGateFailureBlock)inFailureBlock title:(NSString*)inTitle explanatoryMessage:(NSString*)inMessage
{
    self = [super initWithNibName:@"MKParentalGateViewController" bundle:nil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.topTargetIcon = inTopTargetIcon;
        self.bottomTargetIcon = inBottomTargetIcon;
        self.successBlock = inSuccessBlock;
        self.failureBlock = inFailureBlock;
        if ( nil != inTitle ) {
            self.title = inTitle;
            _titleText = inTitle;
        }
        if ( nil != inMessage ) {
            _explanatoryMessageText = inMessage;
        }
        
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        else {
            self.wantsFullScreenLayout = YES;
        }
        
        _topTargetTouched = NO;
        _bottomTargetTouched = NO;
    }
    return self;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [self setUpTargetAnimation];
    [self.topTarget startAnimation];
    [self.bottomTarget startAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.view isKindOfClass:[MKParentalGateTouchCancelView class]]) {
        ((MKParentalGateTouchCancelView*)self.view).delegate = self;
    }
    self.topObjectView.delegate = self;
    self.bottomObjectView.delegate = self;
    
    if ( nil != _titleText ) {
        self.titleLabel.text = _titleText;
    }
    else {
        self.title = self.titleLabel.text;
    }
    
    if ( nil != _explanatoryMessageText ) {
        self.explanatoryMessageLabel.text = _explanatoryMessageText;
    }
}

-(void)setUpTargetAnimation {
    
    if ( nil == self.topTarget ) {
        CGFloat yPos = (self.topObjectView.bounds.size.height - self.topTargetIcon.size.height)/2.0;
        
        self.topTarget = [[MKParentalGateTouchTargetView alloc] initWithFrame:CGRectMake(0, yPos, self.topTargetIcon.size.width, self.topTargetIcon.size.height) targetIcon:self.topTargetIcon delegate:self];
        [self.topObjectView addSubview:self.topTarget];
    }
    if ( nil == self.bottomTarget ) {
        CGFloat yPos = (self.bottomObjectView.bounds.size.height - self.bottomTargetIcon.size.height)/2.0;

        self.bottomTarget = [[MKParentalGateTouchTargetView alloc] initWithFrame:CGRectMake(self.bottomObjectView.bounds.size.width - self.bottomTargetIcon.size.width, yPos, self.bottomTargetIcon.size.width, self.bottomTargetIcon.size.height) targetIcon:self.bottomTargetIcon delegate:self];
        [self.bottomObjectView addSubview:self.bottomTarget];
    }
    self.topTarget.frame = CGRectMake(0, (self.topObjectView.bounds.size.height - self.topTargetIcon.size.height)/2.0, self.topTargetIcon.size.width, self.topTargetIcon.size.height);
    [self.topTarget resetAnimationLayerFrame];
    self.topTarget.animationLayer.config = [self topTouchTargetAnimation];
    
    self.bottomTarget.frame = CGRectMake(self.bottomObjectView.bounds.size.width - self.bottomTargetIcon.size.width, (self.bottomObjectView.bounds.size.height - self.bottomTargetIcon.size.height)/2.0, self.bottomTargetIcon.size.width, self.bottomTargetIcon.size.height);
    [self.bottomTarget resetAnimationLayerFrame];
    self.bottomTarget.animationLayer.config = [self bottomTouchTargetAnimation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.topTarget stopAnimation];
    [self.bottomTarget stopAnimation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self setUpTargetAnimation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.topTarget startAnimation];
    [self.bottomTarget startAnimation];
}

-(void)handleGateSuccess {
    [self dismissViewControllerAnimated:YES completion:^{ if ( NULL != self.successBlock ) { self.successBlock(); } } ];
}
-(void)handleGateFailure {
    [self dismissViewControllerAnimated:YES completion:^{ if ( NULL != self.failureBlock ) { self.failureBlock(); } } ];
}
#pragma mark - Animations

-(NSDictionary*)topTouchTargetAnimation {
    NSMutableDictionary* animationConfig = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ( nil != self.topTargetIcon ) {
        [animationConfig setObject:@{@"stillImageObj":self.topTargetIcon} forKey:@"meta"];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:0.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:(self.topObjectView.bounds.size.width - self.topTargetIcon.size.width)]} forKey:[NSNumber numberWithFloat:5.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0],@"lastFrameDuration":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:10.0]];
    }
    return animationConfig;
}

-(NSDictionary*)bottomTouchTargetAnimation {
    NSMutableDictionary* animationConfig = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ( nil != self.bottomTargetIcon ) {
        [animationConfig setObject:@{@"stillImageObj":self.bottomTargetIcon} forKey:@"meta"];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:0.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:-(self.bottomObjectView.bounds.size.width - self.bottomTargetIcon.size.width)]} forKey:[NSNumber numberWithFloat:5.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0],@"lastFrameDuration":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:10.0]];
    }
    return animationConfig;
}

#pragma mark - MKParentalGateTouchTargetDelegate

-(void)handleTargetTouchDown:(MKParentalGateTouchTargetView*)inTargetView {
    if ( inTargetView == self.topTarget ) {
        [self.topTarget pauseAnimation];
        self.topObjectView.backgroundColor = [UIColor greenColor];
        _topTargetTouched = YES;
    }
    else if ( inTargetView == self.bottomTarget ) {
        [self.bottomTarget pauseAnimation];
        self.bottomObjectView.backgroundColor = [UIColor greenColor];
        _bottomTargetTouched = YES;
    }
    
    if ( _topTargetTouched && _bottomTargetTouched ) {
        [self.topTarget stopAnimation];
        [self.bottomTarget stopAnimation];
        
        self.topTarget.hidden = YES;
        self.bottomTarget.hidden = YES;
        
        [self handleGateSuccess];
    }
}
-(void)handleTargetTouchUp:(MKParentalGateTouchTargetView*)inTargetView {
    if ( inTargetView == self.topTarget ) {
        [self.topTarget resumeAnimation];
        self.topObjectView.backgroundColor = [UIColor whiteColor];
        _topTargetTouched = NO;
    }
    else if ( inTargetView == self.bottomTarget ) {
        [self.bottomTarget resumeAnimation];
        self.bottomObjectView.backgroundColor = [UIColor whiteColor];
        _bottomTargetTouched = NO;
    }
}

#pragma mark - MKParentalGateTouchCancelDelegate
-(void)handleCancelTouchDown:(MKParentalGateTouchCancelView*)inTouchCancelView {
    self.topObjectView.backgroundColor = [UIColor redColor];
    self.bottomObjectView.backgroundColor = [UIColor redColor];
    
    [self.topTarget stopAnimation];
    [self.bottomTarget stopAnimation];
    
    self.topTarget.hidden = YES;
    self.bottomTarget.hidden = YES;
}

-(void)handleCancelTouchUp:(MKParentalGateTouchCancelView*)inTouchCancelView {
    [self handleGateFailure];
}
@end
