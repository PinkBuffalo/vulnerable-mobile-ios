//
//  UITextField+VLNRTextField.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (VLNRTextField)

- (id)initWithDelegate:(id<UITextFieldDelegate>)delegate;
- (id)initWithDelegate:(id<UITextFieldDelegate>)delegate
		   placeholder:(NSString *)placeholder;

@end
