//  Copyright (c) 2014 VLNRABLE. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LogInViewTextFieldTags) {
	LogInViewEmailTextFieldTag = 8000,
	LogInViewPasswordTextFieldTag
};

@interface LogInView : UIView

@property (nonatomic, readwrite) CGFloat buttonHeight;
@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat switchHeight;
@property (nonatomic, readwrite) CGFloat switchWidth;
@property (nonatomic, readwrite) CGFloat textFieldHeight;

@property (nonatomic, strong, readonly) UIButton *facebookButton;
@property (nonatomic, strong, readonly) UIButton *logInButton;
@property (nonatomic, strong, readonly) UILabel *logInLabel;
@property (nonatomic, strong, readonly) UILabel *forgotPasswordLabel;
@property (nonatomic, strong, readonly) UILabel *signUpLabel;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UITextField *emailTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;

- (id)initWithDelegate:(id<UIScrollViewDelegate, UITextFieldDelegate>)delegate;

@end
