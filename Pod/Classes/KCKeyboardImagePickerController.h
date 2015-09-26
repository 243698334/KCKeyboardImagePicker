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

@interface KCKeyboardImagePickerAction : NSObject

+ (instancetype)actionWithImagePickerControllerButtonParentViewController:(UIViewController *)viewController handler:(void (^) (UIImage *selectedImage))handler;
+ (instancetype)actionWithOptionButtonTag:(NSInteger)tag title:(NSString *)title handler:(void (^) (UIImage *selectedImage))handler;

@end

@interface KCKeyboardImagePickerStyle : NSObject

+ (instancetype)styleWithImagePickerControllerBackgroundColor:(UIColor *)color image:(UIImage *)image;
+ (instancetype)styleWithOptionButtonTag:(NSInteger)tag titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;

@end

@interface KCKeyboardImagePickerController : NSObject

@property (nonatomic, strong) KCKeyboardImagePickerView *imagePickerView;
@property (nonatomic, assign) CGRect keyboardFrame;

- (void)addAction:(KCKeyboardImagePickerAction *)action;
- (void)addStyle:(KCKeyboardImagePickerStyle *)style;

- (void)showKeyboardImagePickerViewAnimated:(BOOL)animated;
- (void)hideKeyboardImagePickerViewAnimated:(BOOL)animated;

@end
