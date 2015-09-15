//
//  DemoButtonSettingsViewController.h
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <KCKeyboardScrollingImagePicker/KCKeyboardScrollingImagePickerView.h>
#import "DemoColorSettingsViewController.h"
#import "KeyboardScrollingImagePickerOptions.h"

@interface DemoButtonSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, DemoColorSettingsViewDelegate>

- (id)initWithButtonIndex:(NSInteger)buttonIndex imagePickerOptions:(KeyboardScrollingImagePickerOptions *)imagePickerOptions;

@end
