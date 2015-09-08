//
//  KCKeyboardScrollingImagePickerViewCell.h
//  Pods
//
//  Created by Kevin Yufei Chen on 5/21/15.
//
//

#import <UIKit/UIKit.h>

#import "KCKeyboardScrollingImagePickerOptions.h"

@class KCKeyboardScrollingImagePickerViewCell;

@protocol KCKeyboardScrollingImagePickerViewCellDelegate <NSObject>

- (void)keyboardScrollingImagePickerViewCell:(KCKeyboardScrollingImagePickerViewCell *)cell didTapOptionButton:(UIButton *)button;

@end

@interface KCKeyboardScrollingImagePickerViewCell : UICollectionViewCell

@property (nonatomic, assign) id<KCKeyboardScrollingImagePickerViewCellDelegate> delegate;

- (void)setImage:(UIImage *)image;

- (void)applyOptions:(KCKeyboardScrollingImagePickerOptions *)imagePickerOptions;

- (void)showOptionButtonsView:(BOOL)animated;

- (void)hideOptionButtonsView:(BOOL)animated;

@end
