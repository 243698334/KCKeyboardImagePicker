//
//  KCKeyboardImagePickerController.m
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

#import "KCKeyboardImagePickerController.h"

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "KCKeyboardImagePickerPreviewViewController.h"

@interface KCKeyboardImagePickerAction ()

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) BOOL forceTouchEnabled;
@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, assign) void (^ handler)(UIImage *selectedImage);

@end

@implementation KCKeyboardImagePickerAction

+ (instancetype)actionWithImagePickerControllerButtonParentViewController:(UIViewController *)viewController handler:(void (^) (UIImage *selectedImage))handler {
    KCKeyboardImagePickerAction *action = [[KCKeyboardImagePickerAction alloc] init];
    action.tag = -1;
    action.title = nil;
    action.parentViewController = viewController;
    action.handler = handler;
    return action;
}

+ (instancetype)actionWithOptionButtonTag:(NSInteger)tag title:(NSString *)title forceTouchEnabled:(BOOL)enabled handler:(void (^) (UIImage *selectedImage))handler {
    KCKeyboardImagePickerAction *action = [[KCKeyboardImagePickerAction alloc] init];
    action.tag = tag;
    action.title = title;
    action.forceTouchEnabled = enabled;
    action.parentViewController = nil;
    action.handler = handler;
    return action;
}

@end

@interface KCKeyboardImagePickerStyle ()

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) UIColor *titleColor;
@property (nonatomic, assign) UIColor *backgroundColor;

@end

@implementation KCKeyboardImagePickerStyle

+ (instancetype)styleWithImagePickerControllerBackgroundColor:(UIColor *)color image:(UIImage *)image {
    KCKeyboardImagePickerStyle *style = [[KCKeyboardImagePickerStyle alloc] init];
    style.tag = -1;
    style.image = image;
    style.titleColor = nil;
    style.backgroundColor = color;
    return style;
}

+ (instancetype)styleWithOptionButtonTag:(NSInteger)tag titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor {
    KCKeyboardImagePickerStyle *style = [[KCKeyboardImagePickerStyle alloc] init];
    style.tag = tag;
    style.image = nil;
    style.titleColor = titleColor;
    style.backgroundColor = backgroundColor;
    return style;
}

@end

@interface KCKeyboardImagePickerController () <KCKeyboardImagePickerViewDataSource, KCKeyboardImagePickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *handlers;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSMutableDictionary *titles;
@property (nonatomic, strong) NSMutableDictionary *forceTouchEnabledFlags;

@property (nonatomic, strong) NSMutableDictionary *titleColors;
@property (nonatomic, strong) NSMutableDictionary *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary *optionButtonIndices;
@property (nonatomic, weak) UIViewController *imagePickerParentViewController;

@property (nonatomic, strong) PHFetchResult *photoLibraryFetchResult;
@property (nonatomic, strong) UIImage *placeHolderImage;

@end

@implementation KCKeyboardImagePickerController

- (id)init {
    if (self = [super init]) {
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.photoLibraryFetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
        self.placeHolderImage = [UIImage imageNamed:@"PlaceHolderImage"];
        
        self.imagePickerView = [[KCKeyboardImagePickerView alloc] init];
        self.imagePickerView.dataSource = self;
        self.imagePickerView.delegate = self;
        
        self.titles = [[NSMutableDictionary alloc] init];
        self.forceTouchEnabledFlags = [[NSMutableDictionary alloc] init];
        self.handlers = [[NSMutableDictionary alloc] init];
        self.images = [[NSMutableDictionary alloc] init];
        self.titleColors = [[NSMutableDictionary alloc] init];
        self.backgroundColors = [[NSMutableDictionary alloc] init];
        self.optionButtonIndices = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addAction:(KCKeyboardImagePickerAction *)action {
    if (action.tag != -1) {
        [self.titles setObject:action.title forKey:[NSNumber numberWithInteger:action.tag]];
        [self.forceTouchEnabledFlags setObject:[NSNumber numberWithBool:action.forceTouchEnabled] forKeyedSubscript:[NSNumber numberWithInteger:action.tag]];
        [self.optionButtonIndices setObject:[NSNumber numberWithInteger:action.tag] forKey:[NSNumber numberWithInteger:[self.optionButtonIndices count]]];
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:self.imagePickerView];
        }
    } else {
        self.imagePickerParentViewController = action.parentViewController;
    }
    [self.handlers setObject:action.handler forKey:[NSNumber numberWithInteger:action.tag]];
}

