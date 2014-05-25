//
//  DetailTableViewCell.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/25/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UILabel+VLNRAdditions.h"

@implementation DetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_padding = 5.0f;
		_titleLabel = [[UILabel alloc] initWithTextColor:[UIColor blackColor]
													font:[VLNRAppManager boldSystemFont]
										   textAlignment:NSTextAlignmentLeft
										   numberOfLines:1];

		_contentLabel = [[UILabel alloc] initWithTextColor:[VLNRColor blueColor]
													  font:[VLNRAppManager systemFont]
											 textAlignment:NSTextAlignmentLeft
											 numberOfLines:1];

		[self.contentView addSubview:_titleLabel];
		[self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = CGRectInset(self.bounds, (_padding * 2.0f), 0.0f);

	if (!_contentLabel.text) {
		_contentLabel = nil;
		_titleLabel.frame = bounds;
		return;
	}

	CGFloat xOrigin = bounds.origin.x;
	CGFloat yOrigin = bounds.origin.y;

	_titleLabel.frame = CGRectMake(xOrigin,
								   yOrigin,
								   (bounds.size.width / 3.0f),
								   bounds.size.height);

	xOrigin += _titleLabel.frame.size.width;

	_contentLabel.frame = CGRectMake(xOrigin,
									 yOrigin,
									 bounds.size.width - xOrigin,
									 bounds.size.height);
}

+ (CGFloat)height
{
	return 40.0f;
}

@end
