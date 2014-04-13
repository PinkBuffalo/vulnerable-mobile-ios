//
//  StoryTableViewCell.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "StoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+VLNRLabel.h"

@interface StoryTableViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *clockImageView;
@property (nonatomic, strong, readwrite) UIImageView *heartImageView;
@property (nonatomic, strong, readwrite) UIImageView *starImageView;
@property (nonatomic, strong, readwrite) UIImageView *storyImageView;
@property (nonatomic, strong, readwrite) UIImageView *visibilityImageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *timeLabel;
@property (nonatomic, strong, readwrite) UILabel *storyLabel;
@property (nonatomic, strong, readwrite) UILabel *categoryLabel;

@end

@implementation StoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.backgroundColor = [UIColor whiteColor];

		_padding = 5.0f;
		_storyImageWidthAndHeight = 44.0f;

		_storyImageView = [[UIImageView alloc] init];
		_storyImageView.backgroundColor = [VLNRColor lightTealColor];

		_storyImageView.layer.borderColor = [VLNRColor blueColor].CGColor;
		_storyImageView.layer.borderWidth = 1.0f;
		_storyImageView.layer.cornerRadius = 4.0f;

		_titleLabel = [[UILabel alloc] initWithTextColor:[VLNRColor blueColor]
													font:VLNRABLE_DEFAULT_FONT_SIZE
										   textAlignment:NSTextAlignmentLeft
										   numberOfLines:1];

		_timeLabel = [[UILabel alloc] initWithTextColor:[VLNRColor grayColor]
												   font:VLNRABLE_DEFAULT_FONT_SIZE
										  textAlignment:NSTextAlignmentRight
										  numberOfLines:1];

		_storyLabel = [[UILabel alloc] initWithTextColor:[UIColor blackColor]
													font:VLNRABLE_DEFAULT_FONT_SIZE
										   textAlignment:NSTextAlignmentLeft
										   numberOfLines:3];

		_categoryLabel = [[UILabel alloc] initWithTextColor:[VLNRColor grayColor]
													   font:VLNRABLE_DEFAULT_FONT_SIZE
											  textAlignment:NSTextAlignmentLeft
											  numberOfLines:1];

		[self.contentView addSubview:_storyImageView];
		[self.contentView addSubview:_timeLabel];
		[self.contentView addSubview:_storyLabel];
		[self.contentView addSubview:_categoryLabel];
		[self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.contentView.bounds;
	CGRect insetBounds = CGRectInset(bounds, (_padding * 2.0f), (_padding * 2.0f));

	CGFloat xOrigin = insetBounds.origin.x;
	CGFloat yOrigin = insetBounds.origin.y;

	_storyImageView.frame = CGRectMake(xOrigin,
									   yOrigin,
									   _storyImageWidthAndHeight,
									   _storyImageWidthAndHeight);

	xOrigin += _storyImageView.frame.size.width + (_padding * 2.0f);

	CGFloat insetWidth = insetBounds.size.width - xOrigin + (_padding * 2.0f);

	CGSize titleLabelSize = [_titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: _titleLabel.font }];

	_titleLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetWidth,
								   titleLabelSize.height);

	CGSize timeLabelSize = [_timeLabel.text sizeWithAttributes:@{ NSFontAttributeName: _timeLabel.font }];

	_timeLabel.frame = CGRectMake(xOrigin,
								  yOrigin,
								  insetWidth,
								  timeLabelSize.height);

	yOrigin += _titleLabel.frame.size.height + (_padding * 1.5f);

	CGSize storyLabelSize = [_storyLabel.text sizeWithAttributes:@{ NSFontAttributeName: _storyLabel.font }];

	_storyLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   insetWidth,
								   (storyLabelSize.height * 3.0f));

	yOrigin += _storyLabel.frame.size.height + (_padding * 1.5f);

	CGSize categoryLabelSize = [_categoryLabel.text sizeWithAttributes:@{ NSFontAttributeName: _categoryLabel.font }];

	_categoryLabel.frame = CGRectMake(xOrigin,
									  yOrigin,
									  insetWidth,
									  categoryLabelSize.height);
}

+ (CGFloat)height
{
	return 100.0f;
}

@end
