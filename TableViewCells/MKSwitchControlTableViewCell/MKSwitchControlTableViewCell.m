//
//  MKSwitchControlTableViewCell.m
//  
// Copyright 2010-2011 Michael F. Kamprath
// michael@claireware.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
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

#if __has_feature(objc_arc) && __clang_major__ >= 3
#error "iPhoneMK is not designed to be used with ARC. Please add '-fno-objc-arc' to the compiler flags of iPhoneMK files."
#endif // __has_feature(objc_arc)


#import "MKSwitchControlTableViewCell.h"


@implementation MKSwitchControlTableViewCell
@synthesize switchControl=_switch;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
		_switch = [[UISwitch alloc] initWithFrame:CGRectZero];
        		
		[self.contentView addSubview:_switch];
		self.accessoryView = _switch;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}


- (void)dealloc
{
    [_switch release];
    [super dealloc];
}


-(void)addTarget:(id)inTarget action:(SEL)inAction {
    [self.switchControl addTarget:inTarget action:inAction forControlEvents:UIControlEventValueChanged];
}

@end
