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

@property (strong, nonatomic, readwrite) UITableView *tableView;
@property (strong, nonatomic, readwrite) UIView *tableHeaderView;
@property (strong, nonatomic, readwrite) UIView *tableFooterView;
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

		_titleLabel = [[UILabel alloc] init];
		_titleLabel.text = @"Speak the truth.\nShare your secrets.\nHave no fear.";
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0f];
		_titleLabel.numberOfLines = 3;
		_titleLabel.adjustsFontSizeToFitWidth = YES;

		_tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
		[_tableHeaderView addSubview:_titleLabel];

		_tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];

		_getStartedButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
		[_getStartedButton setTitleColor:[VLNRABLEColor blueColor] forState:UIControlStateNormal];
		_getStartedButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.85f];
		_getStartedButton.layer.cornerRadius = _buttonHeight / 2.0f;

		[_tableFooterView addSubview:_getStartedButton];

		_tableView = [[UITableView alloc] init];
		_tableView.backgroundView = nil;
		_tableView.backgroundColor = [UIColor clearColor];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.tableHeaderView = _tableHeaderView;
		_tableView.tableFooterView = _tableFooterView;

		[self addSubview:_tableView];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	_backgroundGradient.frame = bounds;
	_tableView.frame = bounds;

	CGRect insetBounds = CGRectInset(bounds, (_padding * 4.0f), (_padding * 4.0f));

	CGFloat xOrigin = insetBounds.origin.x;
	CGFloat yOrigin = insetBounds.origin.y + (_padding * 2.0f);

	CGSize titleLabelSize = [_titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];

	_titleLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetBounds.size.width,
								   (titleLabelSize.height));

	_getStartedButton.frame = CGRectMake(xOrigin,
										 yOrigin,
										 insetBounds.size.width,
										 _buttonHeight);

//	UIEdgeInsets scrollViewEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, (_padding * 8.0f) + _buttonHeight, 0.0f);
//
//	_tableView.frame = UIEdgeInsetsInsetRect(bounds, scrollViewEdgeInsets);
//
//	CGRect insetBounds = CGRectInset(bounds, (_padding * 4.0f), (_padding * 4.0f));
//
//	CGFloat xOrigin = insetBounds.origin.x;
//	CGFloat yOrigin = insetBounds.origin.y + (_padding * 8.0f);
//
//	CGSize titleLabelSize = [_titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];
//
//	_titleLabel.frame = CGRectMake(xOrigin,
//								   yOrigin,
//								   insetBounds.size.width,
//								   (titleLabelSize.height));
//
//	yOrigin = insetBounds.origin.y + insetBounds.size.height - _buttonHeight;
//
//	_getStartedButton.frame = CGRectMake(xOrigin,
//										 yOrigin,
//										 insetBounds.size.width,
//										 _buttonHeight);
}

@end
