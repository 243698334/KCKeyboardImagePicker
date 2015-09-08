//
//  DemoColorSettingsViewController.h
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DemoColorSettingsViewDelegate <NSObject>

@required
- (void)didFinishSetColor:(UIColor *)color forTag:(NSInteger)tag;

@end

@interface DemoColorSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id<DemoColorSettingsViewDelegate> delegate;

- (id)initWithColor:(UIColor *)color tag:(NSInteger)tag;

@end
