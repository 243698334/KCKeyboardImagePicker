//
//  KCKeyboardScrollingImagePickerSettings.h
//  Pods
//
//  Created by Kevin Yufei Chen on 5/21/15.
//
//

#import <UIKit/UIKit.h>

extern CGFloat const kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius;
extern CGFloat const kKCKeyboardScrollingImagePickerViewCellOptionButtonBorderWidth;

@interface KCKeyboardScrollingImagePickerOptions : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) BOOL imagePickerControllerButtonIsVisible;
@property (nonatomic, assign) CGFloat imagePickerControllerButtonAlpha;
@property (nonatomic, assign) CGFloat imagePickerControllerButtonSize;
@property (nonatomic, strong) UIColor *imagePickerControllerButtonColor;
@property (nonatomic, strong) UIImage *imagePickerControllerButtonImage;

@property (nonatomic, assign) NSInteger numberOfOptionButtons;
@property (nonatomic, assign) CGFloat optionButtonsAlpha;
@property (nonatomic, strong) NSArray *optionButtonTitles;
@property (nonatomic, strong) NSArray *optionButtonColors;
@property (nonatomic, strong) NSArray *optionButtonTitleNormalColors;
@property (nonatomic, strong) NSArray *optionButtonTitleHighlightedColors;

@end
