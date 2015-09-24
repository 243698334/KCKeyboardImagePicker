//
//  DemoMessagesViewController.m
//  KCKeyboardScrollingImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoMessagesViewController.h"

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface DemoMessagesViewController () <JSQMessagesKeyboardControllerDelegate>

@property (strong, nonatomic) KCKeyboardScrollingImagePickerView *keyboardScrollingImagePickerView;
@property (assign, nonatomic) BOOL isKeyboardScrollingImagePickerViewActive;
@property (strong, nonatomic) NSLayoutConstraint *toolbarBottomLayoutGuide;

@property (strong, nonatomic) NSMutableArray *demoMessages;

@property (strong, nonatomic) PHFetchResult *photoLibraryFetchResult;
@property (strong, nonatomic) UIImage *placeHolderImage;

@end

@implementation DemoMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Messages";
    
    self.senderId = @"SenderID";
    self.senderDisplayName = @"Kevin";
    
    self.demoMessages = [[NSMutableArray alloc] initWithObjects:
                         [[JSQMessage alloc] initWithSenderId:@"KC" senderDisplayName:@"Kev1nChen" date:[NSDate date] text:@"Tap on the accessory icon to toggle the picker."],
                         [[JSQMessage alloc] initWithSenderId:@"KC" senderDisplayName:@"Kev1nChen" date:[NSDate date] text:@"This is a demo of the integration with JSQMessagesVC. It should easily work with your own IM interface as well."],
                         nil];
    
    self.isKeyboardScrollingImagePickerViewActive = NO;
    
    self.keyboardController = [[JSQMessagesKeyboardController alloc] initWithTextView:self.inputToolbar.contentView.textView contextView:self.view panGestureRecognizer:self.collectionView.panGestureRecognizer delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidBeginEditing)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.inputToolbar.contentView.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self hideKeyboardScrollingImagePickerView:NO];
}

- (void)textViewTextDidBeginEditing {
    [self hideKeyboardScrollingImagePickerView:YES];
}


#pragma mark - JSQMessagesKeyboardControllerDelegate

- (void)keyboardController:(JSQMessagesKeyboardController *)keyboardController keyboardDidChangeFrame:(CGRect)keyboardFrame {
    if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
        return;
    }
    
    // when the keyboard scrolling image picker is about to appear,
    // the `inputToolbar` should not be moved.
    // so the keyboard can be dismissed and make room for the picker.
    if (self.isKeyboardScrollingImagePickerViewActive) {
        return;
    }
    
    // copied from JSQMessagesViewController
    CGFloat heightFromBottom = CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(keyboardFrame);
    heightFromBottom = MAX(0.0f, heightFromBottom);
    self.toolbarBottomLayoutGuide.constant = heightFromBottom;
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topLayoutGuide.length + self.topContentAdditionalInset, 0.0f,
                                           CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(self.inputToolbar.frame), 0.0f);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

- (void)showKeyboardScrollingImagePickerView:(BOOL)animated {
    if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    }
    
    if (self.isKeyboardScrollingImagePickerViewActive) {
        return;
    }
    
    self.isKeyboardScrollingImagePickerViewActive = YES;
    
    // In this demo, we will be using the Photos Framework to load images from camera roll.
    if (self.photoLibraryFetchResult == nil) {
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.photoLibraryFetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
        self.placeHolderImage = [UIImage imageNamed:@"PlaceHolderImage"];
    }
    
    // Initialize the picker view and assign its dataSource and delegate.
    if (self.keyboardScrollingImagePickerView == nil) {
        self.keyboardScrollingImagePickerView = [[KCKeyboardScrollingImagePickerView alloc] init];
        self.keyboardScrollingImagePickerView.dataSource = self;
        self.keyboardScrollingImagePickerView.delegate = self;
    }
    
    // To integrate with JSQMessagesViewController, add the picker to the keyboardController's contextView.
    [self.keyboardController.contextView addSubview:self.keyboardScrollingImagePickerView];
    [self.keyboardController.contextView bringSubviewToFront:self.keyboardScrollingImagePickerView];
    
    // Set the image picker's frame to be the same as the keyboard's.
    CGRect keyboardFrame = self.keyboardController.currentKeyboardFrame;
    [self.keyboardController.contextView endEditing:YES];
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.keyboardScrollingImagePickerView.frame = keyboardFrame;
        }];
    } else {
        self.keyboardScrollingImagePickerView.frame = keyboardFrame;
    }
}

- (void)hideKeyboardScrollingImagePickerView:(BOOL)animated {
    if (self.isKeyboardScrollingImagePickerViewActive == NO) {
        return;
    }
    CGRect pickerFrame = self.keyboardScrollingImagePickerView.frame;
    pickerFrame.origin.y = pickerFrame.origin.y + pickerFrame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.keyboardScrollingImagePickerView.frame = pickerFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.isKeyboardScrollingImagePickerViewActive = NO;
                [self.keyboardScrollingImagePickerView removeFromSuperview];
            }
        }];
    } else {
        self.keyboardScrollingImagePickerView.frame = pickerFrame;
        self.isKeyboardScrollingImagePickerViewActive = NO;
        [self.keyboardScrollingImagePickerView removeFromSuperview];
    }
}


