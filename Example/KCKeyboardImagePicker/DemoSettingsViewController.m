//
//  DemoSettingsViewController.m
//  KCKeyboardImagePicker
//
//  Created by Kev1nChen on 09/05/2015.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoSettingsViewController.h"

#import <KCKeyboardImagePicker/KCKeyboardImagePickerView.h>
#import "DemoOptionButtonSettingsViewController.h"
#import "DemoImagePickerControllerButtonSettingsViewController.h"
#import "DemoMessagesViewController.h"

@interface DemoSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DemoMessagesViewController *demoMessagesViewController;
@property (nonatomic, strong) DemoImagePickerOptions *imagePickerOptions;

@end

NSInteger const kShowDemoSectionIndex = 0;
NSInteger const kImagePickerControllerButtonSectionIndex = 1;
NSInteger const kOptionButtonsSectionIndex = 2;

NSString * const kShowDemoSectionCellIdentifier = @"ShowDemoSectionCellIdentifier";
NSString * const kImagePickerControllerButtonSectionCellIdentifier = @"ImagePickerControllerButtonSectionCellIdentifier";
NSString * const kOptionButtonsSectionCellIdentifier = @"OptionButtonsSectionCellIdentifier";

NSInteger const kImagePickerControllerButtonSectionOptionButtonAlphaAlertViewTag = 0;
NSInteger const kImagePickerControllerButtonSectionImagePickerControllerButtonAlphaAlertViewTag = 1;


@implementation DemoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Demo Settings";
    
    self.imagePickerOptions = [[DemoImagePickerOptions alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)showDemo {
    self.demoMessagesViewController = [DemoMessagesViewController messagesViewController];
    self.demoMessagesViewController.imagePickerOptions = self.imagePickerOptions;
    [self.navigationController pushViewController:self.demoMessagesViewController animated:YES];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case kShowDemoSectionIndex:
            [self showDemo];
            break;
        case kImagePickerControllerButtonSectionIndex:
            [self.navigationController pushViewController:[[DemoImagePickerControllerButtonSettingsViewController alloc] initWithImagePickerOptions:self.imagePickerOptions] animated:YES];
            break;
        case kOptionButtonsSectionIndex:
            if (indexPath.row == [self.imagePickerOptions.optionButtonTitles count]) {
                NSMutableArray *titles = [self.imagePickerOptions.optionButtonTitles mutableCopy];
                [titles addObject:@"New Button"];
                self.imagePickerOptions.optionButtonTitles = [NSArray arrayWithArray:titles];
                NSMutableArray *colors = [self.imagePickerOptions.optionButtonColors mutableCopy];
                [colors addObject:[UIColor whiteColor]];
                self.imagePickerOptions.optionButtonColors = [NSArray arrayWithArray:colors];
                NSMutableArray *titleNormalColors = [self.imagePickerOptions.optionButtonTitleColors mutableCopy];
                [titleNormalColors addObject:[UIColor blackColor]];
                self.imagePickerOptions.optionButtonTitleColors = [NSArray arrayWithArray:titleNormalColors];
            }
            [self.navigationController pushViewController:[[DemoOptionButtonSettingsViewController alloc] initWithButtonIndex:indexPath.row imagePickerOptions:self.imagePickerOptions] animated:YES];
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kShowDemoSectionIndex:
            return 1;
        case kImagePickerControllerButtonSectionIndex:
            return 1;
        case kOptionButtonsSectionIndex:
            return [self.imagePickerOptions.optionButtonTitles count] == 4 ? 4 : [self.imagePickerOptions.optionButtonTitles count] + 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kShowDemoSectionIndex:
            return nil;
        case kImagePickerControllerButtonSectionIndex:
            return @"Image Picker Controller Button";
        case kOptionButtonsSectionIndex:
            return @"Option Buttons";
        default:
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case kShowDemoSectionIndex:
            return nil;
        case kImagePickerControllerButtonSectionIndex:
            return @"Image Picker Controller Button is the one floating on top of the Keyboard  Image Picker View that brings up the default UIImagePickerController.";
        case kOptionButtonsSectionIndex:
            return @"Option Buttons are the ones that become visible when the user taps on an image. There can be up to 4 option buttons.";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    switch (indexPath.section) {
        case kShowDemoSectionIndex:
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:kShowDemoSectionCellIdentifier];
            if (tableViewCell == nil) {
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShowDemoSectionCellIdentifier];
                tableViewCell.textLabel.text = @"Show Demo";
                tableViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
                tableViewCell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case kImagePickerControllerButtonSectionIndex:
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:kImagePickerControllerButtonSectionCellIdentifier];
            if (tableViewCell == nil) {
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kImagePickerControllerButtonSectionCellIdentifier];
                tableViewCell.textLabel.text = @"Button";
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case kOptionButtonsSectionIndex:
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:kOptionButtonsSectionCellIdentifier];
            if (tableViewCell == nil) {
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kOptionButtonsSectionCellIdentifier];
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row < [self.imagePickerOptions.optionButtonTitles count]) {
                tableViewCell.textLabel.text = [NSString stringWithFormat:@"Button %ld", indexPath.row + 1];
                tableViewCell.detailTextLabel.text = self.imagePickerOptions.optionButtonTitles[indexPath.row];
            } else {
                tableViewCell.textLabel.text = @"New Button...";
            }
            break;
    }
    return tableViewCell;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    NSInteger alphaPercentage = [[alertView textFieldAtIndex:0].text integerValue];
    if (alphaPercentage < 0 || alphaPercentage > 100) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"The integer shoudl be from 0 to 100" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        return;
    }
    switch (alertView.tag) {
        case kImagePickerControllerButtonSectionOptionButtonAlphaAlertViewTag:
            self.imagePickerOptions.optionButtonsAlpha = alphaPercentage / 100.0;
            break;
        case kImagePickerControllerButtonSectionImagePickerControllerButtonAlphaAlertViewTag:
            self.imagePickerOptions.imagePickerControllerButtonAlpha = alphaPercentage / 100.0;
            break;
    }
    [self.tableView reloadData];
}

@end
