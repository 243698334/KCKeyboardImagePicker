//
//  KCKeyboardScrollingImagePickerView.h
//  KCKeyboardScrollingImagePickerView
//
//  Created by Chengkan Huang & Kevin Yufei Chen
//
//

#import <UIKit/UIKit.h>
#import "KCKeyboardScrollingImagePickerOptions.h"

@class KCKeyboardScrollingImagePickerView;

@protocol KCKeyboardScrollingImagePickerViewDelegate <NSObject>

@required
- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didTapOptionButton:(UIButton *)button atIndex:(NSInteger)index;

@optional
- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didSelectItemAtIndex:(NSInteger)index;

@optional
- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didDeselectItemAtIndex:(NSInteger)index;

@optional
- (void)didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@optional
- (void)needLoadMoreImagesForKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@end

@protocol KCKeyboardScrollingImagePickerViewDataSource <NSObject>

@required
- (UIImage *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView imageAtIndex:(NSInteger)index;

@required
- (NSInteger)numberOfImagesInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView;

@end

@interface KCKeyboardScrollingImagePickerView : UIView<UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) id<KCKeyboardScrollingImagePickerViewDelegate> delegate;

@property (nonatomic, assign) id<KCKeyboardScrollingImagePickerViewDataSource> dataSource;

- (id)initWithKeyboardScrollingImagePickerOptions:(KCKeyboardScrollingImagePickerOptions *)options;

- (void)reloadData;

@end
