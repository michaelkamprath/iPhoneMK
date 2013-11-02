//
//  MKParentalGate.h
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
#error "MKParentalGate is designed to be used with ARC. Please add '-fobjc-arc' to the compiler flags of MKParentalGate.m."
#endif // __has_feature(objc_arc)

#import "MKParentalGate.h"
#import "MKParentalGateViewController.h"

@implementation MKParentalGate

+(void)displayGateWithCurrentViewController:(UIViewController*)inViewController successBlock:(MKParentalGateSuccessBlock)inSuccessBlock failureBlock:(MKParentalGateFailureBlock)inFailureBlock
{
    UIInterfaceOrientation hostOrientation = inViewController.interfaceOrientation;
    
    MKParentalGateViewController* gateVC = [[MKParentalGateViewController alloc] initWithTopTargetIcon:[UIImage imageNamed:@"top-dot.png"] bottomTargetIcon:[UIImage imageNamed:@"bottom-dot.png"] successBlock:inSuccessBlock failureBlock:inFailureBlock orientation:hostOrientation];
    
    [inViewController presentViewController:gateVC animated:YES completion:NULL];
}


@end
