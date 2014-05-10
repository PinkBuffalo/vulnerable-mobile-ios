//  Copyright (c) 2014 VLNRABLE. All rights reserved.

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

typedef NS_ENUM(NSUInteger, SignUpViewTextFieldTags) {
	SignUpViewNameTextFieldTag = 8000,
	SignUpViewEmailTextFieldTag,
	SignUpVeiewPasswordTextFieldTag
};

@interface SignUpView : UIView

@property (nonatomic, readwrite) CGFloat buttonHeight;
@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat switchHeight;
@property (nonatomic, readwrite) CGFloat switchWidth;
@property (nonatomic, readwrite) CGFloat textFieldHeight;

@property (nonatomic, strong, readonly) UIButton *facebookButton;
@property (nonatomic, strong, readonly) UIButton *signUpButton;
@property (nonatomic, strong, readonly) UILabel *ageLabel;
@property (nonatomic, strong, readonly) TTTAttributedLabel *legalLabel;
@property (nonatomic, strong, readonly) UILabel *logInLabel;
@property (nonatomic, strong, readonly) UILabel *signUpLabel;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UISwitch *ageSwitch;
@property (nonatomic, strong, readonly) UITextField *nameTextField;
@property (nonatomic, strong, readonly) UITextField *emailTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;

- (id)initWithDelegate:(id<UIScrollViewDelegate, UITextFieldDelegate, TTTAttributedLabelDelegate>)delegate;

@end
