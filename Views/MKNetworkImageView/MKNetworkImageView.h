//
// MKNetworkImageView.h
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
//
// MKNetworkImageView
// ==================
//
// A very simple UIImageView-like class that allows you to set an image based on a URL. While we are waiting 
// for the image to be loaded from the URL, a acitivity indicator will be displayed against the background color 
// of the view.
//
// The basic concept of use for this class is to set the imageURL to an valid URL, the view will then display a activity indicator
// the image's data is loaded and the image is displayed. To change the image, simply set the imageURL to something else. You
// can also set the image directly through the image property. As a result of this, one should not treat the imageURL property as 
// always being the correct URL for the current image being displayed.
//

#import <UIKit/UIKit.h>

@interface MKNetworkImageView : UIView 
{
	NSURL* _imageURL;
	UIImageView* _imageView;
	UIActivityIndicatorView* _activityIndicator;
	UIColor* _fillColor;
}
@property (retain) NSURL* imageURL;
@property (retain) UIImage* image;

@end
