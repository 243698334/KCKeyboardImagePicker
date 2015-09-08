//
//  KCAppDelegate.m
//  KCKeyboardScrollingImagePicker
//
//  Created by Kev1nChen on 09/06/2015.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "AppDelegate.h"

#import "DemoSettingsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DemoSettingsViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
