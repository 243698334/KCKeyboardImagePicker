# KCKeyboardImagePicker

[![Version](https://img.shields.io/cocoapods/v/KCKeyboardImagePicker.svg?style=flat)](http://cocoapods.org/pods/KCKeyboardImagePicker)
[![License](https://img.shields.io/cocoapods/l/KCKeyboardImagePicker.svg?style=flat)](http://cocoapods.org/pods/KCKeyboardImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/KCKeyboardImagePicker.svg?style=flat)](http://cocoapods.org/pods/KCKeyboardImagePicker)

Now support 3D Touch!

## Screenshots

![Demo](https://camo.githubusercontent.com/898bbe374accce9f4c51f1c628ff0b3150f6ba17/687474703a2f2f692e696d6775722e636f6d2f516a41415542392e676966)
![Screenshot2](https://raw.githubusercontent.com/Kev1nChen/KCKeyboardImagePicker/master/Screenshots/screenshot2.jpg)
![Screenshot3](https://raw.githubusercontent.com/Kev1nChen/KCKeyboardImagePicker/master/Screenshots/screenshot3.jpg)

## Documentation

Click [here](http://cocoadocs.org/docsets/KCKeyboardImagePicker) for full documentation. 

## Demo

To run the example project, clone the repo, and run `pod install` from the `Example` directory first.

## Usage

#### General Use

````objective-c
#import <KCKeyboardImagePicker/KCKeyboardImagePickerController.h>
````

- Display

Init the image picker controller by passing a reference to the view controller who owns the picker. Set a frame (usually the frame of the keyboard) to the `KCKeyboardImagePickerController`, and add the `imagePickerView` to a container. 
````objective-c
self.keyboardImagePickerController = [[KCKeyboardImagePickerController alloc] initWithParentViewController:self];
self.keyboardImagePickerController.keyboardFrame = self.keyboardController.currentKeyboardFrame;
[self.someContainerView addSubview:self.keyboardImagePickerController.imagePickerView];
````

- 3D Touch

KCKeyboardImagePicker supports 3D Touch's peek and pop action. Force Touching on an image will bring up a full-sized preview (instead of the cropped square one) of the image. The action sheet underneath the preview will contain selected options the same as the option buttons (see "Actions" section below). 
````objective-c
self.keyboardImagePickerController.forceTouchPreviewEnabled = YES;
````

- Actions

Here is an example to add an action for an option button. Set the `forceTouchEnabled` parameter to `YES` will add this option to the 3D Touch action sheet. Notice that you need to first set `forceTouchPreviewEnabled` to `YES` to display the action sheet. 
````objective-c
self.action = [KCKeyboardImagePickerAction actionWithOptionButtonTag:1 
                                                               title:@"Send" 
                                                   forceTouchEnabled:YES
                                                             handler:^(UIImage *selectedImage) {
    // do something with the `selectedImage`
}];
[self.keyboardImagePickerController addAction:self.action];
````
To add an action for the image picker controller button (the one on the bottom left corner to trigger the `UIImagePickerController`)
````objective-c
self.action = [KCKeyboardImagePickerAction actionactionWithImagePickerControllerButtonHandler:^(UIImage *selectedImage) {
    // do something with the `selectedImage`
}];
[self.keyboardImagePickerController addAction:self.action];
````
You can add up to four actions (namely four option buttons). Each action will be matched with an optional style (see the section below) by the `tag` number. 

- Styles

To add a style for an option button, 
````objective-c
self.style = [KCKeyboardImagePickerStyle styleWithOptionButtonTag:1
                                                       titleColor:[UIColor whiteColor]
                                                  backgroundColor:[UIColor lightGrayColor]];
[self.keyboardImagePickerController addStyle:self.style];
````
To add a style for the image picker controller button, 
````objective-c
self.style = [KCKeyboardImagePickerStyle styleWithImagePickerControllerButtonBackgroundColor:[UIColor lightGrayColor] 
                                                                                       image:[UIImage imageNamed:@"someImage"]];
[self.keyboardImagePickerController addStyle:self.style];
````

Each action can have only one style, which is matched by the `tag` number.

For different number of option buttons, the layout will be different. 

#### Integrate with `JSQMessagesViewController`
The demo included shows you how to integrate KCKeyboardImagePicker with the famous [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController). 

In your own subclass of the `JSQMessagesViewController` class, adopt the `JSQMessagesKeyboardControllerDelegate` protocol and override the `JSQKeyboardController` object.

````objective-c
@interface DemoMessagesViewController () <JSQMessagesKeyboardControllerDelegate>
````
````objective-c
self.keyboardController = [[JSQMessagesKeyboardController alloc] initWithTextView:self.inputToolbar.contentView.textView 
                                                                      contextView:self.view
                                                             panGestureRecognizer:self.collectionView.panGestureRecognizer
                                                                         delegate:self];
````
Next, implement the method in `JSQMessagesKeyboardControllerDelegate`. The first if branch is to avoid the reposition of the `inputToolbar` when the `textView` inside of it resigns from first responder in order to hide the keyboard and display the keyboard  image picker.
````objective-c
- (void)keyboardController:(JSQMessagesKeyboardController *)keyboardController keyboardDidChangeFrame:(CGRect)keyboardFrame {
if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
  return;
}
  // code for inputToolbar reposition... 
  // check the demo for details
}
````
Initializing the picker by using the `KCKeyboardImagePickerController`. You need to set the frame of the picker by assigning the current keyboard frame to `keyboardFrame` attribute. Don't forget to add the picker view to the `contextView` of the `keyboardController`. 
````objective-c
self.keyboardImagePickerController = [[KCKeyboardImagePickerController alloc] initWithParentViewController:self];
self.keyboardImagePickerController.keyboardFrame = self.keyboardController.currentKeyboardFrame;
[self.keyboardController.contextView addSubview:self.keyboardImagePickerController.imagePickerView];
````

Before showing the picker, you can end the editing mode of the `contextView` to hide the keyboard. 
````objective-c
[self.keyboardController.contextView endEditing:YES];
[self.keyboardImagePickerController showKeyboardImagePickerViewAnimated:animated];
````

To dismiss the picker, 
````objective-c
[self.keyboardImagePickerController hideKeyboardImagePickerViewAnimated:animated];
````

#### Without the default controller

Alternatively, you can have your own implementation to adopt `KCKeyboardImagePickerViewDataSource` and `KCKeyboardImagePickerViewDelegate`. Just do
````objective-c
#import <KCKeyboardImagePicker/KCKeyboardImagePickerView.h>
````
So you can customize the source of the images and other styles of the picker. 

## Installation

KCKeyboardImagePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

````ruby
pod 'KCKeyboardImagePicker'
````

## Author

Kev1nChen (Kevin Yufei Chen)

## License

KCKeyboardImagePicker is available under the MIT license. See the LICENSE file for more info.
