//
//  MKSoundCoordinatedAnimationLayer.m
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

#import <AVFoundation/AVFoundation.h>
#import "MKSoundCoordinatedAnimationLayer.h"

NSString* const kSCANSoundFileNameKey = @"soundFile";
NSString* const kSCANImageFileNameKey = @"imageFile";
NSString* const kSCANImageHighlightMaskFileKey = @"highlightMaskFile";

NSString* const kSCANSoundObjectKey = @"soundObj";
NSString* const kSCANImageObjectKey = @"imageObj";
NSString* const kSCANHighlightMaskObjectKey = @"highlightMaskObj";
NSString* const kSCANLastFrameDurationKey = @"lastFrameDuration";
NSString* const kSCANVerticalTranslationKey = @"deltaY";
NSString* const kSCANHorizontalTranslationKey = @"deltaX";
NSString* const kSCANRotationPositionDegreesKey = @"rotatePosDegrees";

NSString* const kSCANImageAndPositingAniamtionKey = @"imageAndPositionAnimation";

@interface MKSoundCoordinatedAnimationLayer ()

- (void)initValues;


-(void)stopSounds;
-(void)setUpSoundTimers;

-(void)startAnimationCycleWithCycleCount:(NSUInteger)inCycleCount repeatDuration:(NSTimeInterval)inRepeatDuration;
-(void)setUpAnimationFrames;

- (void)animationDidStart:(CAAnimation *)theAnimation;
- (void)animationDidStop:(CAAnimation *)inAnimation finished:(BOOL)inDidFinish;

@end


@interface MKDefaultAnimationObjectFactory : NSObject <MKSoundCoordinatedAnimationObjectFactory>
{
	
}

-(UIImage*)getUIImageForFilename:(NSString*)inFilename;
-(AVAudioPlayer*)getAVAudioPlayerForFilename:(NSString*)inFilename;

@end



@implementation MKSoundCoordinatedAnimationLayer
@synthesize config=_config;
@synthesize stillImage=_stillImage;
@dynamic naturalCycleDuration;
@dynamic cycleDuration;
@dynamic isAnimating;
@synthesize silenced=_silenced;
@synthesize completionInvocation=_completionInvo;

- (id)init
{
    self = [super init];
	if ( self )
	{
		[self initValues];
	}
	
	return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
	if ( self )
	{
		[self initValues];
	}
	
	return self;
}

- (void)initValues
{
	
	_playingSounds = [[NSMutableSet setWithCapacity:10] retain];
	    
    _isAnimating = NO;
    
}

- (void)dealloc 
{
    [self stopAnimatingImmeditely:YES];
    
	[_config release];
	[_stillImage release];
    [_finalStillImage release];
	[_sortedFrameKeys release];
	[_playingSounds release];
    [_locationSequence release];
	[_soundPlayDict release];
    
    [super dealloc];
}

#pragma mark - Properties

-(void)setConfig:(NSDictionary *)inConfig
{
	[self stopAnimatingImmeditely:YES];
	
	if (_config != nil )
	{
		[_config release];
		_config = nil;
		
		[_sortedFrameKeys release];
		_sortedFrameKeys = nil;
	}
	
	_config = [inConfig retain];
	
    if ( _assignedAnimationTime != nil ) {
        [_assignedAnimationTime release];
        _assignedAnimationTime = nil;
    }
    
	NSArray* keys = [_config allKeys];
	
	_sortedFrameKeys = [[keys sortedArrayUsingSelector:@selector(compare:)] retain];
    
    // now build up location sequence and prepare sounds
    
    [_locationSequence release];
    _locationSequence = nil;
    


    BOOL firstFrame = YES;
    
    NSMutableArray* locArray = [NSMutableArray arrayWithCapacity:[inConfig count]];
    for ( NSNumber* timeKey in _sortedFrameKeys ) {
        CGPoint frameLoc = CGPointMake( 0.0, 0.0);
 
		NSDictionary* datum = [_config objectForKey:timeKey];
		
		AVAudioPlayer* sound = [datum objectForKey:kSCANSoundObjectKey];
		
		if ( sound != nil )
		{
			[sound prepareToPlay];
		}
        
        if (!firstFrame) {
            NSNumber* horizDelta = [datum objectForKey:kSCANHorizontalTranslationKey];
            NSNumber* vertDelta = [datum objectForKey:kSCANVerticalTranslationKey];
            
            frameLoc = CGPointMake( frameLoc.x + ( horizDelta != nil ? [horizDelta floatValue] : 0 ),
                                   frameLoc.y + ( vertDelta != nil ? [vertDelta floatValue] : 0 ) );
        }
        
        NSData* locData = [NSData dataWithBytes:&frameLoc length:sizeof(frameLoc)];
        
        [locArray addObject:locData];
        
        firstFrame = NO;
        
    }
    
    _locationSequence = [[NSArray arrayWithArray:locArray] retain];
    
}

