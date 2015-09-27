//
//  DemoButtonSettingsViewController.m
//  KCKeyboardImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoImagePickerControllerButtonSettingsViewController.h"

@interface DemoImagePickerControllerButtonSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *visibleSwitch;

@property (nonatomic, strong) DemoImagePickerOptions *imagePickerOptions;

@end

NSInteger const kButtonAppearenceSectionIndex = 0;
NSInteger const kButtonVisibleSectionIndex = 1;

NSInteger const kButtonAppearenceSectionColorIndex = 0;
NSInteger const kButtonAppearenceSectionImageIndex = 1;

@implementation DemoImagePickerControllerButtonSettingsViewController

- (id)initWithImagePickerOptions:(DemoImagePickerOptions *)imagePickerOptions {
    if (self = [super init]) {
        self.imagePickerOptions = imagePickerOptions;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Image Picker Controller Button";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.visibleSwitch = [[UISwitch alloc] init];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kButtonAppearenceSectionIndex:
            return 2;
        case kButtonVisibleSectionIndex:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kButtonAppearenceSectionIndex:
            return @"Appearence";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    switch (indexPath.section) {
        case kButtonAppearenceSectionIndex:
            tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ButtonColorsSectionCellIdentifier"];
            if (tableViewCell == nil) {
                tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ButtonColorsSectionCellIdentifier"];
                tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            CGFloat redValue = 0.0, greenValue = 0.0, blueValue = 0.0, alphaValue = 0.0;
            switch (indexPath.row) {
                case kButtonAppearenceSectionColorIndex:
                    [self.imagePickerOptions.imagePickerControllerButtonColor getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
                    tableViewCell.textLabel.text = @"Color";
                    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"R:%ld G:%ld B:%ld A:%ld", (NSInteger)(redValue * 255), (NSInteger)(greenValue * 255), (NSInteger)(blueValue * 255), (NSInteger)(alphaValue * 100)];
                    break;
                case kButtonAppearenceSectionImageIndex:
                    tableViewCell.textLabel.text = @"Image";
                    tableViewCell.detailTextLabel.text = @"Can't change it here yet";
                    break;
            }
            
            break;
        case kButtonVisibleSectionIndex:
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ButtonTitleSectionCellIdentifier"];
            tableViewCell.textLabel.text = @"Visible";
            tableViewCell.accessoryView = self.visibleSwitch;
            self.visibleSwitch.on = self.imagePickerOptions.isImagePickerControllerButtonVisible;
            [self.visibleSwitch addTarget:self action:@selector(didToggleVisibleSwitch:) forControlEvents:UIControlEventValueChanged];
            break;
    }
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoColorSettingsViewController *demoColorSettingsViewController = nil;
    if (indexPath.section == kButtonAppearenceSectionIndex) {
        switch (indexPath.row) {
            case kButtonAppearenceSectionColorIndex:
                demoColorSettingsViewController = [[DemoColorSettingsViewController alloc] initWithColor:self.imagePickerOptions.imagePickerControllerButtonColor tag:0];
                demoColorSettingsViewController.delegate = self;
                [self.navigationController pushViewController:demoColorSettingsViewController animated:YES];
                break;
            case kButtonAppearenceSectionImageIndex:
                // nothing yet...
                break;
        }
    }
}

- (void)didToggleVisibleSwitch:(UISwitch *)visibleSwitch {
    self.imagePickerOptions.isImagePickerControllerButtonVisible = visibleSwitch.on;
}

#pragma mark - DemoColorSettingsViewDelegate

- (void)didFinishSetColor:(UIColor *)color forTag:(NSInteger)tag {
    self.imagePickerOptions.imagePickerControllerButtonColor = color;
    [self.tableView reloadData];
}

@end
