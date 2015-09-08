//
//  DemoColorSettingsViewController.m
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoColorSettingsViewController.h"

@interface DemoColorSettingsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) NSInteger tag;

@end

@implementation DemoColorSettingsViewController

- (id)initWithColor:(UIColor *)color tag:(NSInteger)tag {
    if (self = [super init]) {
        self.color = color;
        self.tag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Color";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFinishSetColor:forTag:)]) {
        [self.delegate didFinishSetColor:self.color forTag:self.tag];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ColorSettingsCellIdentifier"];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ColorSettingsCellIdentifier"];
        tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    CGFloat redValue, greenValue, blueValue, alphaValue;
    [self.color getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
    switch (indexPath.row) {
        case 0:
            tableViewCell.textLabel.text = @"Red";
            tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(redValue * 255)];
            break;
        case 1:
            tableViewCell.textLabel.text = @"Green";
            tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(greenValue * 255)];
            break;
        case 2:
            tableViewCell.textLabel.text = @"Blue";
            tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(blueValue * 255)];
            break;
    }
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *colorName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:colorName message:@"Enter an integer from 0 to 255." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].placeholder = [NSString stringWithFormat:@"Current value: %@", [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text];
    [[alertView textFieldAtIndex:0] becomeFirstResponder];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    NSInteger currentColorComponentValue = [[alertView textFieldAtIndex:0].text integerValue];
    if (currentColorComponentValue < 0 || currentColorComponentValue > 255) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"The integer should be from 0 to 255." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    } else {
        CGFloat redValue, greenValue, blueValue, alphaValue;
        [self.color getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
        self.color = [[UIColor alloc] initWithRed:[alertView.title isEqualToString:@"Red"] ? currentColorComponentValue / 255.0 : redValue
                                            green:[alertView.title isEqualToString:@"Green"] ? currentColorComponentValue / 255.0 : greenValue
                                             blue:[alertView.title isEqualToString:@"Blue"] ? currentColorComponentValue / 255.0 : blueValue
                                            alpha:alphaValue];
        [self.tableView reloadData];
    }
}

@end
