//
//  KCKeyboardScrollingImagePickerSettings.m
//  Pods
//
//  Created by Kevin Yufei Chen on 5/21/15.
//
//

#import "KCKeyboardScrollingImagePickerOptions.h"

CGFloat const kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius = 60.0;
CGFloat const kKCKeyboardScrollingImagePickerViewCellOptionButtonBorderWidth = 2.0;


@implementation KCKeyboardScrollingImagePickerOptions

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.imagePickerControllerButtonIsVisible = YES;
        self.imagePickerControllerButtonAlpha = 0.8;
        self.imagePickerControllerButtonSize = 50;
        self.imagePickerControllerButtonColor = [UIColor lightGrayColor];
        self.imagePickerControllerButtonImage = [UIImage imageNamed:@"ImagePickerControllerButtonIcon"];
        
        self.numberOfOptionButtons = 1;
        self.optionButtonsAlpha = 0.8;
        self.optionButtonTitles = @[@"Send"];
        self.optionButtonColors = @[[UIColor whiteColor]];
        self.optionButtonTitleNormalColors = @[[UIColor blackColor]];
        self.optionButtonTitleHighlightedColors = @[[UIColor lightGrayColor]];
    }
    return self;
}

@end