-(void)setStillImage:(UIImage *)inImage
{
	if (_stillImage != nil)
	{
		[_stillImage release];
		_stillImage = nil;
        self.contents = nil;
	}
	
	if (inImage != nil)
	{
		_stillImage = [inImage retain];
        if (!self.isAnimating) {
            self.contents = (id)_stillImage.CGImage;
            self.contentsScale = _stillImage.scale;
        }
	}
    
	
}

-(NSTimeInterval)naturalCycleDuration {
    if ((self.config != nil)&&( self.config.count > 0 ))
	{
		NSTimeInterval maxTime = 0;
		
		for ( NSNumber* timeKey in self.config )
		{
			NSTimeInterval timeKeyValue = [timeKey doubleValue];
			if ( timeKeyValue > maxTime )
			{
				maxTime = timeKeyValue;
			}
			
			
			NSDictionary* datum = [self.config objectForKey:timeKey];
			
			AVAudioPlayer* sound = [datum objectForKey:kSCANSoundObjectKey];
			
			if ( sound != nil )
			{
				NSTimeInterval frameEndTime = timeKeyValue + sound.duration;
				
				if ( frameEndTime > maxTime )
				{
					maxTime = frameEndTime;
				}
			}
			
			NSNumber* lastFrameTime = [datum objectForKey:kSCANLastFrameDurationKey];
			
			if ( lastFrameTime != nil )
			{
				NSTimeInterval frameEndTime = timeKeyValue + ([lastFrameTime doubleValue]);
				
				if ( frameEndTime > maxTime )
				{
					maxTime = frameEndTime;
				}
			}
			
		}
		
		return maxTime;
	}
	else 
	{
		return 0;
	}
}


-(NSTimeInterval)cycleDuration {
    
    if ( _assignedAnimationTime != nil ) {
        return [_assignedAnimationTime doubleValue];
    }
    else {
        return self.naturalCycleDuration;
    }
}

