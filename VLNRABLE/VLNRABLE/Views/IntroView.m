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

@property (strong, nonatomic, readwrite) UIImageView *logoView;
@property (strong, nonatomic, readwrite) UIButton *logInButton;
@property (strong, nonatomic, readwrite) UIButton *signUpButton;
@property (strong, nonatomic, readwrite) UILabel *learnMoreLabel;
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
		_buttonHeight = 44.0f;

		_headerGradient = [VLNRABLEColor tealToBlueGradient];

		_headerView = [[UIView alloc] init];
		_headerView.backgroundColor = [UIColor clearColor];

		_logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vlnrable_logo"]];
		_logoView.contentMode = UIViewContentModeScaleAspectFit;

		_logoView.layer.shadowColor = [UIColor blackColor].CGColor;
		_logoView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_logoView.layer.shadowOpacity = 0.33f;
		_logoView.layer.shadowRadius = 1.0f;

		_footerView = [[UIView alloc] init];
		_footerView.backgroundColor = [UIColor whiteColor];

		_logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_logInButton setTitle:@"Log In" forState:UIControlStateNormal];
		_logInButton.backgroundColor = [VLNRABLEColor blueColor];

		_signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
		_signUpButton.backgroundColor = [VLNRABLEColor tealColor];

		_learnMoreLabel = [[UILabel alloc] init];
		_learnMoreLabel.backgroundColor = [UIColor clearColor];
		_learnMoreLabel.font = [UIFont systemFontOfSize:12.0f];
		_learnMoreLabel.textAlignment = NSTextAlignmentCenter;
		_learnMoreLabel.textColor = [VLNRABLEColor lightGrayColor];
		_learnMoreLabel.text = @"Learn more about VLNRABLE   ";

		[self addSubview:_headerView];
		[self addSubview:_logoView];

		[_footerView addSubview:_logInButton];
		[_footerView addSubview:_signUpButton];
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

	_headerView.frame = CGRectMake(xOrigin,
								   yOrigin,
								   bounds.size.width,
								   bounds.size.width);

	_headerGradient.frame = _headerView.bounds;
	[_headerView.layer addSublayer:_headerGradient];

	_logoView.frame = CGRectInset(_headerView.bounds, (_padding * 12.0f), (_padding * 12.0f));

	UIEdgeInsets headerViewEdgeInsets = UIEdgeInsetsMake(_headerView.frame.size.height + (_padding * 12.0f), 0.0f, (_padding * 4.0f), 0.0f);

	_footerView.frame = UIEdgeInsetsInsetRect(bounds, headerViewEdgeInsets);

	CGRect footerViewInset = CGRectInset(_footerView.bounds, _padding * 4.0f, 0.0);

	xOrigin = footerViewInset.origin.x;
	yOrigin = footerViewInset.origin.y;

	_logInButton.frame = CGRectMake(xOrigin,
									yOrigin,
									footerViewInset.size.width,
									_buttonHeight);

	yOrigin += _buttonHeight + (_padding * 4.0f);

	_signUpButton.frame = CGRectMake(xOrigin,
									 yOrigin,
									 footerViewInset.size.width,
									 _buttonHeight);

	CGFloat learnMoreLabelHeight = [_learnMoreLabel.text sizeWithAttributes:@{ NSFontAttributeName: _learnMoreLabel.font }].height;

	_learnMoreLabel.frame = CGRectMake(xOrigin,
									   _footerView.frame.size.height - learnMoreLabelHeight,
									   footerViewInset.size.width,
									   learnMoreLabelHeight);
}

@end
