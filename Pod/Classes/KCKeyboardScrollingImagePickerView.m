//
//  KCKeyboardScrollingImagePickerView.m
//  https://github.com/Kev1nChen/KCKeyboardScrollingImagePicker
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

#import "KCKeyboardScrollingImagePickerView.h"

CGFloat const kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius = 60.0;
CGFloat const kKCKeyboardScrollingImagePickerViewCellOptionButtonBorderWidth = 2.0;

@interface KCKeyboardScrollingImagePickerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *imagesCollectionView;
@property (nonatomic, strong) UIButton *imagePickerControllerButton;
@property (nonatomic, strong) UIView *optionButtonsView;
@property (nonatomic, strong) UIVisualEffectView *blurVisualEffectView;
@property (nonatomic, strong) NSMutableArray *optionButtons;

@property (nonatomic, assign) BOOL updatedConstraints;
@property (nonatomic, assign) BOOL isLoadingImages;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

@end

@implementation KCKeyboardScrollingImagePickerView

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
        [self.imagesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"KeyboardScrollingImagePickerViewCell"];
        [self addSubview:self.imagesCollectionView];
        
        self.imagePickerControllerButton = [[UIButton alloc] init];
        self.imagePickerControllerButton.layer.masksToBounds = YES;
        self.imagePickerControllerButton.layer.cornerRadius = 25;
        [self.imagePickerControllerButton addTarget:self action:@selector(didTapImagePickerControllerButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imagePickerControllerButton];
        
        self.updatedConstraints = NO;
        self.isLoadingImages = NO;
        self.currentSelectedIndexPath = nil;
    }
    return self;
}

- (void)render {
    [self renderImagesCollectionView];
    [self renderImagePickerViewControllerButton];
    [self renderOptionButtons];
}

- (void)renderImagesCollectionView {
    self.imagesCollectionView.frame = self.bounds;
    [self.imagesCollectionView reloadData];
}

- (void)renderImagePickerViewControllerButton {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(isImagePickerControllerButtonVisibleInKeyboardScrollingImagePickerView:)]) {
        [self.imagePickerControllerButton removeFromSuperview];
        if ([self.dataSource isImagePickerControllerButtonVisibleInKeyboardScrollingImagePickerView:self]) {
            [self addSubview:self.imagePickerControllerButton];
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(backgroundColorForImagePickerControllerButtonInKeyboardScrollingImagePickerView:)]) {
        self.imagePickerControllerButton.backgroundColor = [self.dataSource backgroundColorForImagePickerControllerButtonInKeyboardScrollingImagePickerView:self];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(backgroundImageForImagePickerControllerButtonInKeyboardScrollingImagePickerView:)]) {
        [self.imagePickerControllerButton setImage:[self. dataSource backgroundImageForImagePickerControllerButtonInKeyboardScrollingImagePickerView:self] forState:UIControlStateNormal];
    }
    self.imagePickerControllerButton.frame = CGRectMake(5, self.bounds.size.height - 50 - 5, 50, 50);
}