-(void)setCycleDuration:(NSTimeInterval)inCycleDuration {
    if (_assignedAnimationTime != nil) {
        [_assignedAnimationTime release];
        _assignedAnimationTime = nil;
    }
    
    if ( inCycleDuration >= 0 ) {
        _assignedAnimationTime = [[NSNumber numberWithDouble:inCycleDuration] retain];
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}


-(void)setContents:(id)contents {
    
    [super setContents:contents];
}

#pragma mark - Public Methods

-(void)startAnimating
{
	//
	// NSUIntegerMax is  sentinal value indicating to cycle animaitons with no end
	//
    [self animateWithCycleCount:NSUIntegerMax withCompletionInvocation:nil finalStaticImage:nil];
	
}

- (void)animateOnceWithCompletionInvocation:(NSInvocation*)inInvocation
{
    [self animateWithCycleCount:1 withCompletionInvocation:inInvocation finalStaticImage:nil];
    
}

- (void)animateOnceWithCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage {
    
    [self animateWithCycleCount:1 withCompletionInvocation:inInvocation finalStaticImage:inFinalStaticImage];
}

- (void)animateWithCycleCount:(NSUInteger)inCycleCount withCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage {
    
    
    self.completionInvocation = inInvocation;
    _finalStillImage = [inFinalStaticImage retain];
    
    [self startAnimationCycleWithCycleCount:inCycleCount repeatDuration:0];
}

- (void)animateRepeatedlyForDuration:(NSTimeInterval)inRepeatDuration withCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage {
    
    
    self.completionInvocation = inInvocation;
    _finalStillImage = [inFinalStaticImage retain];
    
    [self startAnimationCycleWithCycleCount:0 repeatDuration:inRepeatDuration];
}


#pragma mark - Class Methods



+(NSDictionary*)configFromPropertList:(NSDictionary*)inPropertyList
{
	if (inPropertyList == nil)
	{
		return nil;
	}
	
	MKDefaultAnimationObjectFactory* objectFactory = [[MKDefaultAnimationObjectFactory alloc] init];
	
	NSDictionary* config = [MKSoundCoordinatedAnimationLayer configFromPropertList:inPropertyList usingObjectFactory:objectFactory];

	[objectFactory release];
	
	return config;
}


//
// converts a "property list" configuration dictionary to the format expected by the config property of an instance.
// The "property list" verison of the configuraiton does not contain sound or image objects, but in stead filenames.
// This method will generate a config dictionary containin the sound and image objects based. Useful for configuring
// an animation with a plist file.
// The property list format is:
//
// key = NSNumber containing a float value indicating he number of seconds since start this item should be applied
// value = a dictionary containing one or more of the following key/value pairs
//					key		         | value
//				---------------------+------------------------------------------------------------
//				 "soundFile"	     | the file name a sound file, including extension (NSString)
//				 "imageFile"	     | the file name of an image, inclding extension (NSString)
//				 "lastFrameDuration" | If this is the last frame, a NSNumber indicating the minimum duration of frame.
//								     | Note that animation will not cycle until all sounds initated in current cycle are complete.
//

+(NSDictionary*)configFromPropertList:(NSDictionary*)inPropertyList usingObjectFactory:(id <MKSoundCoordinatedAnimationObjectFactory>)inObjectFactory
{
	if (inPropertyList == nil)
	{
		return nil;
	}
	
	NSMutableDictionary* configDict = [NSMutableDictionary dictionaryWithCapacity:[inPropertyList count]];
	
	for ( NSNumber* timeKey in inPropertyList )
	{
		NSDictionary* frameProperties = [inPropertyList objectForKey:timeKey];
		
		NSMutableDictionary* frameConfig = [NSMutableDictionary dictionaryWithCapacity:[frameProperties count]];
		
		//
		// frame sound
		//
		
		NSString* soundFileName = [frameProperties objectForKey:kSCANSoundFileNameKey];
		
		AVAudioPlayer *player = [inObjectFactory getAVAudioPlayerForFilename:soundFileName];
		
		if (player != nil)
		{
			[frameConfig setObject:player forKey:kSCANSoundObjectKey];
		}

		//
		// frame image
		//
		
		NSString* imageFileName = [frameProperties objectForKey:kSCANImageFileNameKey];
		
		if ( imageFileName != nil ) {
			UIImage* image = [inObjectFactory getUIImageForFilename:imageFileName];
			
			if (image != nil)
			{
				[frameConfig setObject:image forKey:kSCANImageObjectKey];
			}
		}
		
		
		//
		// last frame duration
		//
		
		id durationObj = [frameProperties objectForKey:kSCANLastFrameDurationKey];
		
		if ( durationObj != nil )
		{
			[frameConfig setObject:durationObj forKey:kSCANLastFrameDurationKey];
		}
		
        
        //
        // translations
        //
        
        id horizTransValue = [frameProperties objectForKey:kSCANHorizontalTranslationKey];
		if ( horizTransValue != nil )
		{
			[frameConfig setObject:horizTransValue forKey:kSCANHorizontalTranslationKey];
		}

        id vertTransValue = [frameProperties objectForKey:kSCANVerticalTranslationKey];
		if ( vertTransValue != nil )
		{
			[frameConfig setObject:vertTransValue forKey:kSCANVerticalTranslationKey];
		}


        id rotValue = [frameProperties objectForKey:kSCANRotationPositionDegreesKey];
		if ( rotValue != nil )
		{
			[frameConfig setObject:rotValue forKey:kSCANRotationPositionDegreesKey];
		}

        //
        // time key
        //
        [configDict setObject:frameConfig forKey:timeKey];

	}
	
	return configDict;
	
	
}

//
// UIImage objects can shared between multiple instnaces of a given animation, but AVAudioPlayer objects
// cannot because each animation instance may have a different play state. This method will "copy" a config
// dictionary by producing an (autoreleased) copy of it where the UIImage objects are shared by the 
// AVAudioPlayer objects are distinct copies. 
+(NSDictionary*)copyConfig:(NSDictionary*)inConfig
{
	NSMutableDictionary* newConfigDict = [NSMutableDictionary dictionaryWithCapacity:[inConfig count]];
	
	for ( NSNumber* timeKey in inConfig )
	{
		NSDictionary* sourceFrameConfig = [inConfig objectForKey:timeKey];
		
		NSMutableDictionary* frameConfig = [NSMutableDictionary dictionaryWithCapacity:[sourceFrameConfig count]];
		
		//
		// create a new sound object
		//
		AVAudioPlayer* soundObj = [sourceFrameConfig objectForKey:kSCANSoundObjectKey];
		if ( soundObj != nil )
		{
			AVAudioPlayer* newSoundObj = nil;
			
			if ( soundObj.url != nil )
			{
				NSError* sndErr;
				
				newSoundObj = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundObj.url error:&sndErr] autorelease];
				
				if ( sndErr != nil )
				{
					NSLog(@"Error creating AVAudioPlayer with URL '%@': %@", soundObj.url, [sndErr localizedDescription]);
					
					newSoundObj = nil;
				}
			}
			else if ( soundObj.data != nil )
			{
				NSError* sndErr;
				
				newSoundObj = [[[AVAudioPlayer alloc] initWithData:soundObj.data error:&sndErr] autorelease];
				
				
				if ( sndErr != nil )
				{
					NSLog(@"Error creating AVAudioPlayer from source data: %@", [sndErr localizedDescription]);
					
					newSoundObj = nil;
				}
				
			}
			
			if ( newSoundObj != nil )
			{
				[frameConfig setObject:newSoundObj forKey:kSCANSoundObjectKey];
			}
		}
		
		id imageObj = [sourceFrameConfig objectForKey:kSCANImageObjectKey];
		
		if ( imageObj != nil )
		{
			[frameConfig setObject:imageObj forKey:kSCANImageObjectKey];
		}
		
		id durationObj = [sourceFrameConfig objectForKey:kSCANLastFrameDurationKey];
		
		if ( durationObj != nil )
		{
			[frameConfig setObject:durationObj forKey:kSCANLastFrameDurationKey];
		}
		
        id horizTransValue = [sourceFrameConfig objectForKey:kSCANHorizontalTranslationKey];
		if ( horizTransValue != nil )
		{
			[frameConfig setObject:horizTransValue forKey:kSCANHorizontalTranslationKey];
		}
        
        id vertTransValue = [sourceFrameConfig objectForKey:kSCANVerticalTranslationKey];
		if ( vertTransValue != nil )
		{
			[frameConfig setObject:vertTransValue forKey:kSCANVerticalTranslationKey];
		}


        id rotValue = [sourceFrameConfig objectForKey:kSCANRotationPositionDegreesKey];
		if ( rotValue != nil )
		{
			[frameConfig setObject:rotValue forKey:kSCANRotationPositionDegreesKey];
		}

		[newConfigDict setObject:frameConfig forKey:timeKey];
	}
	
	return [newConfigDict retain];
	
}

