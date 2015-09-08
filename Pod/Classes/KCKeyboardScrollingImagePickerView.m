//
//  KCKeyboardScrollingImagePickerView.m
//  KCKeyboardScrollingImagePickerView
//
//  Created by Chengkan Huang & Kevin Yufei Chen
//
//

#import "KCKeyboardScrollingImagePickerView.h"

#import <PureLayout/PureLayout.h>
#import "KCKeyboardScrollingImagePickerViewCell.h"

@interface KCKeyboardScrollingImagePickerView () <UICollectionViewDataSource, UICollectionViewDelegate, KCKeyboardScrollingImagePickerViewCellDelegate>

@property (nonatomic, strong) KCKeyboardScrollingImagePickerOptions *options;

@property (nonatomic, strong) UICollectionView *imagesCollectionView;
@property (nonatomic, strong) UIButton *imagePickerControllerButton;

@property (nonatomic, assign) BOOL updatedConstraints;
@property (nonatomic, assign) BOOL isLoadingImages;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

@end

@implementation KCKeyboardScrollingImagePickerView

- (id)initWithKeyboardScrollingImagePickerOptions:(KCKeyboardScrollingImagePickerOptions *)options {
    CGRect initialFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    if (self = [super initWithFrame:initialFrame]) {
        if (options == nil) {
            self.options = [[KCKeyboardScrollingImagePickerOptions alloc] init];
        } else {
            self.options = options;
        }
        
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
        self.imagesCollectionView.backgroundColor = self.options.backgroundColor;
        [self.imagesCollectionView registerClass:[KCKeyboardScrollingImagePickerViewCell class] forCellWithReuseIdentifier:@"KeyboardScrollingImagePickerViewCell"];
        [self addSubview:self.imagesCollectionView];
        
        self.imagePickerControllerButton = [[UIButton alloc] init];
        self.imagePickerControllerButton.layer.masksToBounds = YES;
        self.imagePickerControllerButton.layer.cornerRadius = self.options.imagePickerControllerButtonSize / 2;
        self.imagePickerControllerButton.backgroundColor = self.options.imagePickerControllerButtonColor;
        self.imagePickerControllerButton.alpha = self.options.imagePickerControllerButtonAlpha;
        [self.imagePickerControllerButton setImage:self.options.imagePickerControllerButtonImage forState:UIControlStateNormal];
        [self.imagePickerControllerButton addTarget:self action:@selector(didTapImagePickerControllerButton:) forControlEvents:UIControlEventTouchUpInside];
        if (self.options.imagePickerControllerButtonIsVisible) {
            [self addSubview:self.imagePickerControllerButton];
        }
        
        self.updatedConstraints = NO;
        self.isLoadingImages = NO;
        self.currentSelectedIndexPath = nil;
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (id)init {
    return [self initWithKeyboardScrollingImagePickerOptions:nil];
}

- (void)reloadData {
    [self.imagesCollectionView reloadData];
}

- (void)updateConstraints {
    [self.imagesCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.imagesCollectionView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    [self.imagePickerControllerButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-5 relation:NSLayoutRelationEqual];
    [self.imagePickerControllerButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:5 relation:NSLayoutRelationEqual];
    [self.imagePickerControllerButton autoSetDimension:ALDimensionHeight toSize:50];
    [self.imagePickerControllerButton autoSetDimension:ALDimensionWidth toSize:50];
    [super updateConstraints];
} // TODO remove PureLayout dependency


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
    KCKeyboardScrollingImagePickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KeyboardScrollingImagePickerViewCell" forIndexPath:indexPath];
    [cell applyOptions:self.options];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(keyboardScrollingImagePickerView:imageAtIndex:)]) {
        [cell setImage:[self.dataSource keyboardScrollingImagePickerView:self imageAtIndex:indexPath.row]];
    }
    return cell;
}


#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *imageAtPath = [self.dataSource keyboardScrollingImagePickerView:self imageAtIndex:indexPath.row];
    
    CGFloat imageHeight = imageAtPath.size.height;
    CGFloat viewHeight = collectionView.frame.size.height;
    CGFloat scaleFactor = viewHeight/imageHeight;
    
    CGSize scaledSize = CGSizeApplyAffineTransform(imageAtPath.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    scaledSize.height = MIN(viewHeight, scaledSize.height);
    return scaledSize;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    KCKeyboardScrollingImagePickerViewCell *cell = (KCKeyboardScrollingImagePickerViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.delegate = nil;
    [cell hideOptionButtonsView:YES];
    self.currentSelectedIndexPath = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerView:didDeselectItemAtIndex:)]) {
        [self.delegate keyboardScrollingImagePickerView:self didDeselectItemAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KCKeyboardScrollingImagePickerViewCell *cell = (KCKeyboardScrollingImagePickerViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.currentSelectedIndexPath != nil) {
        self.currentSelectedIndexPath = nil;
        cell.delegate = nil;
        [cell hideOptionButtonsView:YES];
    } else {
        self.currentSelectedIndexPath = indexPath;
        cell.delegate = self;
        [cell showOptionButtonsView:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerView:didSelectItemAtIndex:)]) {
        [self.delegate keyboardScrollingImagePickerView:self didSelectItemAtIndex:indexPath.row];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentSelectedIndexPath != nil) {
        KCKeyboardScrollingImagePickerViewCell *cell = (KCKeyboardScrollingImagePickerViewCell *)[self.imagesCollectionView cellForItemAtIndexPath:self.currentSelectedIndexPath];
        cell.delegate = nil;
        [cell hideOptionButtonsView:YES];
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

- (void)didTapImagePickerControllerButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:)]) {
        [self.delegate didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:self];
    }
}


#pragma mark - KCKeyboardScrollingImagePickerViewCellDelegate

- (void)keyboardScrollingImagePickerViewCell:(KCKeyboardScrollingImagePickerViewCell *)cell didTapOptionButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollingImagePickerView:didTapOptionButton:atIndex:)]) {
        [self.delegate keyboardScrollingImagePickerView:self didTapOptionButton:button atIndex:self.currentSelectedIndexPath.row];
    }
}


@end
