//
//  DetailTextField.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "DetailTextField.h"

@interface DetailTextField ()

@property (nonatomic, readwrite, strong) UILabel *textLabel;

@end

@implementation DetailTextField

- (id)init
{
    if (self = [super init]) {
        _padding = 5.0f;

		_textLabel = [[UILabel alloc] init];
		_textLabel.font = [VLNRAppManager boldSystemFont];
		[self addSubview:_textLabel];
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	[super textRectForBounds:bounds];

	bounds = CGRectInset(bounds, (bounds.size.width / 12.0f), 0.0f);
	return CGRectOffset(bounds, (bounds.size.width / 10.0f), 0.0f);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
	[super placeholderRectForBounds:bounds];

	return [self textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	[super editingRectForBounds:bounds];

	return [self textRectForBounds:bounds];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = CGRectInset(self.bounds, (_padding * 1.5f), _padding);

	CGFloat xOrigin = bounds.origin.x;
	CGFloat yOrigin = bounds.origin.y;

	_textLabel.frame = CGRectMake(xOrigin,
								  yOrigin,
								  bounds.size.width / 8.0f,
								  bounds.size.height);

	xOrigin += _textLabel.frame.size.width;
}

@end
