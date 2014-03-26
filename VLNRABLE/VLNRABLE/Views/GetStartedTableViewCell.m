//
//  GetStartedTableViewCell.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/25/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "GetStartedTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface GetStartedTableViewCell ()

@property (strong, nonatomic, readwrite) UIView *contentInsetView;
@property (strong, nonatomic, readwrite) UIImageView *leftImageView;
@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UILabel *detailLabel;

@end

@implementation GetStartedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.backgroundColor = [UIColor clearColor];
		self.backgroundView = nil;
		self.selectedBackgroundView = nil;
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		_padding = 5.0f;

		_contentInsetView = [[UIView alloc] init];
		_contentInsetView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.33f];
		_contentInsetView.layer.cornerRadius = 6.0f;

		_leftImageView = [[UIImageView alloc] initWithImage:nil];
		_leftImageView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
		_leftImageView.contentMode = UIViewContentModeScaleAspectFit;

		_titleLabel = [[UILabel alloc] init];
		_titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0f];
		_titleLabel.textColor = [UIColor whiteColor];

		_detailLabel = [[UILabel alloc] init];
		_detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
		_detailLabel.textColor = [UIColor whiteColor];
		_detailLabel.numberOfLines = 3;

		[_contentInsetView addSubview:_detailLabel];
		[_contentInsetView addSubview:_titleLabel];
		[_contentInsetView addSubview:_leftImageView];
		[self.contentView addSubview:_contentInsetView];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	_contentInsetView.frame = CGRectInset(bounds, (_padding * 4.0f), (_padding * 1.5f));

	CGSize contentInsetViewSize = _contentInsetView.bounds.size;

	CGFloat xOrigin = _contentInsetView.bounds.origin.x + (_padding * 1.5);
	CGFloat yOrigin = _contentInsetView.bounds.origin.y + (_padding * 1.5f);

	CGFloat imageViewWidthAndHeight = _contentInsetView.bounds.size.height - (_padding * 3.0f);

	_leftImageView.frame = CGRectMake(xOrigin,
									  yOrigin,
									  imageViewWidthAndHeight,
									  imageViewWidthAndHeight);

	xOrigin += imageViewWidthAndHeight + (_padding * 1.5f);

	CGSize titleLabelSize = [_titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];

	_titleLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   contentInsetViewSize.width - xOrigin,
								   titleLabelSize.height);

	yOrigin += titleLabelSize.height + (_padding / 2.0f);

	CGSize detailLabelSize = [_detailLabel.text sizeWithAttributes:@{ NSFontAttributeName: _detailLabel.font }];

	_detailLabel.frame = CGRectMake(xOrigin,
									yOrigin,
									contentInsetViewSize.width - xOrigin - _padding,
									(detailLabelSize.height * 3.0f));
}

+ (CGFloat)height
{
	return 90.0f;
}

@end
