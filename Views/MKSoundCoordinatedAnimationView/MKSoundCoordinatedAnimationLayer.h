//
//  MKSoundCoordinatedAnimationLayer.h
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

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

/*!
 @protocol MKSoundCoordinatedAnimationObjectFactory
 @abstract Used to enable custom generation of @link UIImage @/link and @link AVAudioPlayer @/link objects.
 @discussion This protocol is used to allow clients to define their own factory for generating the @link UIImage @/link and @link AVAudioPlayer @/link
 objects in the @link MKSoundCoordinatedAnimationLayer @/link @link configFromPropertList: @/link  method.
 */
 
@protocol MKSoundCoordinatedAnimationObjectFactory <NSObject>

@required
/*!
 @method getUIImageForFilename:
 @abstract Returns an autoreleased UIImage object ascociated with the passed filename.
 @discussion Returns an autoreleased UIImage object ascociated with the passed filename. The UIImage object returned does not have to be unique across multiple 
 calls to to this method with identical file names passed. Called for "imageFile".
 @param inFilename The filename of the image file to be loaded.
 @result a @link UIImage @/link object.
 */
-(UIImage*)getUIImageForFilename:(NSString*)inFilename;

/*!
 @method getAVAudioPlayerForFilename:
 @abstract Returns an autoreleased AVAudioPlayer object ascociated with the passed filename.
 @discussion Returns an autoreleased AVAudioPlayer object ascociated with the passed filename. The AVAudioPlayer object returned should be unique across multiple 
 calls to to this method with identical file names passed. This is due to the need for each to have different play states.
 @param inFilename The filename of the sound file to be loaded.
 @result a @link AVAudioPlayer @/link object.
 */
-(AVAudioPlayer*)getAVAudioPlayerForFilename:(NSString*)inFilename;

@optional

@end

/*!
 @class MKSoundCoordinatedAnimationLayer
 @abstract A class that enables plist-based oncfiguration of complex @link CALayer @/link animations.
 @discussion Use this class to display a complex animation sequence that is coordinated with sounds. This class is designed to allow you to configure an 
 animation sequence with a property list. Note, however, there is a difference between the config dictionary passed to a MKSoundCoordinatedAnimationLayer 
 instance and what one would store in a property list. The chief differnce is the instance's config dictionary contains actual image and sound objects, while 
 the property list contains image and sound file names.
 
 This class is a subclass of CALayer, so use as you would use a CALayer. If you would rather use a UIView subclass, use the @link MKSoundCoordinatedAnimationView @/link 
 class, which effectively wraps this MKSoundCoordinatedAnimationLayer class in a UIView.
 
 */

@interface MKSoundCoordinatedAnimationLayer : CALayer <AVAudioPlayerDelegate>
{
	NSDictionary* _config;
	UIImage* _stillImage;
    UIImage* _finalStillImage;
	BOOL _silenced;
	
	NSMutableSet* _playingSounds;
    
	NSArray* _sortedFrameKeys;
	CGPoint _animationStartPosition;
    
	NSTimer* _timer;
	
	NSInvocation* _completionInvo;

	CGRect _originalBounds;
    
    
    CAAnimationGroup* _animationGroup;
    NSMutableDictionary* _soundPlayDict;
    NSMutableArray* _soundTimers;
    
    NSNumber* _assignedAnimationTime;
    
    BOOL _isAnimating;
 }

