//
//  KCKeyboardImagePickerView.m
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

#import "KCKeyboardImagePickerView.h"

CGFloat const kKCKeyboardImagePickerViewCellOptionButtonRadius = 60.0;
CGFloat const kKCKeyboardImagePickerViewCellOptionButtonBorderWidth = 2.0;

@interface KCKeyboardImagePickerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *imagesCollectionView;
@property (nonatomic, strong) UIButton *imagePickerControllerButton;
@property (nonatomic, strong) UIView *optionButtonsView;
@property (nonatomic, strong) UIVisualEffectView *blurVisualEffectView;
@property (nonatomic, strong) NSMutableArray *optionButtons;

@property (nonatomic, assign) BOOL isLoadingImages;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

@end

@implementation KCKeyboardImagePickerView

- (id)init {
    CGRect initialFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    if (self = [super initWithFrame:initialFrame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 2.0;
        self.imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.imagesCollectionView.delegate = self;
        self.imagesCollectionView.dataSource = self;
        self.imagesCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imagesCollectionView.allowsMultipleSelection = NO;
        self.imagesCollectionView.allowsSelection = YES;
        self.imagesCollectionView.showsHorizontalScrollIndicator = NO;
        self.imagesCollectionView.backgroundColor = [UIColor whiteColor];
        [self.imagesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"KeyboardImagePickerViewCell"];
        [self addSubview:self.imagesCollectionView];
        
        self.imagePickerControllerButton = [[UIButton alloc] init];
        self.imagePickerControllerButton.layer.masksToBounds = YES;
        self.imagePickerControllerButton.layer.cornerRadius = 25;
        [self.imagePickerControllerButton addTarget:self action:@selector(didTapImagePickerControllerButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imagePickerControllerButton];
        
        self.isLoadingImages = NO;
        self.currentSelectedIndexPath = nil;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self renderImagesCollectionView];
    [self renderImagePickerViewControllerButton];
    [self renderOptionButtons];
}

- (void)updateImage:(UIImage *)image atIndex:(NSInteger)index animated:(BOOL)animated {
    UICollectionViewCell *cell = [self.imagesCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UIImage *squareImage = [self squareImageWithImage:image scaledToSize:self.frame.size.height];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:squareImage];
    imageView.alpha = 0.0;
    [cell.contentView addSubview:imageView];
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            imageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            cell.backgroundView = nil;
        }];
    } else {
        imageView.alpha = 1.0;
        cell.backgroundView = nil;
    }
}

- (void)renderImagesCollectionView {
    self.imagesCollectionView.frame = self.bounds;
    [self.imagesCollectionView reloadData];
}

- (void)renderImagePickerViewControllerButton {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isImagePickerControllerButtonVisibleInKeyboardImagePickerView:)]) {
        [self.imagePickerControllerButton removeFromSuperview];
        if ([self.dataSource isImagePickerControllerButtonVisibleInKeyboardImagePickerView:self]) {
            [self addSubview:self.imagePickerControllerButton];
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(backgroundColorForImagePickerControllerButtonInKeyboardImagePickerView:)]) {
        self.imagePickerControllerButton.backgroundColor = [self.dataSource backgroundColorForImagePickerControllerButtonInKeyboardImagePickerView:self];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(backgroundImageForImagePickerControllerButtonInKeyboardImagePickerView:)]) {
        [self.imagePickerControllerButton setImage:[self. dataSource backgroundImageForImagePickerControllerButtonInKeyboardImagePickerView:self] forState:UIControlStateNormal];
    }
    self.imagePickerControllerButton.frame = CGRectMake(5, self.bounds.size.height - 50 - 5, 50, 50);
}