#pragma mark - Sound Management Methods

- (void)soundPlayTimerFireMethod:(NSTimer*)theTimer {
    
    AVAudioPlayer* sound = (AVAudioPlayer*)[theTimer userInfo];
    
    sound.delegate = self;
    
    [_playingSounds addObject:sound];
    
    [sound play];
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)inPlayer successfully:(BOOL)inDidFinish
{
	AVAudioPlayer* playingSound = [_playingSounds member:inPlayer];
	
	if ( playingSound != nil )
	{
		[playingSound stop];
		playingSound.currentTime = 0;
		[playingSound prepareToPlay];
		[_playingSounds removeObject:playingSound];
	}
}

-(void)stopSounds
{
	for (AVAudioPlayer* playingSound in _playingSounds)
	{
		[playingSound stop];
		playingSound.currentTime = 0;
		[playingSound prepareToPlay];
	}
	
	[_playingSounds removeAllObjects];
}


#pragma mark - Animation Code

-(void)startAnimationCycleWithCycleCount:(NSUInteger)inCycleCount repeatDuration:(NSTimeInterval)inRepeatDuration {
    _animationStartPosition = self.position;

    
    if (_animationGroup == nil) {
        [self setUpAnimationFrames];
    }
    
    [CATransaction lock];
    [CATransaction begin];
        
    NSTimeInterval duration = self.cycleDuration;
    _animationGroup.duration = duration;
    
    for (CAAnimation* animation in _animationGroup.animations) {
        animation.duration = duration;
    }
    
    if ( inCycleCount > 0 ) {
        _animationGroup.repeatCount = inCycleCount;
        _animationGroup.repeatDuration = 0;
    }
    else {
        _animationGroup.repeatCount = 0;
        _animationGroup.repeatDuration = inRepeatDuration;
    }
    
    if (_finalStillImage != nil) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.stillImage = _finalStillImage;
        [CATransaction commit];
        
        [_finalStillImage release];
        _finalStillImage = nil;
    }
    
	[self addAnimation:_animationGroup forKey:kSCANImageAndPositingAniamtionKey];
    
    [CATransaction commit];
    [CATransaction unlock];
    
    [self performSelectorOnMainThread:@selector(setUpSoundTimers) withObject:nil waitUntilDone:NO];
}

