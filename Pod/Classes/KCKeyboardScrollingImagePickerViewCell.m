//
//  KCKeyboardScrollingImagePickerViewCell.m
//  Pods
//
//  Created by Kevin Yufei Chen on 5/21/15.
//
//

#import "KCKeyboardScrollingImagePickerViewCell.h"

@interface KCKeyboardScrollingImagePickerViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *optionButtonsView;
@property (nonatomic, strong) NSArray *optionButtons;

@property (nonatomic, strong) KCKeyboardScrollingImagePickerOptions *imagePickerOptions;

@end

@implementation KCKeyboardScrollingImagePickerViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)applyOptions:(KCKeyboardScrollingImagePickerOptions *)imagePickerOptions {
    self.imagePickerOptions = imagePickerOptions;
    
    self.optionButtonsView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.optionButtonsView.alpha = 0.0;
    self.optionButtonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurEffectView.frame = self.optionButtonsView.bounds;
    [self.optionButtonsView addSubview:blurEffectView];
    [self.contentView addSubview:self.optionButtonsView];
    [self.contentView bringSubviewToFront:self.optionButtonsView];
    
    NSMutableArray *optionButtons = [[NSMutableArray alloc] initWithCapacity:[self.imagePickerOptions.optionButtonTitles count]];
    for (NSInteger i = 0; i < [self.imagePickerOptions.optionButtonTitles count]; i++) {
        UIButton *currentOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius, kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius)];
        currentOptionButton.tag = i;
        currentOptionButton.alpha = self.imagePickerOptions.optionButtonsAlpha;
        currentOptionButton.layer.masksToBounds = YES;
        currentOptionButton.layer.cornerRadius = kKCKeyboardScrollingImagePickerViewCellOptionButtonRadius / 2.0;
        currentOptionButton.layer.borderWidth = kKCKeyboardScrollingImagePickerViewCellOptionButtonBorderWidth;
        currentOptionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [currentOptionButton addTarget:self action:@selector(toggleButtonColor:) forControlEvents:UIControlEventTouchDown];
        [currentOptionButton addTarget:self action:@selector(toggleButtonColor:) forControlEvents:UIControlEventTouchUpOutside];
        [currentOptionButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [currentOptionButton setTitle:self.imagePickerOptions.optionButtonTitles[i] forState:UIControlStateNormal];
        [currentOptionButton setTitleColor:self.imagePickerOptions.optionButtonTitleNormalColors[i] forState:UIControlStateNormal];
        [currentOptionButton setTitleColor:self.imagePickerOptions.optionButtonTitleHighlightedColors[i] forState:UIControlStateHighlighted];
        [currentOptionButton setBackgroundColor:self.imagePickerOptions.optionButtonColors[i]];
        [optionButtons addObject:currentOptionButton];
        [self.optionButtonsView addSubview:currentOptionButton];
    }
    self.optionButtons = [NSArray arrayWithArray:optionButtons];
    
    switch ([self.imagePickerOptions.optionButtonTitles count]) {
        case 1:
            [self setButtonLayoutForOneButton];
            break;
        case 2:
            [self setButtonLayoutForTwoButtons];
            break;
        case 3:
            [self setButtonLayoutForThreeButtons];
            break;
        case 4:
            [self setButtonLayoutForFourButtons];
            break;
    }
}

- (void)setButtonLayoutForOneButton {
    ((UIButton *)self.optionButtons[0]).center = self.optionButtonsView.center;
}

- (void)setButtonLayoutForTwoButtons {
    ((UIButton *)self.optionButtons[0]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.5);
    ((UIButton *)self.optionButtons[1]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.5);
}

- (void)setButtonLayoutForThreeButtons {
    ((UIButton *)self.optionButtons[0]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.5, self.optionButtonsView.frame.size.height * 0.35);
    ((UIButton *)self.optionButtons[1]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.65);
    ((UIButton *)self.optionButtons[2]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.65);
}

- (void)setButtonLayoutForFourButtons {
    ((UIButton *)self.optionButtons[0]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.3);
    ((UIButton *)self.optionButtons[1]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.3);
    ((UIButton *)self.optionButtons[2]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.3, self.optionButtonsView.frame.size.height * 0.7);
    ((UIButton *)self.optionButtons[3]).center = CGPointMake(self.optionButtonsView.frame.size.width * 0.7, self.optionButtonsView.frame.size.height * 0.7);
}


- (void)showOptionButtonsView:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.optionButtonsView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.contentView bringSubviewToFront:self.optionButtonsView];
        }];
    } else {
        self.optionButtonsView.alpha = 1.0;
        [self.contentView bringSubviewToFront:self.optionButtonsView];
    }
}

- (void)hideOptionButtonsView:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.optionButtonsView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.contentView bringSubviewToFront:self.optionButtonsView];
        }];
    } else {
        self.optionButtonsView.alpha = 0.0;
        [self.contentView bringSubviewToFront:self.optionButtonsView];
    }
}


- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)toggleButtonColor:(UIButton *)button {
    if (button.isHighlighted) {
        [UIView animateWithDuration:0.25 animations:^{
            button.backgroundColor = [UIColor whiteColor];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            button.backgroundColor = self.imagePickerOptions.optionButtonColors[button.tag];
        }];
    }
}

- (void)didTapButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerViewCell:didTapOptionButton:)]) {
        [self.delegate keyboardScrollingImagePickerViewCell:self didTapOptionButton:button];
    }
}


@end
