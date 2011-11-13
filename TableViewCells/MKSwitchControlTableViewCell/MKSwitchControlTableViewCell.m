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
