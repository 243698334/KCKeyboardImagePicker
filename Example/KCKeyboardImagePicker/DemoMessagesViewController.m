//
//  DemoMessagesViewController.m
//  KCKeyboardImagePicker
//
//  Created by Kevin Yufei Chen on 9/6/15.
//  Copyright (c) 2015 Kev1nChen. All rights reserved.
//

#import "DemoMessagesViewController.h"

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <KCKeyboardImagePicker/KCKeyboardImagePickerController.h>
#import <KCKeyboardImagePicker/KCKeyboardImagePickerPreviewViewController.h>

@interface DemoMessagesViewController () <JSQMessagesKeyboardControllerDelegate>

@property (strong, nonatomic) KCKeyboardImagePickerController *keyboardImagePickerController;

@property (assign, nonatomic) BOOL isKeyboardImagePickerViewActive;
@property (strong, nonatomic) NSLayoutConstraint *toolbarBottomLayoutGuide;
@property (strong, nonatomic) NSMutableArray *demoMessages;

@end

@implementation DemoMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Messages";
    
    self.senderId = @"SenderID";
    self.senderDisplayName = @"Kevin";
    
    self.demoMessages = [[NSMutableArray alloc] initWithObjects:
                         [[JSQMessage alloc] initWithSenderId:@"KC" senderDisplayName:@"Kev1nChen" date:[NSDate date] text:@"Tap on the accessory icon to toggle the picker."],
                         [[JSQMessage alloc] initWithSenderId:@"KC" senderDisplayName:@"Kev1nChen" date:[NSDate date] text:@"When running for the first time, grant the access and re-enter this chat window."],
                         nil];
    
    self.isKeyboardImagePickerViewActive = NO;
    
    self.keyboardController = [[JSQMessagesKeyboardController alloc] initWithTextView:self.inputToolbar.contentView.textView contextView:self.view panGestureRecognizer:self.collectionView.panGestureRecognizer delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidBeginEditing)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isKeyboardImagePickerViewActive) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    }
}

- (void)textViewTextDidBeginEditing {
    [self hideKeyboardImagePickerView:YES];
}

#pragma mark - JSQMessagesKeyboardControllerDelegate

- (void)keyboardController:(JSQMessagesKeyboardController *)keyboardController keyboardDidChangeFrame:(CGRect)keyboardFrame {
    if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
        return;
    }
    
    // when the keyboard  image picker is about to appear,
    // the `inputToolbar` should not be moved.
    // so the keyboard can be dismissed and make room for the picker.
    if (self.isKeyboardImagePickerViewActive) {
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

- (void)showKeyboardImagePickerView:(BOOL)animated {
    if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    }
    
    if (self.isKeyboardImagePickerViewActive) {
        return;
    }
    
    self.isKeyboardImagePickerViewActive = YES;
    
    if (self.keyboardImagePickerController == nil) {
        self.keyboardImagePickerController = [[KCKeyboardImagePickerController alloc] init];
        [self setupKeyboardImagePickerOptions];
        [self registerForPreviewingWithDelegate:self.keyboardImagePickerController sourceView:self.keyboardImagePickerController.imagePickerView];
    }
    
    self.keyboardImagePickerController.keyboardFrame = self.keyboardController.currentKeyboardFrame;
    [self.keyboardController.contextView addSubview:self.keyboardImagePickerController.imagePickerView];
    [self.keyboardController.contextView endEditing:YES];
    [self.keyboardImagePickerController showKeyboardImagePickerViewAnimated:animated];
}

- (void)hideKeyboardImagePickerView:(BOOL)animated {
    if (self.isKeyboardImagePickerViewActive == NO) {
        return;
    }
    [self.keyboardImagePickerController hideKeyboardImagePickerViewAnimated:animated];
    self.isKeyboardImagePickerViewActive = NO;
}

- (void)setupKeyboardImagePickerOptions {
    // option buttons
    for (NSUInteger i = 0; i < [self.imagePickerOptions.optionButtonTitles count]; i++) {
        NSString *currentOptionButtonTitle = [self.imagePickerOptions.optionButtonTitles objectAtIndex:i];
        
        // Add an action for the option button
        [self.keyboardImagePickerController addAction:[KCKeyboardImagePickerAction actionWithOptionButtonTag:i title:currentOptionButtonTitle forceTouchEnabled:[[self.imagePickerOptions.forceTouchEnabledFlags objectAtIndex:i] boolValue] handler:^(UIImage *selectedImage) {
            if ([currentOptionButtonTitle isEqualToString:@"Send"]) {
                JSQPhotoMediaItem *photoMediaItem = [[JSQPhotoMediaItem alloc] initWithImage:selectedImage];
                JSQMessage *newImageMessage = [JSQMessage messageWithSenderId:self.senderId displayName:self.senderDisplayName media:photoMediaItem];
                [self.demoMessages addObject:newImageMessage];
                [self finishSendingMessageAnimated:YES];
            }
        }]];
        
        // Add a style for the option button
        [self.keyboardImagePickerController addStyle:[KCKeyboardImagePickerStyle styleWithOptionButtonTag:i titleColor:self.imagePickerOptions.optionButtonTitleColors[i] backgroundColor:self.imagePickerOptions.optionButtonColors[i]]];
    }
    
    // image picker controller button
    if (self.imagePickerOptions.isImagePickerControllerButtonVisible) {
        // Add an action for the image picker controller button
        [self.keyboardImagePickerController addAction:[KCKeyboardImagePickerAction actionWithImagePickerControllerButtonParentViewController:self handler:^(UIImage *selectedImage) {
            JSQPhotoMediaItem *photoMediaItem = [[JSQPhotoMediaItem alloc] initWithImage:selectedImage];
            JSQMessage *newImageMessage = [JSQMessage messageWithSenderId:self.senderId displayName:self.senderDisplayName media:photoMediaItem];
            [self.demoMessages addObject:newImageMessage];
            [self finishSendingMessageAnimated:YES];
        }]];
        
        // Add a style for the image picker controller button
        [self.keyboardImagePickerController addStyle:[KCKeyboardImagePickerStyle styleWithImagePickerControllerBackgroundColor:self.imagePickerOptions.imagePickerControllerButtonColor image:[UIImage imageNamed:@"ImagePickerControllerButtonIcon"]]];
    }
}


// ================================================================================= \\
// All methods below this point are copied from the JSQMessagesViewController Demo.  \\
// As mentioned in the README, this is just a demo of KCKeyboardImagePicker \\
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
    if (self.isKeyboardImagePickerViewActive) {
        [self hideKeyboardImagePickerView:YES];
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    } else {
        [self showKeyboardImagePickerView:YES];
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