/*!
 @property config
 @abstract An NSDictionary containing the configuraiton of the animation the layer will play.
 @discussion The configuraiton of the animation the layer will play. Both animation meta data and frame data is held the configuration dictionary. The recognized contents of the dictionary are:
 
 <b>Animation Meta Data</b>
 
 key = "meta"
 
 value = a dictionary containing one or more of the following key/value pairs
 
 <center><table border="0" style="background-color:#EEEEEE" width="80%" cellpadding="3" cellspacing="3">
 <tr>
 <th width="20%">Key</th>
 <th>Value</th>
 </tr>
 <tr>
 <td>"anchorX"</td>
 <td>sets the anchor point for entire animation in the x-axis. Should be a NSNumber [0,1]. If only X (noy Y) is specified, current value of Y will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.</td>
 </tr>
 <tr>
 <td>"anchorY"</td>
 <td>sets the anchor point for entire animation in the y-axis. Should be a NSNumber [0,1]. If only Y (noy X) is specified, current value of X will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.</td>
 </tr>
 <tr>
 <td>"stillImageObj"</td>
 <td>The UIImage that the still image should be set to. This setting takes affect when this config is assigned to the layer. subsequent explicit assignments to stillImage property will overwrite this value.</td>
 </tr>
 <tr>
 <td>"scaleX"</td>
 <td>Adjusts the scale in the x-axis. Should be an NSNumber.</td>
 </tr>
 <tr>
 <td>"scaleY"</td>
 <td>Adjusts the scale in the y-axis. Should be an NSNumber.</td>
 </tr>
 </table></center>
 
 <b>Animation Frame Data</b>
 
 
 key = NSNumber containing a float value indicating he number of seconds since start this item should be applied
 value = a dictionary containing one or more of the following key/value pairs
 
 
 <center><table border="0" style="background-color:#EEEEEE" width="80%" cellpadding="3" cellspacing="3">
 <tr>
 <th width="20%">Key</th>
 <th>Value</th>
 </tr>
 <tr>
 <td>"soundObj"</td>
 <td>the AVAudioPlayer sound object to start playing</td>
 </tr>
 <tr>
 <td>"imageObj"</td>
 <td>the UIImage image object to display</td>
 </tr>
 <tr>
 <td>"lastFrameDuration"</td>
 <td>If this is the last frame, a NSNumber indicating the minimum duration of frame. Note that animation will not cycle until all sounds initated in current cycle are complete.</td>
 </tr>
 <tr>
 <td>"deltaX"</td>
 <td>How far to translate the image center horizontally from it's starting point on frame 0.  If you want it to return to 0, you must configure that. Should be a NSNumber.</td>
 </tr>
 <tr>
 <td>"deltaY"</td>
 <td>How far to translate the image center vertically from it's starting point on frame 0. Will return to 0 on last frame. Should be a NSNumber.</td>
 </tr>
 <tr>
 <td>"rotatePosDegrees"</td>
 <td>Rotational orientation (in degrees!) to rotate image to relative to orientation on frame 0.  If you want it to return to 0, you must configure that. Should be a NSNumber</td>
 </tr>
 <tr>
 <td>"alpha"</td>
 <td>Alpha value for layer as a whole. Should be a NSNumber [0,1].</td>
 </tr>
 <tr>
 <td>"scaleX"</td>
 <td>Adjusts the scale in the x-axis. Should be an NSNumber.</td>
 </tr>
 <tr>
 <td>"scaleY"</td>
 <td>Adjusts the scale in the y-axis. Should be an NSNumber.</td>
 </tr>
 </table></center>

 
 */
@property (retain,nonatomic) NSDictionary* config;

/*!
 @property stillImage
 @abstract The image to be used by the layer when animations are not active.
 @discussion This is the image that will be displayed when the view is not animating. If nil, the view will transparent.
 */
@property (retain,nonatomic) UIImage* stillImage;

/*!
 @property naturalCycleDuration
 @abstract The total cycle time of the animation as configured.
 */
@property (readonly,nonatomic) NSTimeInterval naturalCycleDuration;

/*!
 @property cycleDuration
 @abstract The total cycle time of the animation.
 @discussion This property allows you to alter the cycle time for the animation. Changing the value while an animation is in progress has no effect on the currently playing animation but will affect the cycle duration the next time the animation is started.  
 */
@property (assign,nonatomic) NSTimeInterval cycleDuration;

/*!
 @property isAnimating
 @abstract Indicates whether an animation is currently playing.
 */
@property (readonly,nonatomic) BOOL isAnimating;

/*!
 @property silenced
 @abstract Indicates whether the counds should be played or not.
 @discussion  Indicates whether the animation should be done with no sound regardless of config dictionary setting. If set while animating, will prevent the next sound to be played fom playing, but will not stop any currently playing sound.
 */
@property (assign,nonatomic,getter=isSilenced) BOOL silenced;

/*!
 @property completionInvocation
 @abstract the NSInvocation to be invoked when the animation is complete.
 @discussion If set to nil, no invocation will be fired.
 */
