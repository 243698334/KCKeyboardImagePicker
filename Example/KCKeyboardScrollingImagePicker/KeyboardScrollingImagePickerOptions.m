//
//  KeyboardScrollingImagePickerOptions.m
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/14/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "KeyboardScrollingImagePickerOptions.h"

@implementation KeyboardScrollingImagePickerOptions

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.imagePickerControllerButtonIsVisible = YES;
        self.imagePickerControllerButtonAlpha = 0.8;
        self.imagePickerControllerButtonSize = 50;
        self.imagePickerControllerButtonColor = [UIColor lightGrayColor];
        
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
