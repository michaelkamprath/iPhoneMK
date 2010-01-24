//
//  MKSoundCoordinatedAnimationView.h
//  
// Copyright 2010 Michael F. Kamprath
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
//
// MKSoundCoordinatedAnimationView
// -------------------------------
//
// Use this class to display a complex animation sequence that is coordinated with sounds. This class is designed
// to allow you to configure an animation sequence with a property list. Note, however, there is a difference
// betweent he config dictionary passed to a MKSoundCoordinatedAnimationLayer instance and what one would
// store in a property list. The chief differnce is the instance's config dictionary contains actual image and sound 
// objects, while the property list contains image and sound file names. 
//
// This class is a subclass of UIView, so use as you would use a UIView. If you would rather use a CALayer subclass,
// use the MKSoundCoordinatedAnimationLayer class. MKSoundCoordinatedAnimationView simply wraps MKSoundCoordinatedAnimationLayer.
//


#import <UIKit/UIKit.h>
#import "MKSoundCoordinatedAnimationLayer.h"

@interface MKSoundCoordinatedAnimationView : UIView 
{
	MKSoundCoordinatedAnimationLayer* _animationLayer;
}

//
// Configuration dictionary format
//
// key = NSNumber containing a float value indicating he number of seconds since start this item should be applied
// value = a dictionary containing one or more of the following key/value pairs
//					key		         | value
//				---------------------+-------------------------------------------------
//				 "soundObj"          | the AVAudioPlayer sound object to start playing
//				 "imageObj"	         | the UIImage image object to display
//				 "lastFrameDuration" | If this is the last frame, a NSNumber indicating the minimum duration of frame.
//								     | Note that animation will not cycle until all sounds initated in current cycle are complete.
//
@property (retain,nonatomic) NSDictionary* config;

// This is the image that will be displayed when the view is not animating. If nil, the view will just
// be filled with the backgroundColor
@property (retain,nonatomic) UIImage* stillImage;

// A facto used to elongate (>1) or shrink (<1) the time of the animation as indicated
// by the config dictionary. If adjusted during animation, will take affect the frame after next.
// Does not impact the play duration of sound objects, just the frame kay times and last frame duration.
@property (assign,nonatomic) float timeScaleFactor;

// return the total time of the animtion considering what is in the config dictionary
// and the current value of the timeScaleFactor;
@property (readonly,nonatomic) NSTimeInterval animationSequenceDuration;

// Inidcates whether the viewis animating 
@property (readonly,nonatomic) BOOL isAnimating;

// Indicates whether the animation should be done with no sound regardless of config dictionary setting
// If set while animating, will prevent the next sound to be played fom playing, but will not stop any currently
// plying sound.
@property (assign,nonatomic,getter=isSilenced) BOOL silenced;


// starts the animation sequence on an endless loop. If currently animating, no effect.
-(void)startAnimating;

// starts the animation sequence looping for a specific number of counts. 
// Passing 0 cycle count value has no effect. If called while animating, will set the 
// remining loop counter to passed value after current loop finishes. 
-(void)startAnimatingWithCycleCount:(NSUInteger)inCycleCount;


// Stops the animation, either immediately or after the end of the current loop.
-(void)stopAnimatingImmeditely:(BOOL)inImmediately;

//
// converts a "property list" configuration dictionary to the format expected by the config property of an instance.
// The "property list" verison of the configuraiton does not contain sound or image objects, but in stead filenames.
// This method will generate a config dictionary containin the sound and image objects based. Useful for configuring
// an animation with a plist file. Localization is honored.
//
// The property list format is:
//
// key = NSNumber containing a float value indicating he number of seconds since start this item should be applied
// value = a dictionary containing one or more of the following key/value pairs
//					key			     | value
//				---------------------+------------------------------------------------------------
//				 "soundFile"	     | the file name a sound file, including extension (NSString)
//				 "imageFile"	     | the file name of an image, inclding extension (NSString)
//				 "lastFrameDuration" | If this is the last frame, a NSNumber indicating the minimum duration of frame.
//								     | Note that animation will not cycle until all sounds initated in current cycle are complete.
//
+(NSDictionary*)configFromPropertList:(NSDictionary*)inPropertyList;

//
// Performs the same work as configFromPropertList:, but uses the passed MKSoundCoordinatedAnimationObjectFactory to generate
// the UIImage and AVAudioPlayer objects.
//

+(NSDictionary*)configFromPropertList:(NSDictionary*)inPropertyList usingObjectFactory:(id <MKSoundCoordinatedAnimationObjectFactory>)inObjectFactory;

//
// UIImage objects can shared between multiple instnaces of a given animation, but AVAudioPlayer objects
// cannot because each animation instance may have a different play state. This method will "copy" a config
// dictionary by producing an (autoreleased) copy of it where the UIImage objects are shared by the 
// AVAudioPlayer objects are distinct copies. 
+(NSDictionary*)copyConfig:(NSDictionary*)inConfig;

@end