- (void)addStyle:(KCKeyboardImagePickerStyle *)style {
    if (style.tag != -1) {
        [self.titleColors setObject:style.titleColor forKey:[NSNumber numberWithInteger:style.tag]];
    } else {
        [self.images setObject:style.image forKey:[NSNumber numberWithInteger:style.tag]];
    }
    [self.backgroundColors setObject:style.backgroundColor forKey:[NSNumber numberWithInteger:style.tag]];
}

- (void)showKeyboardImagePickerViewAnimated:(BOOL)animated {
    CGRect imagePickerViewInitialFrame = CGRectMake(self.imagePickerView.frame.origin.x, self.imagePickerView.frame.origin.y + self.imagePickerView.frame.size.height, self.imagePickerView.frame.size.width, 0);
    self.imagePickerView.hidden = NO;
    self.imagePickerView.frame = imagePickerViewInitialFrame;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.imagePickerView.frame = self.keyboardFrame;
        }];
    } else {
        self.imagePickerView.frame = self.keyboardFrame;
    }
    [self setupForceTouch];
}

- (void)hideKeyboardImagePickerViewAnimated:(BOOL)animated {
    CGRect imagePickerViewFrame = self.imagePickerView.frame;
    imagePickerViewFrame.origin.y = imagePickerViewFrame.origin.y + imagePickerViewFrame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.imagePickerView.frame = imagePickerViewFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.imagePickerView.hidden = YES;
            }
        }];
    } else {
        self.imagePickerView.frame = imagePickerViewFrame;
        self.imagePickerView.hidden = YES;
    }
}

- (void)imageForPreviewAtIndex:(NSInteger)index handler:(void (^) (UIImage *image))handler {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeNone;
    PHAsset *currentAsset = [self.photoLibraryFetchResult objectAtIndex:index];
    [[PHImageManager defaultManager] requestImageForAsset:currentAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([[info objectForKey:PHImageResultIsDegradedKey] isEqual:[NSNumber numberWithInt:0]]) {
            handler(result);
        }
    }];
}

- (void)setupForceTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.imagePickerView];
    }
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSInteger previewingImageIndex = [self.imagePickerView imageIndexAtPoint:location];
    
    KCKeyboardImagePickerPreviewViewController *previewViewController = [[KCKeyboardImagePickerPreviewViewController alloc] init];
    for (NSNumber *currentActionIndex in [self.optionButtonIndices allKeys]) {
        NSNumber *currentActionTag = [self.optionButtonIndices objectForKey:currentActionIndex];
        if ([[self.forceTouchEnabledFlags objectForKey:currentActionIndex] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            UIPreviewAction *currentPreviewAction = [UIPreviewAction actionWithTitle:[self.titles objectForKey:currentActionTag] style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                [self imageForPreviewAtIndex:previewingImageIndex handler:^(UIImage *image) {
                    void (^ handler)(UIImage *selectedImage) = [self.handlers objectForKey:currentActionTag];
                    handler(image);
                }];
            }];
            [previewViewController addPreviewAction:currentPreviewAction];

        }
    }
    
    [self imageForPreviewAtIndex:previewingImageIndex handler:^(UIImage *image) {
        [(KCKeyboardImagePickerPreviewViewController *)previewViewController updateImage:image];
    }];
    return previewViewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
}

# pragma mark - KCKeyboardImagePickerViewDataSource

- (NSInteger)numberOfImagesInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView {
    return [self.photoLibraryFetchResult count];
}