- (void)renderOptionButtons {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfOptionButtonsInKeyboardScrollingImagePickerView:)]) {
        if ([self.dataSource numberOfOptionButtonsInKeyboardScrollingImagePickerView:self] > 0) {
            self.optionButtonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imagesCollectionView.bounds.size.height, self.imagesCollectionView.bounds.size.height)];
            self.optionButtonsView.alpha = 0.0;
            self.optionButtonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.blurVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            self.blurVisualEffectView.frame = self.optionButtonsView.bounds;
            [self.optionButtonsView addSubview:self.blurVisualEffectView];
            
            self.optionButtons = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < [self.dataSource numberOfOptionButtonsInKeyboardScrollingImagePickerView:self]; i++) {
                UIButton *currentOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius, kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius)];
                currentOptionButton.tag = i;
                currentOptionButton.layer.masksToBounds = YES;
                currentOptionButton.layer.cornerRadius = kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius / 2.0;
                currentOptionButton.layer.borderWidth = kKCKeyboardScrollingImagePickerViewCellOptionButtonBorderWidth;
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
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardScrollingImagePickerView:titleForOptionButtonAtIndex:)]) {
        for (UIButton *currentOptionButton in self.optionButtons) {
            [currentOptionButton setTitle:[self.dataSource keyboardScrollingImagePickerView:self titleForOptionButtonAtIndex:currentOptionButton.tag] forState:UIControlStateNormal];
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardScrollingImagePickerView:titleColorForOptionButtonAtIndex:forState:)]) {
        for (UIButton *currentOptionButton in self.optionButtons) {
            [currentOptionButton setTitleColor:[self.dataSource keyboardScrollingImagePickerView:self titleColorForOptionButtonAtIndex:currentOptionButton.tag forState:UIControlStateNormal] forState:UIControlStateNormal];
            [currentOptionButton setTitleColor:[self.dataSource keyboardScrollingImagePickerView:self titleColorForOptionButtonAtIndex:currentOptionButton.tag forState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardScrollingImagePickerView:backgroundColorForOptionButtonAtIndex:forState:)]) {
        for (UIButton *currentOptionButton in self.optionButtons) {
            currentOptionButton.backgroundColor = [self.dataSource keyboardScrollingImagePickerView:self backgroundColorForOptionButtonAtIndex:currentOptionButton.tag forState:UIControlStateNormal];
        }
    }
    
    switch ([self.dataSource numberOfOptionButtonsInKeyboardScrollingImagePickerView:self]) {
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

- (void)didTapImagePickerControllerButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:)]) {
        [self.delegate didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:self];
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
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardScrollingImagePickerView:backgroundColorForOptionButtonAtIndex:forState:)]) {
                optionButton.backgroundColor = [self.dataSource keyboardScrollingImagePickerView:self backgroundColorForOptionButtonAtIndex:optionButton.tag forState:UIControlStateHighlighted];
            } else {
                optionButton.backgroundColor = [UIColor whiteColor];
            }
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardScrollingImagePickerView:backgroundColorForOptionButtonAtIndex:forState:)]) {
                optionButton.backgroundColor = [self.dataSource keyboardScrollingImagePickerView:self backgroundColorForOptionButtonAtIndex:optionButton.tag forState:UIControlStateNormal];
            } else {
                optionButton.backgroundColor = [UIColor lightGrayColor];
            }
        }];
    }
}

- (void)didTapOptionButton:(UIButton *)optionButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerView:didTapOptionButton:atIndex:)]) {
        [self.delegate keyboardScrollingImagePickerView:self didTapOptionButton:optionButton atIndex:self.currentSelectedIndexPath.row];
        [self collectionView:self.imagesCollectionView didDeselectItemAtIndexPath:self.currentSelectedIndexPath];
        optionButton.highlighted = NO;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfImagesInKeyboardScrollingImagePickerView:)]) {
        if ([self.dataSource numberOfImagesInKeyboardScrollingImagePickerView:self] == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(needLoadMoreImagesForKeyboardScrollingImagePickerView:)]) {
                [self.delegate needLoadMoreImagesForKeyboardScrollingImagePickerView:self];
            }
        }
        return [self.dataSource numberOfImagesInKeyboardScrollingImagePickerView:self];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KeyboardScrollingImagePickerViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.dataSource keyboardScrollingImagePickerView:self imageAtIndex:indexPath.row]];
    cell.backgroundView = imageView;
    return cell;
}


#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *currentImage = [self.dataSource keyboardScrollingImagePickerView:self imageAtIndex:indexPath.row];
    
    CGFloat imageHeight = currentImage.size.height;
    CGFloat viewHeight = collectionView.frame.size.height;
    CGFloat scaleFactor = viewHeight / imageHeight;
    
    CGSize scaledSize = CGSizeApplyAffineTransform(currentImage.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    scaledSize.height = viewHeight < scaledSize.height ? viewHeight : scaledSize.height;
    return scaledSize;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hideOptionButtonsViewInCollectionViewCell:[collectionView cellForItemAtIndexPath:indexPath] animated:YES];
    self.currentSelectedIndexPath = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerView:didDeselectItemAtIndex:)]) {
        [self.delegate keyboardScrollingImagePickerView:self didDeselectItemAtIndex:indexPath.row];
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerView:didSelectItemAtIndex:)]) {
        [self.delegate keyboardScrollingImagePickerView:self didSelectItemAtIndex:indexPath.row];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentSelectedIndexPath != nil) {
        [self hideOptionButtonsViewInCollectionViewCell:[self.imagesCollectionView cellForItemAtIndexPath:self.currentSelectedIndexPath] animated:YES];
        self.currentSelectedIndexPath = nil;
    }
    
    if (scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width) {
        // reach the right end of the scrollView
        if (!self.isLoadingImages) {
            self.isLoadingImages = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(needLoadMoreImagesForKeyboardScrollingImagePickerView:)]) {
                [self.delegate needLoadMoreImagesForKeyboardScrollingImagePickerView:self];
            }
        }
    }
}


@end
