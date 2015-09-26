//
//  DemoMessagesViewController.h
//  KCKeyboardImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>

#import "KeyboardImagePickerOptions.h"

@interface DemoMessagesViewController : JSQMessagesViewController

@property (nonatomic, strong) KeyboardImagePickerOptions *imagePickerOptions;

@end