@property (retain, nonatomic) NSInvocation* completionInvocation;

/*!
 @method startAnimating
 @abstract Stars playing the currently configured animation.
 @discussion If called while an animation is playing, this method will have no effect.
 */
-(void)startAnimating;

/*!
 @method animateWithCycleCount:withCompletionInvocation:finalStaticImage:
 @abstract starts the animation sequence looping for a specific number of counts. 
 @discussion assing 0 cycle count value has no effect. If called while animating, will set the current loop counter to passed value after current loop finishes.
 */
- (void)animateWithCycleCount:(NSUInteger)inCycleCount withCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage;


/*!
 @method animateOnceWithCompletionInvocation:
 @abstract Runs the animation sequence once, then fires the passed invocation.
 @discussion If animation is immediately stopped or this method is called again prior to the animation sequence completing, the orignal invocation will be released and not fired.
 */
- (void)animateOnceWithCompletionInvocation:(NSInvocation*)inInvocation;

/*!
 @method animateOnceWithCompletionInvocation:finalStaticImage:
 @abstract Runs the animation sequence once, completing with the final static image, then fires the passed invocation.
 @discussion If animation is immediately stopped or this method is called again prior to the animation sequence completing, the orignal invocation will be released and not fired.
 */
- (void)animateOnceWithCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage;



/*!
 @method animateRepeatedlyForDuration:withCompletionInvocation:finalStaticImage:
 @abstract Runs the animation sequence for the indicated duration, completing with the final static image, then fires the passed invocation.
 @discussion If animation is immediately stopped or this method is called again prior to the animation sequence completing, the orignal invocation will be released and not fired.
 */
- (void)animateRepeatedlyForDuration:(NSTimeInterval)inRepeatDuration withCompletionInvocation:(NSInvocation*)inInvocation finalStaticImage:(UIImage*)inFinalStaticImage;

/*!
 @method stopAnimatingImmeditely:
 @param inImmediately BOOL indicating whether the animation stop should occur now (YES) or wait until the end of the currently playing loop (NO).
 @abstract Stops the currently playing animtion, returning the displayed inmage to the static image.
 */
- (void)stopAnimatingImmeditely:(BOOL)inImmediately;

/*!
 @method pauseAnimation
 @abstract Pauses all animations in this layer, ostensibly to be resumed later. Not calling resumeAnimation will prevant any animation in the layer from working. Note that you can change animations while the layer's animations are paused.
 */
- (void)pauseAnimation;

/*!
 @method resumeAnimation
 @abstract Resumes animation in this layer after they have been paused. 
 */
- (void)resumeAnimation;

