//
// MKNetworkImageView.m
//
// Copyright 2009 Michael F. Kamprath
// michael@claireware.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if __has_feature(objc_arc) && __clang_major__ >= 3
#error "iPhoneMK is not designed to be used with ARC. Please add '-fno-objc-arc' to the compiler flags of iPhoneMK files."
#endif // __has_feature(objc_arc)

#import "MKNetworkImageView.h"



@interface MKNetworkImageView ()

- (void)initObject;

@end

@implementation MKNetworkImageView
@dynamic imageURL;
@dynamic image;

- (id)initWithFrame:(CGRect)inFrame 
{
    if (self = [super initWithFrame:inFrame]) 
	{
		[self initObject];
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ( self = [super initWithCoder:decoder] )
	{
		[self initObject];
	}
	
	return self;
}

- (void)initObject
{
	// set the view's actual background color clear.
	[super setBackgroundColor:[UIColor clearColor]];
	
	CGRect viewFrame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
	
	_imageView = [[UIImageView alloc] initWithFrame:viewFrame];
	[self addSubview:_imageView];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_activityIndicator.center = CGPointMake( viewFrame.size.width/2.0, viewFrame.size.height/2.0);
	[self addSubview:_activityIndicator];
	
}


- (void)dealloc 
{
	[_fillColor release];
	[_imageURL release];
	[_imageView release];
	[_activityIndicator release];
	
    [super dealloc];
}

- (void)drawRect:(CGRect)rect 
{
	CGContextRef curContext = UIGraphicsGetCurrentContext();
	
	UIColor* fillColor;
	
	if ( nil == self.image )
	{
		fillColor = _fillColor;
	}
	else
	{
		fillColor = [UIColor clearColor];
	}
	
		
	CGContextSetFillColorWithColor( curContext, fillColor.CGColor );
	
	CGContextFillRect( curContext, self.bounds );
}



-(NSURL*)imageURL {
    return _imageURL;
}

- (void)setImageURL:(NSURL*)inURL
{
	[_imageURL release];
	
	if ( inURL != nil )
	{
		_imageURL = [inURL retain];
		[_activityIndicator startAnimating];
		[NSThread detachNewThreadSelector:@selector(downloadAndSetImageFromURL:) toTarget:self withObject:_imageURL];
	}
	else
	{
		_imageURL = nil;
		self.image = nil;
		
		[self setNeedsDisplay];
	}
}

- (void)setImage:(UIImage*)inImage
{
	if ( inImage != nil )
	{
		[_activityIndicator stopAnimating];
	}
	
	[self setNeedsDisplay];
	
	_imageView.image = inImage;
}

- (UIImage*)image
{
	return _imageView.image;
}

- (void)downloadAndSetImageFromURL:(NSURL *)inURL
{
	// You must create a autorelease pool for all secondary threads.
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:inURL];
	
	if (imageData != nil)
	{
		UIImage* image = [[UIImage alloc] initWithData:imageData];
		
		if ( image != nil )
		{
			[self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
		
			[image release];
		}
		
		[imageData release];
	}
	
	[pool release];

}

//
// replace the super::setBackgroundColor so that it updates the _fillColor instead.
// 
- (void)setBackgroundColor:(UIColor *)inColor
{
	[_fillColor release];
	_fillColor = [inColor retain];
}

@end
