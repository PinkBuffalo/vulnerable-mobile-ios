//  Copyright (c) 2014 VLNRABLE. All rights reserved.

#import "LogInView.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextField+VLNRAdditions.h"
#import "UILabel+VLNRAdditions.h"

#define SIGN_UP_COPY @"New to VLNRABLE? Sign up."

@interface LogInView ()

@property (nonatomic, strong, readwrite) UIButton *facebookButton;
@property (nonatomic, strong, readwrite) UIButton *logInButton;
@property (nonatomic, strong, readwrite) UILabel *logInLabel;
@property (nonatomic, strong, readwrite) UILabel *forgotPasswordLabel;
@property (nonatomic, strong, readwrite) UILabel *signUpLabel;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UITextField *emailTextField;
@property (nonatomic, strong, readwrite) UITextField *passwordTextField;

@end

@implementation LogInView

- (id)initWithDelegate:(id<UIScrollViewDelegate,UITextFieldDelegate>)delegate
{
    if (self = [super init]) {
		self.backgroundColor = [UIColor whiteColor];

		_buttonHeight = 50.0f;
		_padding = 5.0f;
		_switchHeight = 44.0f;
		_switchWidth = 60.0f;
		_textFieldHeight = 44.0f;

		_scrollView = [[UIScrollView alloc] init];
		_scrollView.delegate = delegate;

		_facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_facebookButton setTitle:@"Log In With Facebook" forState:UIControlStateNormal];
		[_facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_facebookButton.backgroundColor = FACEBOOK_BLUE;
		_facebookButton.layer.cornerRadius = _buttonHeight / 2.0f;

		_logInLabel = [[UILabel alloc] initWithTextColor:[VLNRColor lightGrayColor]
													font:[VLNRAppManager systemFont]
										   textAlignment:NSTextAlignmentCenter
										   numberOfLines:1];
		_logInLabel.text = @"or log in with your email address";

		_emailTextField = [[UITextField alloc] initWithDelegate:delegate
													placeholder:@"Email Address"];
		_emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
		_emailTextField.returnKeyType = UIReturnKeyNext;
		_emailTextField.tag = LogInViewEmailTextFieldTag;

		_passwordTextField = [[UITextField alloc] initWithDelegate:delegate
													   placeholder:@"Password"];
		_passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_passwordTextField.secureTextEntry = YES;
		_passwordTextField.returnKeyType = UIReturnKeyDone;
		_passwordTextField.tag = LogInViewPasswordTextFieldTag;

		_forgotPasswordLabel = [[UILabel alloc] initWithTextColor:[VLNRColor blueColor]
															 font:[VLNRAppManager systemFont]
													textAlignment:NSTextAlignmentLeft
													numberOfLines:1];
		_forgotPasswordLabel.text = @"Forgot Password";

		_logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_logInButton setTitle:@"Log In" forState:UIControlStateNormal];
		[_logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_logInButton.backgroundColor = [VLNRColor blueColor];
		_logInButton.layer.cornerRadius = _buttonHeight / 2.0f;

		_signUpLabel = [[UILabel alloc] initWithTextColor:[VLNRColor lightGrayColor]
													 font:[VLNRAppManager systemFont]
											textAlignment:NSTextAlignmentCenter
											numberOfLines:1];

		NSMutableAttributedString *signUpText = [[NSMutableAttributedString alloc] initWithString:SIGN_UP_COPY];
		NSRange signUpRange = [SIGN_UP_COPY rangeOfString:@"Sign up"];
		[signUpText addAttributes:@{ NSForegroundColorAttributeName: [VLNRColor tealColor] }
						   range:signUpRange];
		_signUpLabel.attributedText = signUpText;

		[_scrollView addSubview:_logInLabel];
		[_scrollView addSubview:_emailTextField];
		[_scrollView addSubview:_passwordTextField];
		[_scrollView addSubview:_forgotPasswordLabel];
		[_scrollView addSubview:_signUpLabel];
		[_scrollView addSubview:_facebookButton];
		[_scrollView addSubview:_logInButton];

		[self addSubview:_scrollView];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	_scrollView.frame = bounds;

	CGRect insetBounds = CGRectInset(bounds, (_padding * 4.0f), (_padding * 4.0f));

	CGFloat xOrigin = insetBounds.origin.x;
	CGFloat yOrigin = insetBounds.origin.y + (_padding * 2.0f);

	_facebookButton.frame = CGRectMake(xOrigin,
									   yOrigin,
									   insetBounds.size.width,
									   _buttonHeight);

	yOrigin += _facebookButton.frame.size.height + (_padding * 8.0f);

	CGSize logInLabelSize = [_logInLabel.text sizeWithAttributes:@{ NSFontAttributeName: _logInLabel.font }];

	_logInLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetBounds.size.width,
								   logInLabelSize.height);

	yOrigin += _logInLabel.frame.size.height + (_padding * 8.0f);

	_emailTextField.frame = CGRectMake(xOrigin,
									   yOrigin,
									   insetBounds.size.width,
									   _textFieldHeight);

	yOrigin += _emailTextField.frame.size.height + (_padding * 2.0f);

	_passwordTextField.frame = CGRectMake(xOrigin,
										  yOrigin,
										  insetBounds.size.width,
										  _textFieldHeight);

	yOrigin += _passwordTextField.frame.size.height + (_padding * 3.0f);

	CGSize forgotPasswordLabelSize = [_forgotPasswordLabel.text sizeWithAttributes:@{ NSFontAttributeName: _forgotPasswordLabel.font }];

	_forgotPasswordLabel.frame = CGRectMake(xOrigin,
											yOrigin,
											insetBounds.size.width,
											forgotPasswordLabelSize.height);

	yOrigin += _forgotPasswordLabel.frame.size.height + (_padding * 10.0f);

	_logInButton.frame = CGRectMake(xOrigin,
									yOrigin,
									insetBounds.size.width,
									_buttonHeight);

	yOrigin += _logInButton.frame.size.height + (_padding * 4.0f);

	CGSize signUpLabelSize = [_signUpLabel.text sizeWithAttributes:@{ NSFontAttributeName: _signUpLabel.font }];

	_signUpLabel.frame = CGRectMake(xOrigin,
									yOrigin,
									insetBounds.size.width,
									signUpLabelSize.height);

	yOrigin += _signUpLabel.frame.size.height + (_padding * 4.0f);
	_scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, yOrigin);
}

@end