/*!
 @method configFromPropertList:
 @abstract Generates a animation configuration dictionary from a property list styled dictionary.
 @param inPropertyList NSDictionary containing property list data
 @discussion convert's a "property list" configuration dictionary to the format expected by the config property of an instance.
 The "property list" verison of the configuraiton does not contain sound or image objects, but instead filenames. This method is useful
 for converting a configuration stored in a *.plist file into a usable configuration dictionary. This method will generate a config dictionary containin 
 the sound and image objects based. Useful for configuring an animation with a plist file. Localization is honored. Both animation meta data and frame 
 data is held the configuration property list.

 The property list format is:

 <b>Animation Meta Data</b>

 key = "meta"
 
 value = a dictionary containing one or more of the following key/value pairs
 
 <center><table border="0" style="background-color:#EEEEEE" width="80%" cellpadding="3" cellspacing="3">
 <tr>
 <th width="20%">Key</th>
 <th>Value</th>
 </tr>
 <tr>
 <td>"anchorX"</td>
 <td>sets the anchor point for entire animation in the x-axis. Should be a NSNumber [0,1]. If only X (noy Y) is specified, current value of Y will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.</td>
 </tr>
 <tr>
 <td>"anchorY"</td>
 <td>sets the anchor point for entire animation in the y-axis. Should be a NSNumber [0,1]. If only Y (noy X) is specified, current value of X will be maintained. Will automatically offset the position for this animation so that the layer does not visually move.</td>
 </tr>
 <tr>
 <td>"stillImageFile"</td>
 <td>The the file name of an image, inclding extension, that the still image should be set to. This setting takes affect when this config is assigned to the layer. subsequent explicit assignments to stillImage property will overwrite this value.</td>
 </tr>
 <tr>
 <td>"scaleX"</td>
 <td>Adjusts the scale in the x-axis. Should be an NSNumber.</td>
 </tr>
 <tr>
 <td>"scaleY"</td>
 <td>Adjusts the scale in the y-axis. Should be an NSNumber.</td>
 </tr>
 </table></center>

 <b>Animation Frame Data</b>
 
 
 key = NSNumber containing a float value indicating he number of seconds since start this item should be applied
 value = a dictionary containing one or more of the following key/value pairs
 
 
 <center><table border="0" style="background-color:#EEEEEE" width="80%" cellpadding="3" cellspacing="3">
 <tr>
 <th width="20%">Key</th>
 <th>Value</th>
 </tr>
 <tr>
 <td>"soundFile"</td>
 <td>the file name a sound file, including extension (NSString)</td>
 </tr>
 <tr>
 <td>"imageFile"</td>
 <td>the file name of an image, inclding extension (NSString)</td>
 </tr>
 <tr>
 <td>"lastFrameDuration"</td>
 <td>If this is the last frame, a NSNumber indicating the minimum duration of frame. Note that animation will not cycle until all sounds initated in current cycle are complete.</td>
 </tr>
 <tr>
 <td>"deltaX"</td>
 <td>How far to translate the image center horizontally from it's starting point on frame 0.  If you want it to return to 0, you must configure that. Should be a NSNumber.</td>
 </tr>
 <tr>
 <td>"deltaY"</td>
 <td>How far to translate the image center vertically from it's starting point on frame 0. Will return to 0 on last frame. Should be a NSNumber.</td>
 </tr>
 <tr>
 <td>"rotatePosDegrees"</td>
 <td>Rotational orientation (in degrees!) to rotate image to relative to orientation on frame 0.  If you want it to return to 0, you must configure that. Should be a NSNumber</td>
 </tr>
 <tr>
 <td>"alpha"</td>
 <td>Alpha value for layer as a whole. Should be a NSNumber [0,1].</td>
 </tr>
 <tr>
 <td>"scaleX"</td>
 <td>Adjusts the scale in the x-axis. Should be an NSNumber.</td>
 </tr>
 <tr>
 <td>"scaleY"</td>
 <td>Adjusts the scale in the y-axis. Should be an NSNumber.</td>
 </tr>
 </table></center>
 @result A NSDictionary object containing the built animation configuration. This dictionary may be assigned to the @link config @/link property of a @link MKSoundCoordinatedAnimationLayer @/link instance.
 */
 
+(NSDictionary*)configFromPropertList:(NSDictionary*)inPropertyList;



/*!
 @method configFromPropertList:usingObjectFactory:
 @abstract  Performs the same work as configFromPropertList:, but uses the passed MKSoundCoordinatedAnimationObjectFactory to generate the UIImage and AVAudioPlayer objects.
 @param inObjectFactory An object confirming to MKSoundCoordinatedAnimationObjectFactory which is used to generate the UIImage and AVAudioPlayer objects based on file paths.
 @discussion See @link configFromPropertList: @/link for detailed discussion on how the animation config is generated.
 @result A NSDictionary object containing the built animation configuration. This dictionary may be assigned to the @link config @/link property of a @link MKSoundCoordinatedAnimationLayer @/link instance.
 */
+(NSDictionary*)configFromPropertList:(NSDictionary*)inPropertyList usingObjectFactory:(id <MKSoundCoordinatedAnimationObjectFactory>)inObjectFactory;

/*!
 @method copyConfig:
 @param inConfig The configuration dictionary to be copied.
 @abstract Performs an appropiate copy of the passed animation configuraiton dictionary.
 @discussion UIImage objects can shared between multiple instnaces of a given animation, but AVAudioPlayer objects cannot because each animation instance may have a different play state. This method will "copy" a config dictionary by producing an (autoreleased) copy of it where the UIImage objects are shared but the AVAudioPlayer objects are distinct copies.
 @result A autoreleased copy of the passed animation configuration.
 */
+(NSDictionary*)copyConfig:(NSDictionary*)inConfig;

@end
