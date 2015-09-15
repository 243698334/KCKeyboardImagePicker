//
//  KCKeyboardScrollingImagePickerView.h
//  https://github.com/Kev1nChen/KCKeyboardScrollingImagePicker
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

@class KCKeyboardScrollingImagePickerView;

/**
 @abstract The methods of this protocol allow the delegate to manage selections, 
 deselections, tap events of option buttons and image picker controller button, and 
 to be notified of the need to load more images.
 */
@protocol KCKeyboardScrollingImagePickerViewDelegate <NSObject>

@optional
/**
 @abstract Tells the delegate that an option button was tapped. 
 @discussion Implement this method and perform different tasks based on the indices
 of the option buttons.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object 
 informing the delegate about the tap event.
 @param optionButton A reference to the button that was tapped.
 @param index The index of the tapped option button in all option buttons
 */
- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didTapOptionButton:(UIButton *)optionButton atIndex:(NSInteger)index;

@optional
/**
 @abstract Tells the delegate that an image was selected.
 @discussion During this process, a blur visual effect view will be added to the 
 `contentView` of the collection view cell.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 informing the delegate about the selection.
 @param index The index of the selected image.
 */
- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didSelectItemAtIndex:(NSInteger)index;

@optional
/**
 @abstract Tells the delegate that an image was deselected.
 @discussion During this process, the blur visual effect view will be removed from
 the `contentView` of the collection view cell.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 informing the delegate about the deselection.
 @param index The index of the deselected image.
 */
- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didDeselectItemAtIndex:(NSInteger)index;

@optional
/**
 @abstract Tells the delegate that the image picker controller button was tapped.
 @discussion It is recommanded to bring up the `UIImagePickerController` inside of
 this method.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 informing the delegate about the tap event.
 */
- (void)didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@optional
/**
 @abstract Tells the delegate that more images are needed.
 @discussion This method will be called when the user reaches to the end of the 
 collection view. There could be smarter ways to determine when to call this method.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 informing the delegate about the need for more images.
 */
- (void)needLoadMoreImagesForKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@end

/**
 @abstract The methods of this protocol allow the data source to provide visibility
 of the image picker controller button, image for the image picker controller button,
 number of option buttons, titles for option buttons, title colors for option buttons
 under different control states, background colors for option buttons under different
 control states, and the images to be selected.
 */
@protocol KCKeyboardScrollingImagePickerViewDataSource <NSObject>

@required
/**
 @abstract Asks the data source for the number of images to be shown in the keyboard
 scrolling image picker view.
 @discussion This number can be changed after initialization of the picker, as more
 images are loaded.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @return The number of images in the keyboard scrolling image picker view.
 */
- (NSInteger)numberOfImagesInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@required
/**
 @abstract Asks the data source for an image to display in a particular location in
 the keyboard scrolling image picker view.
 @discussion The returned image can be a resized one instead of a full-size image to
 save memory.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @param index An index locating the image.
 @return A image object to be displayed in the keyboard scrolling image picker view.
 */
- (UIImage *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView imageAtIndex:(NSInteger)index;

@required
/**
 @abstract Asks the data source for the visibility of the image picker controller 
 button.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @return A boolean value indicating the visibility.
 */
- (BOOL)isImagePickerControllerButtonVisibleInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@optional
/**
 @abstract Asks the data source for the background color of the image picker 
 controller button.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @return An color to be used as the background color of the button.
 */
- (UIColor *)backgroundColorForImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@optional
/**
 @abstract Asks the data source for the background image of the image picker
 controller button.
 @discussion Will use the default image if this method is not implemented.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @return An image to be used as the background of the button.
 */
- (UIImage *)backgroundImageForImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

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
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @return The number of option buttons in the keyboard scrolling image picker view.
 */
- (NSInteger)numberOfOptionButtonsInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@required
/**
 @abstract Asks the data source for the titles for each option button.
 @discussion Please do not use really long words as it may not get rended perfectly in
 the circular option button.
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @param index An index locating the option button.
 @return A title to be displayed in the option button.
 */
- (NSString *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView titleForOptionButtonAtIndex:(NSInteger)index;

@optional
/**
 @abstract Asks the data source for the background colors of the option buttons under
 different control states.
 @discussion Only needs to assign color for `UIControlStateHighlighted` and
 `UIControlStateNormal`
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @param index An index locating the option button.
 @state state A control state for the button.
 @return A color to be displayed in the option button for a certain control state.
 */
- (UIColor *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView backgroundColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state;

@optional
/**
 @abstract Asks the data source for the title colors of the option buttons under
 different control states.
 @discussion Only needs to assign color for `UIControlStateHighlighted` and
 `UIControlStateNormal`
 @param keyboardScrollingImagePickerView A KeyboardScrollingImagePickerView object
 requesting this information.
 @param index An index locating the option button.
 @state state A control state for the button.
 @return A color to be displayed on the title of a option button for a certain control
 state.
 */
- (UIColor *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView titleColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state;

@end

/**
 @abstract Inspired by the in-chat horizontal keyboard scrolling image picker in the
 Facebook Messenger app. A user can quickly browse and select an image and perform some
 tasks without bringing up a full screen camera roll picker.
 */
@interface KCKeyboardScrollingImagePickerView : UIView<UICollectionViewDelegateFlowLayout>

/**
 @abstract The object that acts as the delegate of the picker.
 */
@property (nonatomic, assign) id<KCKeyboardScrollingImagePickerViewDelegate> delegate;

/**
 @abstract The object that acts as the data source of the picker.
 */
@property (nonatomic, assign) id<KCKeyboardScrollingImagePickerViewDataSource> dataSource;

/**
 @abstract Renders all the components in the keyboard scrolling image picker view, 
 including the image picker controller button, the images collection view, and the
 option buttons view with a blur visual effect view and buttons inside. 
 @discussion Need to be called after loading more images on the fly.
 */
- (void)render;

@end
