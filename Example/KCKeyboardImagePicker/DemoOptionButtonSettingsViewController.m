//
//  DemoOptionButtonSettingsViewController.m
//  KCKeyboardImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoOptionButtonSettingsViewController.h"

@interface DemoOptionButtonSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *forceTouchSwitch;

@property (nonatomic) NSInteger buttonIndex;
@property (nonatomic, strong) DemoImagePickerOptions *imagePickerOptions;

@end

NSInteger const kButtonColorsSectionIndex = 0;
NSInteger const kButtonTitleSectionIndex = 1;
NSInteger const kButton3DTouchSectionIndex = 2;
NSInteger const kButtonDeleteSectionIndex = 3;

NSInteger const kButtonColorsSectionColorIndex = 0;
NSInteger const kButtonColorsSectionTitleColorIndex = 1;

NSInteger const kButtonColorsSectionColorTag = 0;
NSInteger const kButtonColorsSectionTitleColorTag = 1;

NSInteger const kButtonColorsSectionTitleAlertViewTag = 0;

@implementation DemoOptionButtonSettingsViewController

- (id)initWithButtonIndex:(NSInteger)buttonIndex imagePickerOptions:(DemoImagePickerOptions *)imagePickerOptions {
    if (self = [super init]) {
        self.buttonIndex = buttonIndex;
        self.imagePickerOptions = imagePickerOptions;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Button", self.imagePickerOptions.optionButtonTitles[self.buttonIndex]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)deleteCurrentButton {    
    [self.imagePickerOptions.optionButtonTitles removeObjectAtIndex:self.buttonIndex];
    [self.imagePickerOptions.optionButtonColors removeObjectAtIndex:self.buttonIndex];
    [self.imagePickerOptions.optionButtonTitleColors removeObjectAtIndex:self.buttonIndex];
    [self.imagePickerOptions.forceTouchEnabledFlags removeObjectAtIndex:self.buttonIndex];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kButtonColorsSectionIndex:
            return 2;
        case kButtonTitleSectionIndex:
            return 1;
        case kButton3DTouchSectionIndex:
            return 1;
        case kButtonDeleteSectionIndex:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kButtonColorsSectionIndex:
            return @"Colors";
        case kButtonTitleSectionIndex:
            return @"Title";
        case kButton3DTouchSectionIndex:
            return @"3D Touch";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    switch (indexPath.section) {
        case kButtonColorsSectionIndex:
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ButtonColorsSectionCellIdentifier"];
            if (tableViewCell == nil) {
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ButtonColorsSectionCellIdentifier"];
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            CGFloat redValue = 0.0, greenValue = 0.0, blueValue = 0.0, alphaValue = 0.0;
            switch (indexPath.row) {
                case kButtonColorsSectionColorIndex:
                    [self.imagePickerOptions.optionButtonColors[self.buttonIndex] getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
                    tableViewCell.textLabel.text = @"Background";
                    break;
                case kButtonColorsSectionTitleColorIndex:
                    [self.imagePickerOptions.optionButtonTitleColors[self.buttonIndex] getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
                    tableViewCell.textLabel.text = @"Title";
                    break;
            }
            tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"R:%ld G:%ld B:%ld A:%ld", (NSInteger)(redValue * 255), (NSInteger)(greenValue * 255), (NSInteger)(blueValue * 255), (NSInteger)(alphaValue * 100)];
            break;
        case kButtonTitleSectionIndex:
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ButtonTitleSectionCellIdentifier"];
            tableViewCell.textLabel.text = @"Title Text";
            tableViewCell.detailTextLabel.text = self.imagePickerOptions.optionButtonTitles[self.buttonIndex];
            tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case kButton3DTouchSectionIndex:
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Button3DTouchSectionCellIdentifier"];
            self.forceTouchSwitch = [[UISwitch alloc] init];
            self.forceTouchSwitch.on = [self.imagePickerOptions.forceTouchEnabledFlags[self.buttonIndex] boolValue];
            tableViewCell.textLabel.text = @"Add to 3D Touch Action Sheet";
            tableViewCell.accessoryView = self.forceTouchSwitch;
            [self.forceTouchSwitch addTarget:self action:@selector(didToggleForceTouchSwitch:) forControlEvents:UIControlEventValueChanged];
            break;
        case kButtonDeleteSectionIndex:
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonDeleteSectionCellIdentifier"];
            tableViewCell.textLabel.text = @"Delete";
            tableViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
            tableViewCell.textLabel.textColor = [UIColor redColor];
    }
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoColorSettingsViewController *demoColorSettingsViewController = nil;
    UIAlertView *alertView = nil;
    switch (indexPath.section) {
        case kButtonColorsSectionIndex:
            switch (indexPath.row) {
                case kButtonColorsSectionColorIndex:
                    demoColorSettingsViewController = [[DemoColorSettingsViewController alloc] initWithColor:self.imagePickerOptions.optionButtonColors[self.buttonIndex] tag:kButtonColorsSectionColorTag];
                    break;
                case kButtonColorsSectionTitleColorIndex:
                    demoColorSettingsViewController = [[DemoColorSettingsViewController alloc] initWithColor:self.imagePickerOptions.optionButtonTitleColors[self.buttonIndex] tag:kButtonColorsSectionTitleColorTag];
                    break;
            }
            demoColorSettingsViewController.delegate = self;
            [self.navigationController pushViewController:demoColorSettingsViewController animated:YES];
            break;
        case kButtonTitleSectionIndex:
            alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"The text on the button." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alertView.tag = kButtonColorsSectionTitleAlertViewTag;
            break;
        case kButtonDeleteSectionIndex:
            [self deleteCurrentButton];
            [self.navigationController popViewControllerAnimated:YES];
            return;
    }
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alertView textFieldAtIndex:0] becomeFirstResponder];
    [alertView show];

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    if (alertView.tag == kButtonColorsSectionTitleAlertViewTag) {
        [self.imagePickerOptions.optionButtonTitles replaceObjectAtIndex:self.buttonIndex withObject:[alertView textFieldAtIndex:0].text];
        [self.tableView reloadData];
    }
}

#pragma mark - DemoColorSettingsViewDelegate

- (void)didFinishSetColor:(UIColor *)color forTag:(NSInteger)tag {
    switch (tag) {
        case kButtonColorsSectionColorTag:
            [self.imagePickerOptions.optionButtonColors replaceObjectAtIndex:self.buttonIndex withObject:color];
            break;
        case kButtonColorsSectionTitleColorTag:
            [self.imagePickerOptions.optionButtonTitleColors replaceObjectAtIndex:self.buttonIndex withObject:color];
            break;
    }
    [self.tableView reloadData];
}

- (void)didToggleForceTouchSwitch:(UISwitch *)forceTouchSwitch {
    [self.imagePickerOptions.forceTouchEnabledFlags setObject:[NSNumber numberWithBool:forceTouchSwitch.on] atIndexedSubscript:self.buttonIndex];
}

@end
