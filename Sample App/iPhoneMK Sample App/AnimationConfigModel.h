//
//  AnimationConfigModel.h
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationConfigModel : NSObject {
    
    NSDictionary* _configDict;
    
}
@property (readonly) NSArray* animationKeyList;

-(id)init;

-(NSDictionary*)animationConfigForKey:(NSString*)inAnimationKey;

@end