- (void)renderOptionButtons {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfOptionButtonsInKeyboardImagePickerView:)]) {
        if ([self.dataSource numberOfOptionButtonsInKeyboardImagePickerView:self] > 0) {
            self.optionButtonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imagesCollectionView.bounds.size.height, self.imagesCollectionView.bounds.size.height)];
            self.optionButtonsView.alpha = 0.0;
            self.optionButtonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.blurVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            self.blurVisualEffectView.frame = self.optionButtonsView.bounds;
            [self.optionButtonsView addSubview:self.blurVisualEffectView];
            
            self.optionButtons = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < [self.dataSource numberOfOptionButtonsInKeyboardImagePickerView:self]; i++) {
                UIButton *currentOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kKCKeyboardImagePickerViewCellOptionButtonRadius, kKCKeyboardImagePickerViewCellOptionButtonRadius)];
                currentOptionButton.tag = i;
                currentOptionButton.layer.masksToBounds = YES;
                currentOptionButton.layer.cornerRadius = kKCKeyboardImagePickerViewCellOptionButtonRadius / 2.0;
                currentOptionButton.layer.borderWidth = kKCKeyboardImagePickerViewCellOptionButtonBorderWidth;
                currentOptionButton.layer.borderColor = [UIColor whiteColor].CGColor;
                [currentOptionButton addTarget:self action:@selector(didTapOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [currentOptionButton addTarget:self action:@selector(refreshOptionButtonBackgroundColor:) forControlEvents:UIControlEventTouchDown];
                [currentOptionButton addTarget:self action:@selector(refreshOptionButtonBackgroundColor:) forControlEvents:UIControlEventTouchUpInside];
                [currentOptionButton addTarget:self action:@selector(refreshOptionButtonBackgroundColor:) forControlEvents:UIControlEventTouchUpOutside];
                [self.optionButtons addObject:currentOptionButton];
                [self.optionButtonsView addSubview:currentOptionButton];
            }
        } else {
            return;
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardImagePickerView:titleForOptionButtonAtIndex:)]) {
        for (UIButton *currentOptionButton in self.optionButtons) {
            [currentOptionButton setTitle:[self.dataSource keyboardImagePickerView:self titleForOptionButtonAtIndex:currentOptionButton.tag] forState:UIControlStateNormal];
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardImagePickerView:titleColorForOptionButtonAtIndex:forState:)]) {
        for (UIButton *currentOptionButton in self.optionButtons) {
            [currentOptionButton setTitleColor:[self.dataSource keyboardImagePickerView:self titleColorForOptionButtonAtIndex:currentOptionButton.tag forState:UIControlStateNormal] forState:UIControlStateNormal];
            [currentOptionButton setTitleColor:[self.dataSource keyboardImagePickerView:self titleColorForOptionButtonAtIndex:currentOptionButton.tag forState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardImagePickerView:backgroundColorForOptionButtonAtIndex:forState:)]) {
        for (UIButton *currentOptionButton in self.optionButtons) {
            currentOptionButton.backgroundColor = [self.dataSource keyboardImagePickerView:self backgroundColorForOptionButtonAtIndex:currentOptionButton.tag forState:UIControlStateNormal];
        }
    }
    
    switch ([self.dataSource numberOfOptionButtonsInKeyboardImagePickerView:self]) {
        case 1:
            [self renderOneOptionButtonLayout];
            break;
        case 2:
            [self renderTwoOptionButtonsLayout];
            break;
        case 3:
            [self renderThreeOptionButtonsLayout];
            break;
        case 4:
            [self renderFourOptionButtonsLayout];
            break;
    }
}

- (void)renderOneOptionButtonLayout {
     ((UIButton *)self.optionButtons[0]).center = self.optionButtonsView.center;
}

- (void)renderTwoOptionButtonsLayout {
    ((UIButton *)self.optionButtons[0]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.5);
    ((UIButton *)self.optionButtons[1]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.5);
}

- (void)renderThreeOptionButtonsLayout {
    ((UIButton *)self.optionButtons[0]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.5, self.optionButtonsView.frame.size.height * 0.35);
    ((UIButton *)self.optionButtons[1]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.65);
    ((UIButton *)self.optionButtons[2]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.65);
}