-(void)setUpSoundTimers {
    
    if ( !self.silenced && _soundPlayDict != nil && [_soundPlayDict count] > 0 ) {
        NSUInteger soundListSize = [_soundPlayDict count];
        
        _soundTimers = [[NSMutableArray arrayWithCapacity:soundListSize] retain];
        
        NSArray* timeKeys = [_soundPlayDict allKeys];
        for ( NSNumber* key in timeKeys ) {
            NSTimeInterval keyValue = [key floatValue];
            
            NSDate* fireTime = [NSDate dateWithTimeIntervalSinceNow:keyValue];
                
            NSTimer* timer = [[[NSTimer alloc] initWithFireDate:fireTime
                                                           interval:self.cycleDuration 
                                                             target:self
                                                           selector:@selector(soundPlayTimerFireMethod:) 
                                                           userInfo:[_soundPlayDict objectForKey:key]
                                                            repeats:YES] autorelease];
                
                
            [_soundTimers addObject:timer];
                
          
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                
        }
    }
}


// Stops the animation, either immediately or after the end of the current loop.
-(void)stopAnimatingImmeditely:(BOOL)inImmediately
{
    if ( inImmediately ) {
        if ( self.isAnimating ) {
            [self removeAnimationForKey:kSCANImageAndPositingAniamtionKey]; 
            
            
            if ( _animationGroup != nil ) {
                [_animationGroup release];
                _animationGroup = nil;
            }
            
            // set the animating flag. Technically, the animation doesn't stop until the animationDidStop callback is called. 
            _isAnimating = NO;
        }
    }
    else {
        NSLog(@"Defered animation stopping is not supported.");
    }
}


