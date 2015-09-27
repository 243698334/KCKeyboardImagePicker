//
//  DemoImagePickerOptions.m
//  KCKeyboardImagePicker
//
//  Created by Kevin Yufei Chen on 9/14/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoImagePickerOptions.h"

@implementation DemoImagePickerOptions

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.isImagePickerControllerButtonVisible = YES;
        self.imagePickerControllerButtonAlpha = 0.8;
        self.imagePickerControllerButtonSize = 50;
        self.imagePickerControllerButtonColor = [UIColor lightGrayColor];
        
        self.numberOfOptionButtons = 1;
        self.optionButtonsAlpha = 0.8;
        self.optionButtonTitles = @[@"Send"];
        self.optionButtonColors = @[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        self.optionButtonTitleColors = @[[UIColor whiteColor]];
    }
    return self;
}

@end
