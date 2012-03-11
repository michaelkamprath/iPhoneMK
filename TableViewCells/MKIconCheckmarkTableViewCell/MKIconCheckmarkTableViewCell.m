//
//  MKIconCheckmarkTableViewCell.m
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

#import "MKIconCheckmarkTableViewCell.h"

@implementation MKIconCheckmarkTableViewCell
@synthesize checked=_checked;
@synthesize checkImage;
@synthesize uncheckImage;

- (id)initWithStyle:(MKIconCheckmarkTableViewCellStyle)inStyle reuseIdentifier:(NSString *)inReuseIdentifier checkImage:(UIImage*)inCheckImage uncheckImage:(UIImage*)inUncheckImage
{
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    
    if ( MKIconCheckmarkTableViewCellStyleValue1Left == inStyle || MKIconCheckmarkTableViewCellStyleValue1Right == inStyle ) {
        cellStyle = UITableViewCellStyleValue1;
    }
    
    self = [super initWithStyle:cellStyle reuseIdentifier:inReuseIdentifier];
    if (self) {
        _style = inStyle;
                
        _checkImageView = [[UIImageView alloc] initWithImage:self.uncheckImage];
        [self.contentView addSubview:_checkImageView];
        
        self.checkImage = inCheckImage;
        self.uncheckImage = inUncheckImage;
        self.checked = NO;
        
    }
    return self;
}
                                       
-(void)dealloc {
    [_checkImageView release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setChecked:(BOOL)inChecked {
        
    _checked = inChecked;
    
    if (_checked) {
        _checkImageView.image = self.checkImage;
    }
    else {
        _checkImageView.image = self.uncheckImage;
    }
    
    [_checkImageView setNeedsDisplay];
}

- (void)layoutSubviews 
{
	const CGFloat kCheckImageSize = 23;
    const CGFloat kCheckImagePadding = 10;
    
	[super layoutSubviews];

    CGRect cellBounds = self.contentView.bounds;
    
    if ( MKIconCheckmarkTableViewCellStyleLeft == _style || MKIconCheckmarkTableViewCellStyleValue1Left == _style ) {
        CGRect checkFrame = CGRectMake( kCheckImagePadding, (cellBounds.size.height - kCheckImageSize)/2.0, kCheckImageSize, kCheckImageSize);

        _checkImageView.frame = checkFrame;
    
        self.imageView.frame = CGRectMake(kCheckImagePadding + kCheckImageSize + kCheckImagePadding, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height );
    
        CGRect textLabelFrame = self.textLabel.frame;
         
        textLabelFrame = CGRectMake(textLabelFrame.origin.x + kCheckImageSize + kCheckImagePadding, textLabelFrame.origin.y, textLabelFrame.size.width, textLabelFrame.size.height );

        if ( self.detailTextLabel != nil ) {
            CGRect detailTextLabelFrame = self.detailTextLabel.frame;

            if ( textLabelFrame.origin.x + textLabelFrame.size.width >= detailTextLabelFrame.origin.x ) {
                textLabelFrame.size.width = detailTextLabelFrame.origin.x - textLabelFrame.origin.x;
                
                if ( textLabelFrame.size.width < 0 ) {
                    textLabelFrame.size.width = 0;
                }
            }
        }
        else {
            textLabelFrame.size.width -= kCheckImageSize + kCheckImagePadding;
        }
        
        self.textLabel.frame = textLabelFrame;
        [self.textLabel setNeedsDisplay];
    }
    else {
        
        CGFloat checkOriginX = cellBounds.origin.x + cellBounds.size.width - (kCheckImageSize + kCheckImagePadding);
        
        if ( (MKIconCheckmarkTableViewCellStyleRightAccessory == _style) && (self.accessoryView == nil) ) {
            
            checkOriginX -= (28 + 10);
        }
        
        CGRect checkFrame = CGRectMake( checkOriginX, (cellBounds.size.height - kCheckImageSize)/2.0, kCheckImageSize, kCheckImageSize);
        
        _checkImageView.frame = checkFrame;
        
  
        CGRect textLabelFrame = self.textLabel.frame;
        
        if ( self.detailTextLabel != nil ) {
            
            
            
            CGRect detailTextLabelFrame = self.detailTextLabel.frame;
            
            detailTextLabelFrame.origin.x -= (kCheckImageSize + kCheckImagePadding);
            
            if ( textLabelFrame.origin.x + textLabelFrame.size.width >= detailTextLabelFrame.origin.x ) {
                textLabelFrame.size.width = detailTextLabelFrame.origin.x - textLabelFrame.origin.x;
                
                if ( textLabelFrame.size.width < 0 ) {
                    textLabelFrame.size.width = 0;
                }
            }
            
            self.detailTextLabel.frame = detailTextLabelFrame;
        }
        else {
            textLabelFrame.size.width -= kCheckImageSize + kCheckImagePadding;
        }
        
        self.textLabel.frame = textLabelFrame;
        [self.textLabel setNeedsDisplay];

    }
}

@end
