//
//  VLNRCheckbox.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "VLNRCheckbox.h"

@interface VLNRCheckbox ()

@property (nonatomic, readwrite, strong) UILabel *textLabel;

@end

@implementation VLNRCheckbox

- (id)init
{
    if (self = [super init]) {
		[self setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
		[self setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateHighlighted];

		self.adjustsImageWhenDisabled = YES;
		self.adjustsImageWhenHighlighted = YES;

		_padding = 5.0f;
		_checkboxWidthAndHeight = 20.0f;
		_text = @"";

		_textLabel = [[UILabel alloc] init];
		_textLabel.font = [VLNRAppManager largeSystemFont];
		_textLabel.textColor = [VLNRColor lightGrayColor];
		_textLabel.text = _text;
		_textLabel.userInteractionEnabled = YES;

		[self addSubview:_textLabel];
    }
    return self;
}

- (void)setText:(NSString *)text
{
	_text = text;
	_textLabel.text = _text;
	[_textLabel sizeToFit];
	self.bounds = _textLabel.bounds;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	_checked = selected;

	_textLabel.textColor = selected ? [VLNRColor tealColor] : [VLNRColor lightGrayColor];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	CGFloat xOrigin = bounds.origin.x;
	CGFloat yOrigin = bounds.origin.y;

	xOrigin += _checkboxWidthAndHeight + (_padding * 2.0f);

	CGSize textLabelSize = [_textLabel.text sizeWithAttributes:@{ NSFontAttributeName: _textLabel.font }];

	_textLabel.frame = CGRectMake(xOrigin,
								  yOrigin,
								  textLabelSize.width,
								  textLabelSize.height);

	xOrigin -= (_textLabel.frame.size.width / 4.0f);

	self.imageView.frame = CGRectMake(xOrigin,
									  yOrigin,
									  _checkboxWidthAndHeight,
									  _checkboxWidthAndHeight);
}

@end
