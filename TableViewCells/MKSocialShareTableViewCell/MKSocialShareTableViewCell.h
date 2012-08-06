//
//  MKSocialShareTableViewCell.h
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
// Icons provided with this class were created with the publically available marketing
// material of each respective trademark holder. Please consult with Facebook's, Twitter's,
// and Weibo's marketing guidelines before using the provided icons in your project.
// The links to each company's marketing materials are:
//
//      Facebook    -   https://www.facebook.com/brandpermissions/logos.php
//      Twitter     -   http://twitter.com/logo
//      Weibo       -   http://open.weibo.com/wiki/微博标识/en
//

#ifndef __IPHONE_6_0
#error "MKSocialShareTableViewCell requires iOS 6.0 SDK or later"
#endif

#import <UIKit/UIKit.h>

@interface MKSocialShareTableViewCell : UITableViewCell {
    
}
@property (strong,nonatomic) NSString* postText;
@property (strong,nonatomic) NSArray* postImageList;
@property (strong,nonatomic) NSArray* postURLList;

+(BOOL)socialShareAvailable;

- (id)initWithReuseIdentifier:(NSString *)inReuseIdentifier facebookImage:(UIImage*)inFacebookImage twitterImage:(UIImage*)inTwitterImage weiboImage:(UIImage*)inWeiboImage;


@end
