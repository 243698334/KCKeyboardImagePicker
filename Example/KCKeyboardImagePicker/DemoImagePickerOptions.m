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
        
        self.isForceTouchEnabled = YES;
        self.isImagePickerControllerButtonVisible = YES;
        self.imagePickerControllerButtonAlpha = 0.8;
        self.imagePickerControllerButtonSize = 50;
        self.imagePickerControllerButtonColor = [UIColor lightGrayColor];
        
        self.numberOfOptionButtons = 1;
        self.optionButtonsAlpha = 0.8;
        self.optionButtonTitles = [[NSMutableArray alloc] initWithObjects:@"Send", nil];
        self.optionButtonColors = [[NSMutableArray alloc] initWithObjects:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2], nil];
        self.optionButtonTitleColors = [[NSMutableArray alloc] initWithObjects:[UIColor whiteColor], nil];
        self.forceTouchEnabledFlags = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:YES], nil];
    }
    return self;
}

@end
