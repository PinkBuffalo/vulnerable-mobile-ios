//
//  WriteView.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/30/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteView : UIView

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat textFieldHeight;

@property (nonatomic, readonly, strong) UITextField *textField;
@property (nonatomic, readonly, strong) UITextView *textView;
@property (nonatomic, readonly, strong) UIToolbar *toolbar;

- (instancetype)initWithDelegate:(id<UITextFieldDelegate, UITextViewDelegate>)delegate;

@end
