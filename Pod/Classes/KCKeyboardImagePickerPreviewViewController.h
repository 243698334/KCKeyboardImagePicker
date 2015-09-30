//
//  KCKeyboardImagePickerPreviewViewController.h
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

@interface KCKeyboardImagePickerPreviewViewController : UIViewController

/**
 @abstract Adds a preview action to be displayed in the action sheet on a force
 touch event.
 @param previewAction A preview action to be added.
 */
- (void)addPreviewAction:(UIPreviewAction *)previewAction;

/**
 @abstract Updates the image displayed in the preview view controller.
 @param image An image to be displayed.
 */
- (void)updateImage:(UIImage *)image;

@end
