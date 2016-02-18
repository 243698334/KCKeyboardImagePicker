//
//  KCKeyboardImagePickerView.h
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

@class KCKeyboardImagePickerView;

/**
 @abstract The methods of this protocol allow the delegate to manage selections, 
 deselections, tap events of option buttons and image picker controller button, and 
 to be notified of the need to load more images.
 */
@protocol KCKeyboardImagePickerViewDelegate <NSObject>

@optional
/**
 @abstract Tells the delegate that an option button was tapped. 
 @discussion Implement this method and perform different tasks based on the indices
 of the option buttons.
 @param keyboardImagePickerView A KeyboardImagePickerView object 
 informing the delegate about the tap event.
 @param optionButton A reference to the button that was tapped.
 @param index The index of the tapped option button in all option buttons
 */
- (void)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView didTapOptionButton:(UIButton *)optionButton atIndex:(NSInteger)index;

@optional
/**
 @abstract Tells the delegate that an image was selected.
 @discussion During this process, a blur visual effect view will be added to the 
 `contentView` of the collection view cell.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 informing the delegate about the selection.
 @param index The index of the selected image.
 */
- (void)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView didSelectItemAtIndex:(NSInteger)index;

@optional
/**
 @abstract Tells the delegate that an image was deselected.
 @discussion During this process, the blur visual effect view will be removed from
 the `contentView` of the collection view cell.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 informing the delegate about the deselection.
 @param index The index of the deselected image.
 */
- (void)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView didDeselectItemAtIndex:(NSInteger)index;


@optional
/**
 @abstract Tells the delegate that the picker view will show an image at an index.
 @discussion This method should be implemented if the controller who owns the image
 picker view is optimized for asynchronous image loading. The `updateImage:AtIndex:`
 method is expected to be called after the image is ready. Until then, there will be
 a placeholder image displayed at that cell.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 informing the delegate of such information.
 @param index The index of the image will be shown.
 */
- (void)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView willDisplayImageAtIndex:(NSInteger)index;


@optional
/**
 @abstract Tells the delegate that the image picker controller button was tapped.
 @discussion It is recommanded to bring up the `UIImagePickerController` inside of
 this method.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 informing the delegate about the tap event.
 */
- (void)didTapImagePickerControllerButtonInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView;

@end

/**
 @abstract The methods of this protocol allow the data source to provide visibility
 of the image picker controller button, image for the image picker controller button,
 number of option buttons, titles for option buttons, title colors for option buttons
 under different control states, background colors for option buttons under different
 control states, and the images to be selected.
 */
@protocol KCKeyboardImagePickerViewDataSource <NSObject>

@required
/**
 @abstract Asks the data source for the number of images to be shown in the keyboard
 image picker view.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @return The number of images in the keyboard image picker view.
 */
- (NSInteger)numberOfImagesInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView;

@required
/**
 @abstract Asks the data source for an image to display in a particular location in
 the keyboard image picker view.
 @discussion Since this method is called along with the data source methods for the 
 image collection view, it is suggested to return a placeholder or an immediately 
 available thumbnail instead of the actual full-sized image in order to avoid UI lag.
 You can asynchronously load images with better resolution and use the 
 `updateImage:atIndex:animated:` method to replace the placeholder or the thumbnail.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting an image which should be immediately available.
 @param index An index locating the image.
 @return A image object to be displayed in the keyboard image picker view.
 */
- (UIImage *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView imageAtIndex:(NSInteger)index;

@required
/**
 @abstract Asks the data source for the visibility of the image picker controller 
 button.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @return A boolean value indicating the visibility.
 */
- (BOOL)isImagePickerControllerButtonVisibleInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView;

@optional
/**
 @abstract Asks the data source for the background color of the image picker 
 controller button.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @return An color to be used as the background color of the button.
 */
- (UIColor *)backgroundColorForImagePickerControllerButtonInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView;

@optional
/**
 @abstract Asks the data source for the background image of the image picker
 controller button.
 @discussion Will use the default image if this method is not implemented.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @return An image to be used as the background of the button.
 */
- (UIImage *)backgroundImageForImagePickerControllerButtonInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView;

@required
/**
 @abstract Asks the data source for the number of options buttons to be shown on each
 image when selected.
 @discussion Different number of option buttons leads to differnt layout styles for
 the option buttons. For the one button layout, the only option button will be in the
 center of the image. For the two buttons layout, the options buttons will be in a
 single row centered vertically. For the three buttons layout, there will be two rows
 for the options buttons - the higher row contains one button and the lower row has
 two buttons. For the four buttons layout, there will be two rows and two columns with
 two buttons in each.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @return The number of option buttons in the keyboard  image picker view.
 */
- (NSInteger)numberOfOptionButtonsInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView;

@required
/**
 @abstract Asks the data source for the titles for each option button.
 @discussion Please do not use really long words as it may not get rended perfectly in
 the circular option button.
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @param index An index locating the option button.
 @return A title to be displayed in the option button.
 */
- (NSString *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView titleForOptionButtonAtIndex:(NSInteger)index;

@optional
/**
 @abstract Asks the data source for the background colors of the option buttons under
 different control states.
 @discussion Only needs to assign color for `UIControlStateHighlighted` and
 `UIControlStateNormal`
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @param index An index locating the option button.
 @param state A control state for the button.
 @return A color to be displayed in the option button for a certain control state.
 */
- (UIColor *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView backgroundColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state;

@optional
/**
 @abstract Asks the data source for the title colors of the option buttons under
 different control states.
 @discussion Only needs to assign color for `UIControlStateHighlighted` and
 `UIControlStateNormal`
 @param keyboardImagePickerView A KeyboardImagePickerView object
 requesting this information.
 @param index An index locating the option button.
 @param state A control state for the button.
 @return A color to be displayed on the title of a option button for a certain control
 state.
 */
- (UIColor *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView titleColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state;

@end

/**
 @abstract Inspired by the in-chat horizontal keyboard  image picker in the
 Facebook Messenger app. A user can quickly browse and select an image and perform some
 tasks without bringing up a full screen camera roll picker.
 */
@interface KCKeyboardImagePickerView : UIView

/**
 @abstract The object that acts as the delegate of the picker.
 */
@property (nonatomic, weak) id<KCKeyboardImagePickerViewDelegate> delegate;

/**
 @abstract The object that acts as the data source of the picker.
 */
@property (nonatomic, weak) id<KCKeyboardImagePickerViewDataSource> dataSource;

/**
 @abstract Updates the image at an index of the collection view with or without animation.
 @discussion This method is expected to be called when the controller who owns the image
 picker view is optimized for asynchronous image loading. 
 @param image An image to be set.
 @param index An index locating the collection view cell.
 @param animated A flag indicating if this update should be animated.
 */
- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index animated:(BOOL)animated;

/**
 @abstract Calculate the index of the image which includes a given point on the screen.
 @discussion This method is used by the force touch feature.
 @param point The location of the touch event.
 @return index An index locating the image displayed.
 */
- (NSInteger)imageIndexAtPoint:(CGPoint)point;

/**
 @abstract adjust cells frame after image picker frame changes
 */
- (void)reloadSubviews;

@end
