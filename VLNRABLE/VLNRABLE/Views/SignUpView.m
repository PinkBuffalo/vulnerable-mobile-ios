//  Copyright (c) 2014 VLNRABLE. All rights reserved.

#import "SignUpView.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextField+VLNRAdditions.h"
#import "UILabel+VLNRAdditions.h"

#define LOG_IN_COPY @"Already a member? Log in."
#define LEGAL_COPY @"By joining VLNRABLE, you will receive our email notifications. You may unsubscribe at any time.\n\nTerms of Use | Privacy Policy"
#define TERMS_OF_USE_URL @"http://www.pxpgraphics.com/"
#define PRIVACY_POLICY_URL @"http://www.pxpgraphics.com/"

@interface SignUpView ()

@property (nonatomic, strong, readwrite) UIButton *facebookButton;
@property (nonatomic, strong, readwrite) UIButton *signUpButton;
@property (nonatomic, strong, readwrite) UILabel *ageLabel;
@property (nonatomic, strong, readwrite) TTTAttributedLabel *legalLabel;
@property (nonatomic, strong, readwrite) UILabel *logInLabel;
@property (nonatomic, strong, readwrite) UILabel *signUpLabel;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UISwitch *ageSwitch;
@property (nonatomic, strong, readwrite) UITextField *nameTextField;
@property (nonatomic, strong, readwrite) UITextField *emailTextField;
@property (nonatomic, strong, readwrite) UITextField *passwordTextField;

@end

@implementation SignUpView

