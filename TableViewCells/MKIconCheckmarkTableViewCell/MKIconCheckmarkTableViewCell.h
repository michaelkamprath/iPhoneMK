//
//  MKIconCheckmarkTableViewCell.h
//  
// Copyright 2012 Michael F. Kamprath
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

#import <UIKit/UIKit.h>
typedef enum {
    MKIconCheckmarkTableViewCellStyleLeft,
    MKIconCheckmarkTableViewCellStyleRight,
    MKIconCheckmarkTableViewCellStyleRightAccessory,
    MKIconCheckmarkTableViewCellStyleValue1Left,
    MKIconCheckmarkTableViewCellStyleValue1Right
    
} MKIconCheckmarkTableViewCellStyle;

@interface MKIconCheckmarkTableViewCell : UITableViewCell {
    BOOL _checked;
    MKIconCheckmarkTableViewCellStyle _style;
    
    UIImageView* _checkImageView;
}
@property (assign,nonatomic) BOOL checked;
@property (retain,nonatomic) UIImage* checkImage;   // Should be a 24x24 pixel image
@property (retain,nonatomic) UIImage* uncheckImage; // Should be a 24x24 pixel image

- (id)initWithStyle:(MKIconCheckmarkTableViewCellStyle)inStyle reuseIdentifier:(NSString *)inReuseIdentifier checkImage:(UIImage*)inCheckImage uncheckImage:(UIImage*)inUncheckImage;

@end