#pragma mark - KCKeyboardScrollingImagePickerViewDataSource

- (NSInteger)numberOfImagesInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    return [self.photoLibraryFetchResult count];
}

- (UIImage *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView imageAtIndex:(NSInteger)index {
    // Instead of the actual image, it is recommended to return a placeholder image here.
    // Read the documentation for this data source method for more details.
    return self.placeHolderImage;
}

- (BOOL)isImagePickerControllerButtonVisibleInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    return YES;
}

- (UIColor *)backgroundColorForImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    return self.imagePickerOptions.imagePickerControllerButtonColor;
}

- (UIImage *)backgroundImageForImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    return [UIImage imageNamed:@"ImagePickerControllerButtonIcon"];
}

- (NSInteger)numberOfOptionButtonsInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    return [self.imagePickerOptions.optionButtonTitles count];
}

- (NSString *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView titleForOptionButtonAtIndex:(NSInteger)index {
    return [self.imagePickerOptions.optionButtonTitles objectAtIndex:index];
}

- (UIColor *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView backgroundColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            return [self.imagePickerOptions.optionButtonColors objectAtIndex:index];
        case UIControlStateHighlighted:
            return [UIColor lightGrayColor];
        default:
            return [UIColor lightGrayColor];
    }
}

- (UIColor *)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView titleColorForOptionButtonAtIndex:(NSInteger)index forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            return [self.imagePickerOptions.optionButtonTitleNormalColors objectAtIndex:index];
        case UIControlStateHighlighted:
            return [self.imagePickerOptions.optionButtonTitleHighlightedColors objectAtIndex:index];
        default:
            return nil;
    }
}

#pragma mark - KCKeyboardScrollingImagePickerViewDelegate

- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView willDisplayImageAtIndex:(NSInteger)index {
    CGSize targetSize = CGSizeMake(self.keyboardScrollingImagePickerView.frame.size.height * [UIScreen mainScreen].scale, self.keyboardScrollingImagePickerView.frame.size.height * [UIScreen mainScreen].scale);
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHAsset *currentAsset = [self.photoLibraryFetchResult objectAtIndex:index];
    [[PHImageManager defaultManager] requestImageForAsset:currentAsset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([[info objectForKey:PHImageResultIsDegradedKey] isEqual:[NSNumber numberWithInt:0]]) {
            [keyboardScrollingImagePickerView updateImage:result atIndex:index animated:YES];
        }
    }];
}

- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didTapOptionButton:(UIButton *)optionButton atIndex:(NSInteger)index {
    PHAsset *currentAsset = [self.photoLibraryFetchResult objectAtIndex:index];
    [[PHImageManager defaultManager] requestImageForAsset:currentAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([[info objectForKey:PHImageResultIsDegradedKey] isEqual:[NSNumber numberWithInt:0]]) {
            JSQPhotoMediaItem *photoMediaItem = [[JSQPhotoMediaItem alloc] initWithImage:result];
            JSQMessage *newImageMessage = [JSQMessage messageWithSenderId:self.senderId displayName:self.senderDisplayName media:photoMediaItem];
            [self.demoMessages addObject:newImageMessage];
            [self finishSendingMessageAnimated:YES];
        }
    }];
}

- (void)needLoadMoreImagesForKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    // optional
}

- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didSelectItemAtIndex:(NSInteger)index {
    // optional
}

- (void)keyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView didDeselectItemAtIndex:(NSInteger)index {
    // optional
}

- (void)didTapImagePickerControllerButtonInKeyboardScrollingImagePickerView:(KCKeyboardScrollingImagePickerView *)keyboardScrollingImagePickerView {
    [self hideKeyboardScrollingImagePickerView:YES];
    
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
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    JSQPhotoMediaItem *photoMediaItem = [[JSQPhotoMediaItem alloc] initWithImage:selectedImage];
    JSQMessage *newImageMessage = [JSQMessage messageWithSenderId:self.senderId displayName:self.senderDisplayName media:photoMediaItem];
    [self.demoMessages addObject:newImageMessage];
    [self finishSendingMessageAnimated:YES];
}


// ================================================================================= \\
// All methods below this point are copied from the JSQMessagesViewController Demo.  \\
// As mentioned in the README, this is just a demo of KCKeyboardScrollingImagePicker \\
// integrating with JSQMessagesViewController. However, using this library in your   \\
// own implementation is not hard at all.                                            \\
// ================================================================================= \\

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    [self.demoMessages addObject:message];
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    if (self.isKeyboardScrollingImagePickerViewActive) {
        [self hideKeyboardScrollingImagePickerView:YES];
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    } else {
        [self showKeyboardScrollingImagePickerView:YES];
    }
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.demoMessages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.demoMessages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.demoMessages objectAtIndex:indexPath.item];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    if ([message.senderId isEqualToString:self.senderId]) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    } else {
        return [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"DefaultAvatar"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.demoMessages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoMessages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.demoMessages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.demoMessages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}


#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *currentMessage = [self.demoMessages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoMessages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

@end
