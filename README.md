# iPhoneMK

iPhoneMK is a loose collection of Objective-C classes for the iPhone SDK that I have put together over time which I feel might be of general utility to people. 

If you find any of these classes useful, I'd love to hear about it. If you have improvements for any of them, feel free to commit your changes. If you have any classes you would like to add to the collection, please provide them.

## Class List

### Views
* `MKNetworkImageView` - A view that displays an image downloaded from the internet.
* `MKNumberBadgeView` - A view that replicates and extends the number badge UI element in iOS
* `MKSoundCoordinatedAnimationView` - A view that enables "scripting" of `CAAnimation`'s via a plist.
* `MKTouchTrackingView` - A light weight view that simplifies detecting and responding to touches. Includes a variant that will properly detect touches against a animating `MKSoundCoordinatedAnimationLayer` layer that moves location on screen.

### Table View Cells
* `MKIconCheckMarkTableViewCell` - A cell that manages a boolean state and uses a configurable set of `UIImage` objects to represent that state. 
* `MKSocialShareTableViewCell` - A cell that makes it easy to use the `SLComposeViewController` features of iOS 6 from a `UITableView`.
* `MKSwitchControlTableViewCell` - A cell that simply provides a UISwitch to control a boolean state.

### Other
* `MKParentalGate` - A set of classes that implements a dexterity-based parental gate. Intended for use in apps for children under 5. 

## ARC Support

Some of iPhoneMK is not ARC-enabled code, some requires ARC. Compiler errors have been built into the code base to help you identify which classes need ARC and which don't. Furthermore, the errors instruct you how to change that file's compilation method to support it's ARC-mode. Basically, if you have an ARC-enabled project, you will need to use the `-fno-objc-arc` compiler flag on iPhoneMK source files that are not ARC-enabled. Similarly, if you are not using ARC, you will have to use the `-fobjc-arc` compiler flag on iPhoneMK source files that require ARC. 

## License

iPhoneMK is licensed under the Apache License, Version 2.0
