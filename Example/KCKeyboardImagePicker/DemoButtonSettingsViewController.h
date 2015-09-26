//
//  DemoButtonSettingsViewController.h
//  KCKeyboardImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <KCKeyboardImagePicker/KCKeyboardImagePickerView.h>
#import "DemoColorSettingsViewController.h"
#import "KeyboardImagePickerOptions.h"

@interface DemoButtonSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, DemoColorSettingsViewDelegate>

- (id)initWithButtonIndex:(NSInteger)buttonIndex imagePickerOptions:(KeyboardImagePickerOptions *)imagePickerOptions;

@end
