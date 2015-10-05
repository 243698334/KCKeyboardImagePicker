//
//  KCKeyboardImagePickerController.h
//  https://github.com/Kev1nChen/KCKeyboardImagePicker
//
//  Copyright (c) 2015 Kevin Yufei Chen
//  Special thanks to Chengkan Huang
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <UIKit/UIKit.h>

#import "KCKeyboardImagePickerView.h"

/**
 @abstract A KCKeyboardImagePickerAction object represents an action that can be 
 taken when tapping either the image picker controller button or an option button
 in the picker. The number of option buttons displayed on each image is determined
 by the number of unique actions added into the picker controller.
 */
@interface KCKeyboardImagePickerAction : NSObject

/**
 @abstract Create and return an action for the image picker controller button.
 @param viewController A view controller who is going to present the full screen
 UIImagePickerController.
 @param handler A block to execute when the user selects an image from the full
 screen UIImagePickerController.
 */
+ (instancetype)actionWithImagePickerControllerButtonHandler:(void (^) (UIImage *selectedImage))handler;

/**
 @abstract Create and return an action for an option button.
 @param tag An integer as the identifer of the option button. It will be used to
 match the style of the option button. The value `NSIntegerMin` is reserved.
 @param title A string as the title of the action, which will displayed on the
 corresponding option button.
 @param enabled A boolean indicating if 3D touch should be enabled for this action.
 @param handler A block to execute when the user taps on the corresponding option 
 button of this action.
 */
+ (instancetype)actionWithOptionButtonTag:(NSInteger)tag title:(NSString *)title forceTouchEnabled:(BOOL)enabled handler:(void (^) (UIImage *selectedImage))handler;

@end

/**
 @abstract A KCKeyboardImagePickerStyle object represents the style configuration
 applied on either the image picker controller button or an option button in the 
 picker. A style is optional for a button. It will matched by the tag with an 
 action object. 
 */
@interface KCKeyboardImagePickerStyle : NSObject

/**
 @abstract Create and return a style for the image picker controller button.
 @param backgroundColor The background color of the button.
 @param image The image displayed on this button.
 */
+ (instancetype)styleWithImagePickerControllerButtonBackgroundColor:(UIColor *)color image:(UIImage *)image;

/**
 @abstract Create and return a style for an option button.
 @param tag An integer as the identifer of the option button. It will be used to
 match the action of the option button. The value `NSIntegerMin` is reserved.
 @param titleColor The color of the title displayed on this button.
 @param backgroundColor The background color of the button.
 */
+ (instancetype)styleWithOptionButtonTag:(NSInteger)tag titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;

@end

@interface KCKeyboardImagePickerController : NSObject<UIViewControllerPreviewingDelegate>

/**
 @abstract The keyboard image picker view instance.
 */
@property (nonatomic, strong) KCKeyboardImagePickerView *imagePickerView;

/**
 @abstract The frame of the keyboard image picker view.
 @discussion It should always be the same as the keyboard's frame.
 */
@property (nonatomic, assign) CGRect keyboardFrame;

/**
 @abstract Change this flag to enable Force Touch preview on images.
 @discussion You have to enable Force Touch Preview in order to add options to
 the peek and pop action sheet.
 */
@property (nonatomic, assign, getter=isForceTouchPreviewEnabled) BOOL forceTouchPreviewEnabled;

/**
 @abstract The method to init the picker controller.
 @discussion The picker controller will keep a weak reference to the parent view
 controller who owns it. This reference is used for force touch features and image 
 picker controller features.
 @param parentViewController A reference to the view controller who owns the picker.
 In most cases, pass in `self`.
 */
- (id)initWithParentViewController:(UIViewController *)parentViewController;

/**
 @abstract Attaches an action to the keyboard image picker view.
 @discussion There should not be more than 4 actions for option buttons and 1 for
 the image picker controller button. The exceeded actions will be ignored. The 
 actions are matched with the styles by their tags.
 @param action An KCKeyboardImagePickerAction object.
 */
- (void)addAction:(KCKeyboardImagePickerAction *)action;

/**
 @abstract Attaches a style to the keyboard image picker view.
 @discussion There should not be more than 4 styles for option buttons and 1 for
 the image picker controller button. The exceeded actions will be ignored. The
 styles are matched with the actions by their tags.
 @param action An KCKeyboardImagePickerAction object.
 */
- (void)addStyle:(KCKeyboardImagePickerStyle *)style;

/**
 @abstract Show the keyboard image picker view.
 @param animated A flag indicating if the process should be aniamted.
 */
- (void)showKeyboardImagePickerViewAnimated:(BOOL)animated;

/**
 @abstract Hide the keyboard image picker view.
 @param animated A flag indicating if the process should be aniamted.
 */
- (void)hideKeyboardImagePickerViewAnimated:(BOOL)animated;

@end