- (UIImage *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView imageAtIndex:(NSInteger)index {
    return self.placeHolderImage;
}

- (BOOL)isImagePickerControllerButtonVisibleInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView {
    return [self.handlers objectForKey:[NSNumber numberWithInteger:-1]] != nil;
}

- (UIColor *)backgroundColorForImagePickerControllerButtonInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView {
    return [self.backgroundColors objectForKey:[NSNumber numberWithInteger:-1]];
}

- (UIImage *)backgroundImageForImagePickerControllerButtonInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView {
    return [self.images objectForKey:[NSNumber numberWithInteger:-1]];
}

- (NSInteger)numberOfOptionButtonsInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView {
    return [self.optionButtonIndices count];
}

- (NSInteger)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView tagForOptionButtonAtIndex:(NSInteger)index {
    return [[self.optionButtonIndices objectForKey:[NSNumber numberWithInteger:index]] integerValue];
}

- (NSString *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView titleForOptionButtonAtIndex:(NSInteger)index {
    NSNumber *optionButtonTagNumber = [self.optionButtonIndices objectForKey:[NSNumber numberWithInteger:index]];
    return [self.titles objectForKey:optionButtonTagNumber];
}

- (UIColor *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView backgroundColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state {
    NSNumber *optionButtonTagNumber = [self.optionButtonIndices objectForKey:[NSNumber numberWithInteger:index]];
    UIColor *backgroundColorNormal = [self.backgroundColors objectForKey:optionButtonTagNumber];
    UIColor *backgroundColorHighlighted = [self.backgroundColors objectForKey:optionButtonTagNumber]; // TODO: highlight it
    switch (state) {
        case UIControlStateNormal:
            return backgroundColorNormal == nil ? [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] : backgroundColorNormal;
        case UIControlStateHighlighted:
            return backgroundColorHighlighted == nil ? [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] : backgroundColorHighlighted;
        default:
            return nil;
    }
}

- (UIColor *)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView titleColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state {
    NSNumber *optionButtonTagNumber = [self.optionButtonIndices objectForKey:[NSNumber numberWithInteger:index]];
    UIColor *titleColorNormal = [self.titleColors objectForKey:optionButtonTagNumber];
    UIColor *titleColorHighlighted = [self.titleColors objectForKey:optionButtonTagNumber]; // TODO: highlight it
    switch (state) {
        case UIControlStateNormal:
            return titleColorNormal == nil ? [UIColor whiteColor] : titleColorNormal;
        case UIControlStateHighlighted:
            return titleColorHighlighted == nil ? [UIColor lightGrayColor] : titleColorHighlighted;
        default:
            return nil;
    }
}


# pragma mark - KCKeyboardImagePickerViewDelegate

- (void)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView didTapOptionButton:(UIButton *)optionButton atIndex:(NSInteger)index {
    PHAsset *currentAsset = [self.photoLibraryFetchResult objectAtIndex:index];
    [[PHImageManager defaultManager] requestImageForAsset:currentAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([[info objectForKey:PHImageResultIsDegradedKey] isEqual:[NSNumber numberWithInt:0]]) {
            void (^ handler)(UIImage *selectedImage) = [self.handlers objectForKey:[NSNumber numberWithInteger:optionButton.tag]];
            if (handler != nil) {
                handler(result);
            }
        }
    }];
}

- (void)keyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView willDisplayImageAtIndex:(NSInteger)index {
    CGSize targetSize = CGSizeMake(self.imagePickerView.frame.size.height * [UIScreen mainScreen].scale, self.imagePickerView.frame.size.height * [UIScreen mainScreen].scale);
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHAsset *currentAsset = [self.photoLibraryFetchResult objectAtIndex:index];
    [[PHImageManager defaultManager] requestImageForAsset:currentAsset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([[info objectForKey:PHImageResultIsDegradedKey] isEqual:[NSNumber numberWithInt:0]]) {
            [keyboardImagePickerView updateImage:result atIndex:index animated:YES];
        }
    }];
}

- (void)didTapImagePickerControllerButtonInKeyboardImagePickerView:(KCKeyboardImagePickerView *)keyboardImagePickerView {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    }
    
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self.imagePickerParentViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    void (^ handler)(UIImage *selectedImage) = [self.handlers objectForKey:[NSNumber numberWithInteger:-1]];
    if (handler != nil) {
        handler(selectedImage);
    }
}

@end