- (void)renderFourOptionButtonsLayout {
    ((UIButton *)self.optionButtons[0]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.3);
    ((UIButton *)self.optionButtons[1]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.3);
    ((UIButton *)self.optionButtons[2]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.7);
    ((UIButton *)self.optionButtons[3]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.7);
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGFloat)size {
    CGPoint origin = CGPointZero;
    CGFloat scaleRatio = 0;
    
    if (image.size.width > image.size.height) {
        scaleRatio = size / image.size.height;
        origin = CGPointMake(-(image.size.width - image.size.height) / 2, 0);
    } else {
        scaleRatio = size / image.size.width;
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2);
    }
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), YES, 0);
    CGContextConcatCTM(UIGraphicsGetCurrentContext(), scaleTransform);
    [image drawAtPoint:origin];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didTapImagePickerControllerButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapImagePickerControllerButtonInKeyboardImagePickerView:)]) {
        [self.delegate didTapImagePickerControllerButtonInKeyboardImagePickerView:self];
    }
}

- (void)showOptionButtonsViewInCollectionViewCell:(UICollectionViewCell *)cell animated:(BOOL)animated {
    [cell.contentView addSubview:self.optionButtonsView];
    self.optionButtonsView.frame = cell.contentView.bounds;
    self.blurVisualEffectView.frame = cell.contentView.bounds;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.optionButtonsView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [cell.contentView bringSubviewToFront:self.optionButtonsView];
        }];
    } else {
        self.optionButtonsView.alpha = 1.0;
        [cell.contentView bringSubviewToFront:self.optionButtonsView];
    }
}

- (void)hideOptionButtonsViewInCollectionViewCell:(UICollectionViewCell *)cell animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.optionButtonsView.alpha = 0.0;
        }];
    } else {
        self.optionButtonsView.alpha = 0.0;
        [self.optionButtonsView removeFromSuperview];
    }
}

- (void)refreshOptionButtonBackgroundColor:(UIButton *)optionButton {
    if (optionButton.isHighlighted) {
        [UIView animateWithDuration:0.25 animations:^{
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardImagePickerView:backgroundColorForOptionButtonAtIndex:forState:)]) {
                optionButton.backgroundColor = [self.dataSource keyboardImagePickerView:self backgroundColorForOptionButtonAtIndex:optionButton.tag forState:UIControlStateHighlighted];
            } else {
                optionButton.backgroundColor = [UIColor whiteColor];
            }
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardImagePickerView:backgroundColorForOptionButtonAtIndex:forState:)]) {
                optionButton.backgroundColor = [self.dataSource keyboardImagePickerView:self backgroundColorForOptionButtonAtIndex:optionButton.tag forState:UIControlStateNormal];
            } else {
                optionButton.backgroundColor = [UIColor lightGrayColor];
            }
        }];
    }
}

- (void)didTapOptionButton:(UIButton *)optionButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardImagePickerView:didTapOptionButton:atIndex:)]) {
        [self.delegate keyboardImagePickerView:self didTapOptionButton:optionButton atIndex:self.currentSelectedIndexPath.row];
        [self collectionView:self.imagesCollectionView didDeselectItemAtIndexPath:self.currentSelectedIndexPath];
        optionButton.highlighted = NO;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfImagesInKeyboardImagePickerView:)]) {
        return [self.dataSource numberOfImagesInKeyboardImagePickerView:self];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KeyboardImagePickerViewCell" forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[self.dataSource keyboardImagePickerView:self imageAtIndex:indexPath.row]];
    return cell;
}


#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardImagePickerView:willDisplayImageAtIndex:)]) {
        [self.delegate keyboardImagePickerView:self willDisplayImageAtIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView *currentSubview in cell.contentView.subviews) {
        [currentSubview removeFromSuperview];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hideOptionButtonsViewInCollectionViewCell:[collectionView cellForItemAtIndexPath:indexPath] animated:YES];
    self.currentSelectedIndexPath = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardImagePickerView:didDeselectItemAtIndex:)]) {
        [self.delegate keyboardImagePickerView:self didDeselectItemAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentSelectedIndexPath != nil) {
        self.currentSelectedIndexPath = nil;
        [self hideOptionButtonsViewInCollectionViewCell:[collectionView cellForItemAtIndexPath:indexPath] animated:YES];
    } else {
        self.currentSelectedIndexPath = indexPath;
        [self showOptionButtonsViewInCollectionViewCell:[collectionView cellForItemAtIndexPath:indexPath] animated:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardImagePickerView:didSelectItemAtIndex:)]) {
        [self.delegate keyboardImagePickerView:self didSelectItemAtIndex:indexPath.row];
    }
}


@end
