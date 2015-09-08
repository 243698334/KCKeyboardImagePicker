//
//  KCViewController.m
//  KCKeyboardScrollingImagePicker
//
//  Created by Kev1nChen on 09/05/2015.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoSettingsViewController.h"

#import <KCKeyboardScrollingImagePicker/KCKeyboardScrollingImagePickerView.h>
#import "DemoButtonSettingsViewController.h"
#import "DemoMessagesViewController.h"

@interface DemoSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DemoMessagesViewController *demoMessagesViewController;
@property (nonatomic, strong) KCKeyboardScrollingImagePickerOptions *imagePickerOptions;

@end

NSInteger const kShowDemoSectionIndex = 0;
NSInteger const kAppearenceSectionIndex = 1;
NSInteger const kOptionButtonsSectionIndex = 2;

NSInteger const kAppearenceSectionOptionButtonAlphaIndex = 0;
NSInteger const kAppearenceSectionImagePickerControllerButtonAlphaIndex = 1;
NSInteger const kAppearenceSectionImagePickerControllerButtonColorIndex = 2;

NSString * const kShowDemoSectionCellIdentifier = @"ShowDemoSectionCellIdentifier";
NSString * const kAppearenceSectionCellIdentifier = @"AppearenceSectionCellIdentifier";
NSString * const kOptionButtonsSectionCellIdentifier = @"OptionButtonsSectionCellIdentifier";

NSInteger const kAppearenceSectionOptionButtonAlphaAlertViewTag = 0;
NSInteger const kAppearenceSectionImagePickerControllerButtonAlphaAlertViewTag = 1;


@implementation DemoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Demo Settings";
    
    self.imagePickerOptions = [[KCKeyboardScrollingImagePickerOptions alloc] init];
    
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
    UIAlertView *alertView = nil;
    DemoButtonSettingsViewController *demoButtonSettingsViewController = nil;
    switch (indexPath.section) {
        case kShowDemoSectionIndex:
            [self showDemo];
            break;
        case kAppearenceSectionIndex:
            switch (indexPath.row) {
                case kAppearenceSectionOptionButtonAlphaIndex:
                    alertView = [[UIAlertView alloc] initWithTitle:@"Option Buttons Alpha" message:@"The alpha percentage for all option buttons." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                    alertView.tag = kAppearenceSectionOptionButtonAlphaAlertViewTag;
                    break;
                case kAppearenceSectionImagePickerControllerButtonAlphaIndex:
                    alertView = [[UIAlertView alloc] initWithTitle:@"Image Picker Controller Button Alpha" message:@"The alpha percentage for the Image Picker Controller Button." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                    alertView.tag = kAppearenceSectionImagePickerControllerButtonAlphaAlertViewTag;
                    break;
                default:
                    break;
            }
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] becomeFirstResponder];
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
            [alertView show];
            break;
        case kOptionButtonsSectionIndex:
            if (indexPath.row == [self.imagePickerOptions.optionButtonTitles count]) {
                NSMutableArray *titles = [self.imagePickerOptions.optionButtonTitles mutableCopy];
                [titles addObject:@"New Button"];
                self.imagePickerOptions.optionButtonTitles = [NSArray arrayWithArray:titles];
                NSMutableArray *colors = [self.imagePickerOptions.optionButtonColors mutableCopy];
                [colors addObject:[UIColor whiteColor]];
                self.imagePickerOptions.optionButtonColors = [NSArray arrayWithArray:colors];
                NSMutableArray *titleNormalColors = [self.imagePickerOptions.optionButtonTitleNormalColors mutableCopy];
                [titleNormalColors addObject:[UIColor blackColor]];
                self.imagePickerOptions.optionButtonTitleNormalColors = [NSArray arrayWithArray:titleNormalColors];
                NSMutableArray *titleHighlightedColors = [self.imagePickerOptions.optionButtonTitleHighlightedColors mutableCopy];
                [titleHighlightedColors addObject:[UIColor lightGrayColor]];
                self.imagePickerOptions.optionButtonTitleHighlightedColors = [NSArray arrayWithArray:titleHighlightedColors];
            }
            demoButtonSettingsViewController = [[DemoButtonSettingsViewController alloc] initWithButtonIndex:indexPath.row imagePickerOptions:self.imagePickerOptions];
            [self.navigationController pushViewController:demoButtonSettingsViewController animated:YES];
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
        case kAppearenceSectionIndex:
            return 2;
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
        case kAppearenceSectionIndex:
            return @"General Appearence";
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
        case kAppearenceSectionIndex:
            return @"Image Picker Controller Button is the one floating on top of the Keyboard Scrolling Image Picker View that brings up the default UIImagePickerController.";
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
        case kAppearenceSectionIndex:
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:kAppearenceSectionCellIdentifier];
            if (tableViewCell == nil) {
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kAppearenceSectionCellIdentifier];
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            switch (indexPath.row) {
                case kAppearenceSectionOptionButtonAlphaIndex:
                    tableViewCell.textLabel.text = @"Option Buttons Alpha";
                    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (NSInteger)(self.imagePickerOptions.optionButtonsAlpha * 100)];
                    break;
                case kAppearenceSectionImagePickerControllerButtonAlphaIndex:
                    tableViewCell.textLabel.text = @"ImagePickerController Button Alpha";
                    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (NSInteger)(self.imagePickerOptions.imagePickerControllerButtonAlpha * 100)];
                    break;
                default:
                    break;
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
        case kAppearenceSectionOptionButtonAlphaAlertViewTag:
            self.imagePickerOptions.optionButtonsAlpha = alphaPercentage / 100.0;
            break;
        case kAppearenceSectionImagePickerControllerButtonAlphaAlertViewTag:
            self.imagePickerOptions.imagePickerControllerButtonAlpha = alphaPercentage / 100.0;
            break;
    }
    [self.tableView reloadData];
}

@end
