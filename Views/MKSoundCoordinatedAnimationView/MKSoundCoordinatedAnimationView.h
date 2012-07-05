//
//  MKSoundCoordinatedAnimationView.h
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
// Both animation meta data and frame data is held the configuration dictionary.
//
// Animation Meta Data
//
// key = "meta"
// value = a dictionary containing one or more of the following key/value pairs
//
//					key		         | value
//				---------------------+-------------------------------------------------
//               "anchorX"           | sets the anchor point for entire animation in the x-axis. Should be a NSNumber [0,1]. If only X (noy Y) is specified, current value 
//                                   | of Y will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.
//               "anchorY"           | sets the anchor point for entire animation in the y-axis. Should be a NSNumber [0,1]. If only Y (noy X) is specified, current value 
//                                   | of X will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.
//                                   | 
//
// Animation Frame Data
//
// key = NSNumber containing a float value indicating the number of seconds since start this frame should be applied
// value = a dictionary containing one or more of the following key/value pairs
//					key		         | value
//				---------------------+-------------------------------------------------
//				 "soundObj"          | the AVAudioPlayer sound object to start playing
//				 "imageObj"	         | the UIImage image object to display
//				 "lastFrameDuration" | If this is the last frame, a NSNumber indicating the minimum duration of frame.
//								     | Note that animation will not cycle until all sounds initated in current cycle are complete.
//               "deltaX"            | How far to translate the image center horizontally from it's starting point on frame 0. Will return to 0 on last frame.
//                                   | Should be a NSNumber. Frame 0 should have no delta. any defined will be ignored.
//               "deltaY"            | How far to translate the image center vertically from it's starting point on frame 0. Will return to 0 on last frame.
//                                   | Should be a NSNumber. Frame 0 should have no delta. any defined will be ignored.
//               "rotatePosDegrees"  | Rotational orientation (in degrees!) to rotate image to relative to orientation on frame 0. Will return to frame 0 orientation 
//                                   | on last frame. Should be a NSNumber
//               "alpha"             | Alpha value for layer as a whole. Should be a NSNumber [0,1].
//               "scaleX"            | Adjusts the scale in the x-axis. Should be an NSNumber.
//               "scaleY"            | Adjusts the scale in the y-axis. Should be an NSNumber.
//
@property (retain,nonatomic) NSDictionary* config;

// This is the image that will be displayed when the view is not animating. If nil, the view will just
// be filled with the backgroundColor
@property (retain,nonatomic) UIImage* stillImage;

// return the total time of the animtion considering what is in the config dictionary
@property (readonly,nonatomic) NSTimeInterval naturalCycleDuration;

// returns the cycle time of the animation. Can set it to a different value too
@property (assign,nonatomic) NSTimeInterval cycleDuration;

// Inidcates whether the viewis animating 
@property (readonly,nonatomic) BOOL isAnimating;

// Indicates whether the animation should be done with no sound regardless of config dictionary setting
// If set while animating, will prevent the next sound to be played fom playing, but will not stop any currently
// plying sound.
@property (assign,nonatomic,getter=isSilenced) BOOL silenced;

// The NSInvocation that will be invoked at the completion of an animation sequence.
@property (retain, nonatomic) NSInvocation* completionInvocation;

// starts the animation sequence on an endless loop. If currently animating, no effect.
-(void)startAnimating;

// starts the animation sequence looping for a specific number of counts. 
// Passing 0 cycle count value has no effect. If called while animating, will set the 
// remining loop counter to passed value after current loop finishes. 
- (void)animateWithCycleCount:(NSUInteger)inCycleCount withCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage;

// displays the animation sequence once, then fires the passed invocation.
// If animaiton is immediately stopped or this method is called again prior to the animation sequence completing,
// the orignal invocation will be not fired and released.
- (void)animateOnceWithCompletionInvocation:(NSInvocation*)inInvocation;


// displays the animation sequence once, completing with the final static image, then fires the passed invocation.
// If animation is immediately stopped or this method is called again prior to the animation sequence completing,
// the orignal invocation will be not fired and released.
- (void)animateOnceWithCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage;


// displays the animation sequence for the indicate duration.
// If animaiton is immediately stopped or this method is called again prior to the animation sequence completing,
// the orignal invocation will be not fired and released.
- (void)animateRepeatedlyForDuration:(NSTimeInterval)inRepeatDuration withCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage;

// Stops the animation, either immediately or after the end of the current loop.
-(void)stopAnimatingImmeditely:(BOOL)inImmediately;

//
// converts a "property list" configuration dictionary to the format expected by the config property of an instance.
// The "property list" verison of the configuraiton does not contain sound or image objects, but instead filenames.
// This method will generate a config dictionary containin the sound and image objects based. Useful for configuring
// an animation with a plist file. Localization is honored. Both animation meta data and frame data is held the configuration property list.
//
// The property list format is:
//
// Animation Meta Data
//
// key = "meta"
// value = a dictionary containing one or more of the following key/value pairs
//
//					key		         | value
//				---------------------+-------------------------------------------------
//               "anchorX"           | sets the anchor point for entire animation in the x-axis. Should be a NSNumber [0,1]. If only X (noy Y) is specified, current value 
//                                   | of Y will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.
//               "anchorY"           | sets the anchor point for entire animation in the y-axis. Should be a NSNumber [0,1]. If only Y (noy X) is specified, current value 
//                                   | of X will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.
//                                   | 
// key = NSNumber containing a float value indicating he number of seconds since start this item should be applied
// value = a dictionary containing one or more of the following key/value pairs
//					key			     | value
//				---------------------+------------------------------------------------------------
//				 "soundFile"	     | the file name a sound file, including extension (NSString)
//				 "imageFile"	     | the file name of an image, inclding extension (NSString)
//				 "lastFrameDuration" | If this is the last frame, a NSNumber indicating the minimum duration of frame.
//								     | Note that animation will not cycle until all sounds initated in current cycle are complete.
//               "deltaX"            | How far to translate the image center horizontally from it's starting point on frame 0. Will return to 0 on last frame.
//                                   | Should be a NSNumber.
//               "deltaY"            | How far to translate the image center vertically from it's starting point on frame 0. Will return to 0 on last frame.
//                                   | Should be a NSNumber.
//               "rotatePosDegrees"  | Rotational orientation (in degrees!) to rotate image to relative to orientation on frame 0. Will return to frame 0 orientation 
//                                   | on last frame. Should be a NSNumber
//               "alpha"             | Alpha value for layer as a whole. Should be a NSNumber [0,1].
//               "scaleX"            | Adjusts the scale in the x-axis. Should be an NSNumber.
//               "scaleY"            | Adjusts the scale in the y-axis. Should be an NSNumber.
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
