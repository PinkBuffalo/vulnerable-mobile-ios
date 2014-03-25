//
//  GetStartedView.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "GetStartedView.h"
#import <QuartzCore/QuartzCore.h>

@interface GetStartedView ()

@property (strong, nonatomic, readwrite) UIScrollView *scrollView;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UIButton *getStartedButton;
@property (strong, nonatomic, readwrite) CAGradientLayer *backgroundGradient;

@end

@implementation GetStartedView

- (id)init
{
	if (self = [super init]) {
		self.backgroundColor = [UIColor whiteColor];

		_padding = 5.0f;
		_buttonHeight = 50.0f;

		_backgroundGradient = [VLNRABLEColor tealToBlueGradient];
		[self.layer addSublayer:_backgroundGradient];

		_scrollView = [[UIScrollView alloc] init];

		_titleLabel = [[UILabel alloc] init];
		_titleLabel.text = @"Speak the truth.\nShare your secrets.\nHave no fear.";
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0f];
		_titleLabel.numberOfLines = 3;
		_titleLabel.adjustsFontSizeToFitWidth = YES;

		_getStartedButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
		[_getStartedButton setTitleColor:[VLNRABLEColor blueColor] forState:UIControlStateNormal];
		_getStartedButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.85f];
		_getStartedButton.layer.cornerRadius = _buttonHeight / 2.0f;

		[_scrollView addSubview:_titleLabel];
		[_scrollView addSubview:_getStartedButton];
		[self addSubview:_scrollView];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	_backgroundGradient.frame = bounds;
	_scrollView.frame = bounds;

	CGRect insetBounds = CGRectInset(bounds, (_padding * 4.0f), (_padding * 4.0f));

	CGFloat xOrigin = insetBounds.origin.x;
	CGFloat yOrigin = insetBounds.origin.y + (_padding * 6.0f);

	CGSize titleLabelSize = [_titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];

	_titleLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetBounds.size.width,
								   (titleLabelSize.height));

	yOrigin = insetBounds.origin.y + insetBounds.size.height - _buttonHeight;

	_getStartedButton.frame = CGRectMake(xOrigin,
										 yOrigin,
										 insetBounds.size.width,
										 _buttonHeight);
}

@end
