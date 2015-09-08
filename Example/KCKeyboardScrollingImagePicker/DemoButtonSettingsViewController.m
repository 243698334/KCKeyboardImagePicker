//
//  DemoButtonSettingsViewController.m
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoButtonSettingsViewController.h"

@interface DemoButtonSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) NSInteger buttonIndex;
@property (nonatomic, strong) KCKeyboardScrollingImagePickerOptions *imagePickerOptions;

@end

NSInteger const kButtonColorsSectionIndex = 0;
NSInteger const kButtonTitleSectionIndex = 1;
NSInteger const kButtonDeleteSectionIndex = 2;

NSInteger const kButtonColorsSectionColorIndex = 0;
NSInteger const kButtonColorsSectionTitleNormalColorIndex = 1;
NSInteger const kButtonColorsSectionTitleHighlightedColorIndex = 2;

NSInteger const kButtonColorsSectionColorTag = 0;
NSInteger const kButtonColorsSectionTitleNormalColorTag = 1;
NSInteger const kButtonColorsSectionTitleHighlightedColorTag = 2;

NSInteger const kButtonColorsSectionTitleAlertViewTag = 0;

@implementation DemoButtonSettingsViewController

- (id)initWithButtonIndex:(NSInteger)buttonIndex imagePickerOptions:(KCKeyboardScrollingImagePickerOptions *)imagePickerOptions {
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
    NSMutableArray *titles = [self.imagePickerOptions.optionButtonTitles mutableCopy];
    [titles removeObjectAtIndex:self.buttonIndex];
    self.imagePickerOptions.optionButtonTitles = [NSArray arrayWithArray:titles];
    NSMutableArray *colors = [self.imagePickerOptions.optionButtonColors mutableCopy];
    [colors removeObjectAtIndex:self.buttonIndex];
    self.imagePickerOptions.optionButtonColors = [NSArray arrayWithArray:colors];
    NSMutableArray *titleNormalColors = [self.imagePickerOptions.optionButtonTitleNormalColors mutableCopy];
    [titleNormalColors removeObjectAtIndex:self.buttonIndex];
    self.imagePickerOptions.optionButtonTitleNormalColors = [NSArray arrayWithArray:titleNormalColors];
    NSMutableArray *titleHighlightedColors = [self.imagePickerOptions.optionButtonTitleHighlightedColors mutableCopy];
    [titleHighlightedColors removeObjectAtIndex:self.buttonIndex];
    self.imagePickerOptions.optionButtonTitleHighlightedColors = [NSArray arrayWithArray:titleHighlightedColors];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kButtonColorsSectionIndex:
            return 3;
        case kButtonTitleSectionIndex:
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
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ButtonColorsSectionCellIdentifier"];
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            CGFloat redValue = 0.0, greenValue = 0.0, blueValue = 0.0, alphaValue = 0.0;
            switch (indexPath.row) {
                case kButtonColorsSectionColorIndex:
                    [self.imagePickerOptions.optionButtonColors[self.buttonIndex] getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
                    tableViewCell.textLabel.text = @"Button";
                    break;
                case kButtonColorsSectionTitleNormalColorIndex:
                    [self.imagePickerOptions.optionButtonTitleNormalColors[self.buttonIndex] getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
                    tableViewCell.textLabel.text = @"Normal Title";
                    break;
                case kButtonColorsSectionTitleHighlightedColorIndex:
                    [self.imagePickerOptions.optionButtonTitleHighlightedColors[self.buttonIndex] getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
                    tableViewCell.textLabel.text = @"Highlighted Title";
                    break;
            }
            tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"R:%ld G:%ld B:%ld", (NSInteger)(redValue * 255), (NSInteger)(greenValue * 255), (NSInteger)(blueValue * 255)];
            break;
        case kButtonTitleSectionIndex:
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ButtonTitleSectionCellIdentifier"];
            tableViewCell.textLabel.text = @"Title Text";
            tableViewCell.detailTextLabel.text = self.imagePickerOptions.optionButtonTitles[self.buttonIndex];
            tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                case kButtonColorsSectionTitleNormalColorIndex:
                    demoColorSettingsViewController = [[DemoColorSettingsViewController alloc] initWithColor:self.imagePickerOptions.optionButtonTitleNormalColors[self.buttonIndex] tag:kButtonColorsSectionTitleNormalColorTag];
                    break;
                case kButtonColorsSectionTitleHighlightedColorIndex:
                    demoColorSettingsViewController = [[DemoColorSettingsViewController alloc] initWithColor:self.imagePickerOptions.optionButtonTitleHighlightedColors[self.buttonIndex] tag:kButtonColorsSectionTitleHighlightedColorTag];
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
        NSMutableArray *titles = [self.imagePickerOptions.optionButtonTitles mutableCopy];
        [titles replaceObjectAtIndex:self.buttonIndex withObject:[alertView textFieldAtIndex:0].text];
        self.imagePickerOptions.optionButtonTitles = [NSArray arrayWithArray:titles];
        [self.tableView reloadData];
    }
}

#pragma mark - DemoColorSettingsViewDelegate

- (void)didFinishSetColor:(UIColor *)color forTag:(NSInteger)tag {
    NSArray *originalColors = nil;
    NSMutableArray *modifiedColors = nil;
    switch (tag) {
        case kButtonColorsSectionColorTag:
            originalColors = self.imagePickerOptions.optionButtonColors;
            modifiedColors = [originalColors mutableCopy];
            [modifiedColors replaceObjectAtIndex:self.buttonIndex withObject:color];
            self.imagePickerOptions.optionButtonColors = [NSArray arrayWithArray:modifiedColors];
            break;
        case kButtonColorsSectionTitleNormalColorTag:
            originalColors = self.imagePickerOptions.optionButtonTitleNormalColors;
            modifiedColors = [originalColors mutableCopy];
            [modifiedColors replaceObjectAtIndex:self.buttonIndex withObject:color];
            self.imagePickerOptions.optionButtonTitleNormalColors = [NSArray arrayWithArray:modifiedColors];
            break;
        case kButtonColorsSectionTitleHighlightedColorTag:
            originalColors = self.imagePickerOptions.optionButtonTitleHighlightedColors;
            modifiedColors = [originalColors mutableCopy];
            [modifiedColors replaceObjectAtIndex:self.buttonIndex withObject:color];
            self.imagePickerOptions.optionButtonTitleHighlightedColors = [NSArray arrayWithArray:modifiedColors];
            break;
    }
    [self.tableView reloadData];
}

@end
