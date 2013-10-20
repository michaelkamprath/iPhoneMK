//
//  MKParentalGateViewController.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 10/19/13.
//
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

@interface MKParentalGateViewController () <MKParentalGateTouchTargetDelegate>

@property (weak,nonatomic) IBOutlet UIView* topObjectView;
@property (weak,nonatomic) IBOutlet UIView* bottomObjectView;
@property (weak,nonatomic) IBOutlet UILabel* titleLabel;
@property (weak,nonatomic) IBOutlet UILabel* topExplanationLabel;
@property (weak,nonatomic) IBOutlet UILabel* bottomExplanationLabel;
@property (strong,nonatomic) MKParentalGateTouchTargetView* topTarget;
@property (strong,nonatomic) MKParentalGateTouchTargetView* bottomTarget;
@property (strong,nonatomic) UIImage* goIcon;
@property (strong,nonatomic) UIImage* stopIcon;
@property (strong,nonatomic) MKParentalGateSuccessBlock successBlock;
@property (strong,nonatomic) MKParentalGateFailureBlock failureBlock;

-(NSDictionary*)topTouchTargetAnimation;
-(NSDictionary*)bottomTouchTargetAnimation;

@end

@implementation MKParentalGateViewController

- (id)initWithStopIcon:(UIImage*)inStopIcon goIcon:(UIImage*)inGoIcon successBlock:(MKParentalGateSuccessBlock)inSuccessBlock failureBlock:(MKParentalGateFailureBlock)inFailureBlock
{
    self = [super initWithNibName:@"MKParentalGateViewController" bundle:nil];
    if (self) {
        self.stopIcon = inStopIcon;
        self.goIcon = inGoIcon;
        self.successBlock = inSuccessBlock;
        self.failureBlock = inFailureBlock;
        
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        else {
            self.wantsFullScreenLayout = YES;
        }
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
    [self.topTarget startAnimation];
    [self.bottomTarget startAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topTarget = [[MKParentalGateTouchTargetView alloc] initWithFrame:CGRectMake(0, (self.topObjectView.bounds.size.height - self.stopIcon.size.height)/2.0, self.stopIcon.size.width, self.stopIcon.size.height) stopIcon:self.stopIcon goIcon:self.goIcon delegate:self];
    self.topTarget.animationLayer.config = [self topTouchTargetAnimation];
    [self.topObjectView addSubview:self.topTarget];
    
    self.bottomTarget = [[MKParentalGateTouchTargetView alloc] initWithFrame:CGRectMake(self.bottomObjectView.bounds.size.width - self.stopIcon.size.width, (self.bottomObjectView.bounds.size.height - self.stopIcon.size.height)/2.0, self.stopIcon.size.width, self.stopIcon.size.height) stopIcon:self.stopIcon goIcon:self.goIcon delegate:self];
    self.bottomTarget.animationLayer.config = [self bottomTouchTargetAnimation];
    [self.bottomObjectView addSubview:self.bottomTarget];
}

#pragma mark - Animations

-(NSDictionary*)topTouchTargetAnimation {
    NSMutableDictionary* animationConfig = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ( nil != self.stopIcon ) {
        [animationConfig setObject:@{@"stillImageObj":self.stopIcon} forKey:@"meta"];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:0.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:(self.topObjectView.bounds.size.width - self.stopIcon.size.width)]} forKey:[NSNumber numberWithFloat:5.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0],@"lastFrameDuration":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:10.0]];
    }
    return animationConfig;
}

-(NSDictionary*)bottomTouchTargetAnimation {
    NSMutableDictionary* animationConfig = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ( nil != self.stopIcon ) {
        [animationConfig setObject:@{@"stillImageObj":self.stopIcon} forKey:@"meta"];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:0.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:-(self.topObjectView.bounds.size.width - self.stopIcon.size.width)]} forKey:[NSNumber numberWithFloat:5.0]];
        [animationConfig setObject:@{@"deltaX":[NSNumber numberWithFloat:0.0],@"lastFrameDuration":[NSNumber numberWithFloat:0.0]} forKey:[NSNumber numberWithFloat:10.0]];
    }
    return animationConfig;
}

#pragma mark - MKParentalGateTouchTargetDelegate

-(void)handleTargetTouchDown:(MKParentalGateTouchTargetView*)inTargetView {
    if ( inTargetView == self.topTarget ) {
        [self.topTarget pauseAnimation];
        self.topObjectView.backgroundColor = [UIColor greenColor];
    }
    else if ( inTargetView == self.bottomTarget ) {
        [self.bottomTarget pauseAnimation];
        self.bottomObjectView.backgroundColor = [UIColor greenColor];
    }
    
}
-(void)handleTargetTouchUp:(MKParentalGateTouchTargetView*)inTargetView {
    if ( inTargetView == self.topTarget ) {
        [self.topTarget resumeAnimation];
        self.topObjectView.backgroundColor = [UIColor whiteColor];
    }
    else if ( inTargetView == self.bottomTarget ) {
        [self.bottomTarget resumeAnimation];
        self.bottomObjectView.backgroundColor = [UIColor whiteColor];
    }
}

@end
