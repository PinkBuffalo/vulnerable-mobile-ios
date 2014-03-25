//
//  IntroView.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "IntroView.h"
#import <QuartzCore/QuartzCore.h>

@interface IntroView ()

@property (strong, nonatomic, readwrite) UIImageView *logoImageView;
@property (strong, nonatomic, readwrite) UIButton *logInButton;
@property (strong, nonatomic, readwrite) UIButton *signUpButton;
@property (strong, nonatomic, readwrite) UILabel *learnMoreLabel;
@property (strong, nonatomic, readwrite) UIImageView *arrowImageView;
@property (strong, nonatomic, readwrite) UIView *headerView;
@property (strong, nonatomic, readwrite) CAGradientLayer *headerGradient;
@property (strong, nonatomic, readwrite) UIView *footerView;

@end

@implementation IntroView

- (id)init
{
    if (self == [super init]) {
		self.backgroundColor = [UIColor whiteColor];

		_padding = 5.0f;
		_buttonHeight = 50.0f;

		_headerGradient = [VLNRABLEColor tealToBlueGradient];

		_headerView = [[UIView alloc] init];
		_headerView.backgroundColor = [UIColor clearColor];
		[_headerView.layer addSublayer:_headerGradient];

		_logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vlnrable_logo"]];
		_logoImageView.contentMode = UIViewContentModeScaleAspectFit;
		_logoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
		_logoImageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_logoImageView.layer.shadowOpacity = 0.33f;
		_logoImageView.layer.shadowRadius = 1.0f;

		_footerView = [[UIView alloc] init];
		_footerView.backgroundColor = [UIColor whiteColor];

		_logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_logInButton setTitle:@"Log In" forState:UIControlStateNormal];
		_logInButton.backgroundColor = [VLNRABLEColor blueColor];
		_logInButton.layer.cornerRadius = _buttonHeight / 2.0f;

		_signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
		_signUpButton.backgroundColor = [VLNRABLEColor tealColor];
		_signUpButton.layer.cornerRadius = _buttonHeight / 2.0f;

		_learnMoreLabel = [[UILabel alloc] init];
		_learnMoreLabel.backgroundColor = [UIColor clearColor];
		_learnMoreLabel.font = [UIFont systemFontOfSize:11.0f];
		_learnMoreLabel.textAlignment = NSTextAlignmentCenter;
		_learnMoreLabel.textColor = [VLNRABLEColor lightGrayColor];
		_learnMoreLabel.text = @"Learn more about VLNRABLE   ";

		_arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
		_arrowImageView.contentMode = UIViewContentModeScaleAspectFit;

		[self addSubview:_headerView];
		[self addSubview:_logoImageView];

		[_footerView addSubview:_logInButton];
		[_footerView addSubview:_signUpButton];
		[_footerView addSubview:_arrowImageView];
		[_footerView addSubview:_learnMoreLabel];
		[self addSubview:_footerView];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	CGFloat xOrigin = bounds.origin.x;
	CGFloat yOrigin = bounds.origin.y;

	UIEdgeInsets footerEdgeInsets = UIEdgeInsetsMake((bounds.size.height / 2.0f), 0.0f, 0.0f, 0.0f);

	_footerView.frame = UIEdgeInsetsInsetRect(bounds, footerEdgeInsets);

	CGRect footerViewInset = CGRectInset(_footerView.bounds, (_padding * 4.0f), (_footerView.bounds.size.height / 4.0f));

	xOrigin = footerViewInset.origin.x;
	yOrigin = footerViewInset.origin.y;

	_logInButton.frame = CGRectMake(xOrigin,
									yOrigin,
									footerViewInset.size.width,
									_buttonHeight);

	yOrigin = _footerView.frame.origin.y - _buttonHeight - (_footerView.frame.size.height / 4.0f);

	_signUpButton.frame = CGRectMake(xOrigin,
									 yOrigin,
									 footerViewInset.size.width,
									 _buttonHeight);

	CGSize learnMoreLabelSize = [_learnMoreLabel.text sizeWithAttributes:@{ NSFontAttributeName: _learnMoreLabel.font }];

	xOrigin = (_footerView.frame.size.width - learnMoreLabelSize.width) / 2.0f;
	yOrigin = _footerView.frame.origin.y - learnMoreLabelSize.height - (_footerView.frame.size.height / 12.0f);

	_learnMoreLabel.frame = CGRectMake(xOrigin,
									   yOrigin,
									   learnMoreLabelSize.width,
									   learnMoreLabelSize.height);

	xOrigin = _learnMoreLabel.frame.origin.x + _learnMoreLabel.frame.size.width;
	yOrigin = _learnMoreLabel.frame.origin.y;

	_arrowImageView.frame = CGRectMake(xOrigin,
									   yOrigin,
									   learnMoreLabelSize.height,
									   learnMoreLabelSize.height);

	xOrigin = bounds.origin.x;
	yOrigin = bounds.origin.y;

	UIEdgeInsets headerEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, _footerView.frame.size.height, 0.0f);

	_headerView.frame = UIEdgeInsetsInsetRect(bounds, headerEdgeInsets);
	_headerGradient.frame = _headerView.bounds;

	_logoImageView.frame = CGRectInset(_headerView.bounds, (_headerView.bounds.size.width / 4.0f), (_headerView.bounds.size.height / 3.0f));
}

@end