- (id)initWithDelegate:(id<UIScrollViewDelegate, UITextFieldDelegate, TTTAttributedLabelDelegate>)delegate
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
		[_facebookButton setTitle:@"Sign Up With Facebook" forState:UIControlStateNormal];
		[_facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_facebookButton.backgroundColor = FACEBOOK_BLUE;
		_facebookButton.layer.cornerRadius = _buttonHeight / 2.0f;

		_signUpLabel = [[UILabel alloc] initWithTextColor:[VLNRColor lightGrayColor]
													 font:[VLNRAppManager systemFont]
											textAlignment:NSTextAlignmentCenter
											numberOfLines:1];
		_signUpLabel.text = @"or sign up with your email address";

		_nameTextField = [[UITextField alloc] initWithDelegate:delegate
												   placeholder:@"First Name or Nickname"];
		_nameTextField.returnKeyType = UIReturnKeyNext;
		_nameTextField.tag = SignUpViewNameTextFieldTag;

		_emailTextField = [[UITextField alloc] initWithDelegate:delegate
													placeholder:@"Email Address"];
		_emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
		_emailTextField.returnKeyType = UIReturnKeyNext;
		_emailTextField.tag = SignUpViewEmailTextFieldTag;

		_passwordTextField = [[UITextField alloc] initWithDelegate:delegate
													   placeholder:@"Password"];
		_passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_passwordTextField.secureTextEntry = YES;
		_passwordTextField.returnKeyType = UIReturnKeyDone;
		_passwordTextField.tag = SignUpVeiewPasswordTextFieldTag;

		_ageLabel = [[UILabel alloc] initWithTextColor:[VLNRColor lightGrayColor]
												  font:[VLNRAppManager smallSystemFont]
										 textAlignment:NSTextAlignmentLeft
										 numberOfLines:1];
		_ageLabel.text = @"I am at least 13 years old:";

		_ageSwitch = [[UISwitch alloc] init];
		_ageSwitch.onTintColor = [VLNRColor tealColor];

		_signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
		[_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_signUpButton.backgroundColor = [VLNRColor blueColor];
		_signUpButton.layer.cornerRadius = _buttonHeight / 2.0f;

		_logInLabel = [[UILabel alloc] initWithTextColor:[VLNRColor lightGrayColor]
													font:[VLNRAppManager systemFont]
										   textAlignment:NSTextAlignmentCenter
										   numberOfLines:1];

		NSMutableAttributedString *logInText = [[NSMutableAttributedString alloc] initWithString:LOG_IN_COPY];
		NSRange logInRange = [LOG_IN_COPY rangeOfString:@"Log in"];
		[logInText addAttributes:@{ NSForegroundColorAttributeName: [VLNRColor tealColor] }
						   range:logInRange];
		_logInLabel.attributedText = logInText;

		_legalLabel = [[TTTAttributedLabel alloc] initWithTextColor:[VLNRColor lightGrayColor]
															   font:[VLNRAppManager smallSystemFont]
													  textAlignment:NSTextAlignmentCenter
													  numberOfLines:0];
		_legalLabel.delegate = delegate;
		_legalLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
		_legalLabel.text = LEGAL_COPY;

		NSMutableParagraphStyle *attributeStyle = [[NSMutableParagraphStyle alloc] init];
		attributeStyle.alignment = NSTextAlignmentCenter;

		NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName: [VLNRColor tealColor],
										  NSParagraphStyleAttributeName: attributeStyle };
		[_legalLabel setLinkAttributes:linkAttributes];

		NSRange termsOfUserRange = [LEGAL_COPY rangeOfString:@"Terms of Use"];
		[_legalLabel addLinkToURL:[NSURL URLWithString:TERMS_OF_USE_URL]
						withRange:termsOfUserRange];

		NSRange privacyRange = [LEGAL_COPY rangeOfString:@"Privacy Policy"];
		[_legalLabel addLinkToURL:[NSURL URLWithString:PRIVACY_POLICY_URL]
						withRange:privacyRange];

		[_scrollView addSubview:_signUpLabel];
		[_scrollView addSubview:_nameTextField];
		[_scrollView addSubview:_emailTextField];
		[_scrollView addSubview:_passwordTextField];
		[_scrollView addSubview:_ageLabel];
		[_scrollView addSubview:_ageSwitch];
		[_scrollView addSubview:_logInLabel];
		[_scrollView addSubview:_legalLabel];
		[_scrollView addSubview:_facebookButton];
		[_scrollView addSubview:_signUpButton];

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

	yOrigin += _facebookButton.frame.size.height + (_padding * 4.0f);

	CGSize signUpLabelSize = [_signUpLabel.text sizeWithAttributes:@{ NSFontAttributeName: _signUpLabel.font }];

	_signUpLabel.frame = CGRectMake(xOrigin,
									yOrigin,
									insetBounds.size.width,
									signUpLabelSize.height);

	yOrigin += _signUpLabel.frame.size.height + (_padding * 4.0f);

	_nameTextField.frame = CGRectMake(xOrigin,
									  yOrigin,
									  insetBounds.size.width,
									  _textFieldHeight);

	yOrigin += _nameTextField.frame.size.height + (_padding * 2.0f);

	_emailTextField.frame = CGRectMake(xOrigin,
									   yOrigin,
									   insetBounds.size.width,
									   _textFieldHeight);

	yOrigin += _emailTextField.frame.size.height + (_padding * 2.0f);

	_passwordTextField.frame = CGRectMake(xOrigin,
										  yOrigin,
										  insetBounds.size.width,
										  _textFieldHeight);

	yOrigin += _passwordTextField.frame.size.height + (_padding * 1.5f);

	_ageLabel.frame = CGRectMake(xOrigin,
								 yOrigin,
								 insetBounds.size.width,
								 _switchHeight);

	xOrigin = insetBounds.size.width - _switchWidth + xOrigin;
	yOrigin += (_padding * 1.5f);

	_ageSwitch.frame = CGRectMake(xOrigin,
								  yOrigin,
								  _switchWidth,
								  _switchHeight);

	xOrigin = insetBounds.origin.x;
	yOrigin += _switchHeight + _padding;

	_signUpButton.frame = CGRectMake(xOrigin,
									 yOrigin,
									 insetBounds.size.width,
									 _buttonHeight);

	yOrigin += _signUpButton.frame.size.height + (_padding * 4.0f);

	CGSize logInLabelSize = [_logInLabel.text sizeWithAttributes:@{ NSFontAttributeName: _logInLabel.font }];

	_logInLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetBounds.size.width,
								   logInLabelSize.height);

	yOrigin += _logInLabel.frame.size.height + (_padding * 4.0f);

	CGSize legalLabelSize = [_legalLabel.text sizeWithAttributes:@{ NSFontAttributeName: _legalLabel.font }];

	_legalLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetBounds.size.width,
								   (legalLabelSize.height * 2.0f));

	yOrigin += _legalLabel.frame.size.height + (_padding * 4.0f);
	_scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, yOrigin);
}

@end
