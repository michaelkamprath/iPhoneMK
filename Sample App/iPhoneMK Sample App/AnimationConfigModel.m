//
//  AnimationConfigModel.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationConfigModel.h"
#import "MKSoundCoordinatedAnimationLayer.h"

@implementation AnimationConfigModel

-(id)init {
    
    self = [super init];
    
    if (self) {
        NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"AnimationConfig" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:pathStr];
        NSString *error;
        NSPropertyListFormat format;
        
        _configDict = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:plistData
                                                                      mutabilityOption:NSPropertyListImmutable
                                                                                format:&format
                                                                      errorDescription:&error];
        if(!_configDict)
        {
            NSLog(@"%@",error);
            
            // TBC - can't run, error dialog and quit
            
            return nil;
        }	
              
    }
    
    return self;
}


-(NSDictionary*)animationConfigForKey:(NSString*)inAnimationKey {
    NSDictionary* animationsDict = [_configDict objectForKey:@"animations"];
    
    NSDictionary* animationPlist = [animationsDict objectForKey:inAnimationKey];
    
    return [MKSoundCoordinatedAnimationLayer configFromPropertList:animationPlist];
}

-(NSArray*)animationKeyList {
    return [_configDict objectForKey:@"animationList"];
}
@end
