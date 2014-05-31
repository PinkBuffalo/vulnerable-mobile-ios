//
//  WriteView.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/30/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextField.h"
#import "VLNRTextView.h"
#import "WriteToolbar.h"

@interface WriteView : UIView

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat textFieldHeight;

@property (nonatomic, readonly, strong) DetailTextField *textField;
@property (nonatomic, readonly, strong) VLNRTextView *textView;
@property (nonatomic, readonly, strong) WriteToolbar *toolbar;
@property (nonatomic, readonly, strong) UIScrollView *scrollView;

- (instancetype)initWithDelegate:(id<UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>)delegate;

@end
