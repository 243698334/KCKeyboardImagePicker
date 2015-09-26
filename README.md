# KCKeyboardImagePicker

[![Version](https://img.shields.io/cocoapods/v/KCKeyboardImagePicker.svg?style=flat)](http://cocoapods.org/pods/KCKeyboardImagePicker)
[![License](https://img.shields.io/cocoapods/l/KCKeyboardImagePicker.svg?style=flat)](http://cocoapods.org/pods/KCKeyboardImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/KCKeyboardImagePicker.svg?style=flat)](http://cocoapods.org/pods/KCKeyboardImagePicker)

## Screenshots

![Screenshot1](https://raw.githubusercontent.com/Kev1nChen/KCKeyboardImagePicker/master/Screenshots/screenshot1.jpg)
![Screenshot2](https://raw.githubusercontent.com/Kev1nChen/KCKeyboardImagePicker/master/Screenshots/screenshot2.jpg)
![Screenshot3](https://raw.githubusercontent.com/Kev1nChen/KCKeyboardImagePicker/master/Screenshots/screenshot3.jpg)

## Documentation

Click [here](http://cocoadocs.org/docsets/KCKeyboardImagePicker) for full documentation. 

## Demo

To run the example project, clone the repo, and run `pod install` from the `Example` directory first.

## Usage

This demo shows you how to integrate KCKeyboardImagePicker with the famous [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController). 

First, you need to subclass `JSQMessagesViewController` and adopt `KCKeyboardImagePickerViewDataSource` and `KCKeyboardImagePickerViewDelegate` protocols. 
````objective-c
@interface DemoMessagesViewController : JSQMessagesViewController<KCKeyboardImagePickerViewDataSource, KCKeyboardImagePickerViewDelegate>
````

Then, in the `.m` file, the trick is to initialize your own `JSQKeyboardController` instead of using the one from the super class. 

Adopt the `JSQMessagesKeyboardControllerDelegate` protocol in the `@interface` line.
````objective-c
@interface DemoMessagesViewController () <JSQMessagesKeyboardControllerDelegate>
````
In `- (void)viewDidLoad`, initialize your own `keyboardController` and set delegate to `self`.
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
To bring up the picker, first initialize the picker and assign its `dataSource` and `delegate` to be `self`. Then add it to the `contextView` of the `keyboardController`.
````objective-c
if (self.keyboardImagePickerView == nil) {
  self.keyboardImagePickerView = [[KCKeyboardImagePickerView alloc] init];
  self.keyboardImagePickerView.dataSource = self;
  self.keyboardImagePickerView.delegate = self;
}
[self.keyboardController.contextView addSubview:self.keyboardImagePickerView];
[self.keyboardController.contextView bringSubviewToFront:self.keyboardImagePickerView];
````
Before showing the picker, simply end the editing mode of the `contextView` to hide the keyboard. But before that, you should save the current keyboard frame and assign it back to the picker. 
````objective-c
CGRect keyboardFrame = self.keyboardController.currentKeyboardFrame;
[self.keyboardController.contextView endEditing:YES];
[UIView animateWithDuration:0.25 animations:^{
  self.keyboardImagePickerView.frame = keyboardFrame;
}];
````
To dismiss the picker, just change its frame and move it under the screen. There are a lot of ways to do this.
````objective-c
[UIView animateWithDuration:0.25 animations:^{
  CGRect pickerFrame = self.keyboardImagePickerView.frame;
  pickerFrame.origin.y = pickerFrame.origin.y + pickerFrame.size.height;
  self.keyboardImagePickerView.frame = pickerFrame;
} completion:^(BOOL finished) {
  if (finished) {
    [self.keyboardImagePickerView removeFromSuperview];
  }
}]; 
````

If you are not using `JSQMessengesViewController`, you can get the size of the keyboard by listening to `UIKeyboardDidShowNotification`.
````objective-c
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardDidShow:)
                                             name:UIKeyboardDidShowNotification
                                           object:nil];

- (void)keyboardDidShow:(NSNotification *)notification {
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}
````

Finally, don't forget to implement the methods in `KCKeyboardImagePickerViewDataSource` and `KCKeyboardImagePickerViewDelegate`. So you can customize the color, title, and the number of the option buttons. 

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
