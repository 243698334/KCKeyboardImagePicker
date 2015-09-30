//
//  KCKeyboardImagePickerPreviewViewController.m
//  https://github.com/Kev1nChen/KCKeyboardImagePicker
//
//  Copyright (c) 2015 Kevin Yufei Chen
//  Special thanks to Chengkan Huang
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "KCKeyboardImagePickerPreviewViewController.h"

@interface KCKeyboardImagePickerPreviewViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *previewActions;

@end

@implementation KCKeyboardImagePickerPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.alpha = 0.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView.frame = self.view.bounds;
    self.view.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.5];
    self.view.alpha = 0.7;
}

- (void)addPreviewAction:(UIPreviewAction *)previewAction {
    if (self.previewActions == nil) {
        self.previewActions = [[NSMutableArray alloc] init];
    }
    [self.previewActions addObject:previewAction];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    return self.previewActions;
}

- (void)updateImage:(UIImage *)image {
    self.imageView.image = image;
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.alpha = 1.0;
    }];
}

@end