-(void)setUpAnimationFrames {
    
    if (self.isAnimating) {
        NSLog(@"setting up animation frames for %@, but already animating. Killing.", self);
        [self stopAnimatingImmeditely:YES];
    }
    
    if ( _animationGroup != nil ) {
        [_animationGroup release];
        _animationGroup = nil;
    }
    if ( _soundPlayDict != nil ) {
        [_soundPlayDict release];
        _soundPlayDict = nil;
    }
    
    //
    // key times
    // normalize frame keys
    //
    
    CGFloat naturalDuration = self.naturalCycleDuration;
    
    if (naturalDuration <= 0) {
        NSLog(@"Error! Animation duration value = %f", naturalDuration );
        return;
    }
    
    NSMutableArray* imageKeyArray = [NSMutableArray arrayWithCapacity:[_sortedFrameKeys count]];
    NSMutableArray* imageArray = [NSMutableArray arrayWithCapacity:[_sortedFrameKeys count]];

    NSMutableArray* positionKeyArray = [NSMutableArray arrayWithCapacity:[_sortedFrameKeys count]];
    CGMutablePathRef positionPath = CGPathCreateMutable();
    CGPoint firstPt = self.position;
    [positionKeyArray addObject:[NSNumber numberWithFloat:0]];
    CGPathMoveToPoint(positionPath,NULL, firstPt.x, firstPt.y);
    
    
    NSMutableArray* rotationKeyArray = [NSMutableArray arrayWithCapacity:[_sortedFrameKeys count]];
    NSMutableArray* rotationValueArray = [NSMutableArray arrayWithCapacity:[_sortedFrameKeys count]];
    CATransform3D firstTransform = self.transform;
    [rotationKeyArray addObject:[NSNumber numberWithFloat:0]];
    [rotationValueArray addObject:[NSValue valueWithCATransform3D:firstTransform]];
    
    _soundPlayDict = [[NSMutableDictionary dictionaryWithCapacity:[_sortedFrameKeys count]] retain];
    
    NSUInteger frameIndex = 0;
    
    UIImage* firstImage = nil;
    
    BOOL hasMoveAnimation = NO;
    BOOL hasRotateAnimation = NO;
    
    for ( NSNumber* frameKey in _sortedFrameKeys ) {
        
        NSNumber* normalizedFrameKey = [NSNumber numberWithFloat:([frameKey floatValue]/naturalDuration)];
        
        //
        // first determine if the frame has an image
        //
        
        
        NSDictionary* datum = [self.config objectForKey:frameKey];
        
        UIImage* image = [datum objectForKey:kSCANImageObjectKey];

        if ( image != nil ) {
            [imageKeyArray addObject:normalizedFrameKey];
            [imageArray addObject:(id)image.CGImage];
                        
            if ( firstImage == nil ) {
                firstImage = image;
            }
        }
        
         
        if (frameIndex > 0 ) {
        
            //
            // add position
            //

            NSNumber* horizDelta = [datum objectForKey:kSCANHorizontalTranslationKey];
            NSNumber* vertDelta = [datum objectForKey:kSCANVerticalTranslationKey];

            if ( horizDelta != nil || vertDelta != nil ) {
                hasMoveAnimation = YES;
                
                if (horizDelta == nil) {
                    horizDelta = [NSNumber numberWithFloat:0];
                }
                if (vertDelta == nil) {
                    vertDelta = [NSNumber numberWithFloat:0];
                }
                
                [positionKeyArray addObject:normalizedFrameKey];
                CGPathAddLineToPoint(positionPath, NULL, firstPt.x + [horizDelta floatValue], firstPt.y + [vertDelta floatValue]);
                
            }
 
        
            //
            // Add Rotation
            //

            NSNumber* rotationValue = [datum objectForKey:kSCANRotationPositionDegreesKey];
            
            if ( rotationValue != nil ) {
                hasRotateAnimation = YES;
                CGFloat rotRadians = [rotationValue floatValue]*(M_PI/180.0);
                
                CATransform3D rotTransform = CATransform3DConcat(firstTransform, CATransform3DMakeRotation( rotRadians, 0, 0, 1));
                
                [rotationKeyArray addObject:normalizedFrameKey];
                [rotationValueArray addObject:[NSValue valueWithCATransform3D:rotTransform]];
                
            }
        }
        

        
        
        //
        // add sound
        //
        
        AVAudioPlayer* sound = [datum objectForKey:kSCANSoundObjectKey];
        
        if ( sound != nil ) {
            [_soundPlayDict setObject:sound forKey:frameKey];
        }
        
                           
        //
        // get ready for next
        //
        
        
        frameIndex++;
    }
    
    // add return to hom path
    NSNumber* lastKey = [NSNumber numberWithFloat:1.0];
    [positionKeyArray addObject:lastKey];
    CGPathAddLineToPoint(positionPath, NULL, firstPt.x, firstPt.y);
    
    
    [rotationKeyArray addObject:lastKey];
    [rotationValueArray addObject:[NSValue valueWithCATransform3D:firstTransform]];
    
    // must all image at time key 1.0 so that loops works correctly
    if (firstImage != nil && ![imageKeyArray containsObject:lastKey]) {
        [imageKeyArray addObject:lastKey];
        [imageArray addObject:(id)firstImage.CGImage];
        
    }
    //
    // set up the animation
    //
    NSTimeInterval cycleDuration = self.cycleDuration;
    
    CAKeyframeAnimation* imageAnimation = nil;
    
    if ([imageArray count] > 0 ) {
        imageAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        imageAnimation.keyTimes = imageKeyArray;
        imageAnimation.calculationMode = kCAAnimationDiscrete;
//        imageAnimation.calculationMode = kCAAnimationLinear;
        imageAnimation.values = imageArray;
        imageAnimation.duration = cycleDuration;    
        imageAnimation.delegate = self;
    }
    
    
    CAKeyframeAnimation* positionAnimation = nil;
    
    if ( hasMoveAnimation ) {
        positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.keyTimes = positionKeyArray;
        positionAnimation.calculationMode = kCAAnimationLinear;
        positionAnimation.path = positionPath;
        positionAnimation.duration = cycleDuration;
        positionAnimation.delegate = self; 
    }
    
    CFRelease(positionPath);
    
    
    CAKeyframeAnimation* rotationAnimation = nil;
    
    if ( hasRotateAnimation ) {
        rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        rotationAnimation.keyTimes = rotationKeyArray;
        rotationAnimation.calculationMode = kCAAnimationLinear;        
        rotationAnimation.values = rotationValueArray;
        rotationAnimation.duration = cycleDuration;    
        rotationAnimation.delegate = self;
    }
    
    
    //
    // create the group
    //
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	theGroup.duration = cycleDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
    NSMutableArray* animationList = [NSMutableArray arrayWithCapacity:3];
    
    if ( imageAnimation != nil ) {
        [animationList addObject:imageAnimation];
    }
    if ( positionAnimation != nil ) {
        [animationList addObject:positionAnimation];
    }
    if ( rotationAnimation != nil ) {
        [animationList addObject:rotationAnimation];
    }
   
	theGroup.animations = animationList;
	
    theGroup.delegate = self;
    theGroup.removedOnCompletion = YES;

    _animationGroup = [theGroup retain];
}

