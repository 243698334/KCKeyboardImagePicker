//
//  DemoMessagesViewController.h
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>
#import <KCKeyboardScrollingImagePicker/KCKeyboardScrollingImagePickerView.h>

@interface DemoMessagesViewController : JSQMessagesViewController<KCKeyboardScrollingImagePickerViewDataSource, KCKeyboardScrollingImagePickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) KCKeyboardScrollingImagePickerOptions *imagePickerOptions;

@end