- (void)animationDidStart:(CAAnimation *)inAnimation {

    _isAnimating = YES;
        
}
                          

- (void)animationDidStop:(CAAnimation *)inAnimation finished:(BOOL)inDidFinish {
    
    _isAnimating = NO;
    
    [self stopSounds];
    
    if (_soundTimers != nil) {
        for ( NSTimer* timer in _soundTimers ) {
            AVAudioPlayer* sound = (AVAudioPlayer*)[timer userInfo];
            
            [sound stop];
            
            [timer invalidate];
        }
        
        [_soundTimers release];
        _soundTimers = nil;
    }
    if ( inDidFinish ) {
 
    }
    
    [_animationGroup release];
    _animationGroup = nil;
    [_soundPlayDict release];
    _soundPlayDict = nil;
    
    self.contents = (id)self.stillImage.CGImage;
    self.contentsScale = self.stillImage.scale;


    if (self.completionInvocation != nil ) {
        
        NSInvocation* invo = [self.completionInvocation retain];
        
        // set to nil prior to invoke in case invoke sets up a new animation with it's own invocation
        self.completionInvocation = nil;
        
        [invo invoke];
        [invo release];
        
    }
}

@end

#pragma mark - Default Animation Object Factory

@implementation MKDefaultAnimationObjectFactory

-(UIImage*)getUIImageForFilename:(NSString*)inFilename
{
	if (inFilename != nil)
	{
		NSString* pathStr;
		
		
		//
		// if it is desired to load a specific localization, this code will need to be altered to use [NSBundle pathForResource:ofType:inDirectory:forLocalization:]
		//
		
		pathStr = [[NSBundle mainBundle] pathForResource:inFilename ofType:nil];	
		
		if ( pathStr != nil )
		{
			UIImage* image = [UIImage imageWithContentsOfFile:pathStr];
			
			if ( image != nil )
			{
				return image;
			}
			else 
			{
				NSLog( @"MKDefaultAnimationObjectFactory: Could not create image with file path '%@'", pathStr );
			}
		}
	}
	
	return nil;
}

-(AVAudioPlayer*)getAVAudioPlayerForFilename:(NSString*)inFilename
{
	
	if ( inFilename != nil )
	{
		
		NSString* pathStr;
		
		
		//
		// if it is desired to load a specific localization, this code will need to be altered to use [NSBundle pathForResource:ofType:inDirectory:forLocalization:]
		//
		
		pathStr = [[NSBundle mainBundle] pathForResource:inFilename ofType:nil];	
		
		if ( pathStr != nil )
		{
			NSError* sndErr;
			
			NSURL *fileURL = [NSURL fileURLWithPath:pathStr isDirectory:NO];
			
			AVAudioPlayer *player = [[[ AVAudioPlayer alloc ] initWithContentsOfURL:fileURL error:(&sndErr) ] autorelease];
						
			if (sndErr == nil)
			{
				[player prepareToPlay];

				return player;
			}
			else
			{
				NSLog(@"MKDefaultAnimationObjectFactory: Error creating AVAudioPlayer with file path '%@': %@", pathStr, [sndErr localizedDescription]);
			}
			
		}	
	}
	
	return nil;
}	

@end
