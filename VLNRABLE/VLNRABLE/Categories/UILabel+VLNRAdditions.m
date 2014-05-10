//
//  UILabel+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "UILabel+VLNRAdditions.h"

@implementation UILabel (VLNRAdditions)

- (id)initWithTextColor:(UIColor *)textColor
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines
{
	if (self == [super init]) {
		self.textColor = textColor;
		self.textAlignment = textAlignment;
		self.backgroundColor = [UIColor clearColor];
		self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		self.numberOfLines = numberOfLines;
	}
	return self;
}

- (id)initWithTextColor:(UIColor *)textColor
				   font:(UIFont *)font
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines
{
	if (self == [super init]) {
		self.textColor = textColor;
		self.textAlignment = textAlignment;
		self.backgroundColor = [UIColor clearColor];
		self.font = font;
		self.numberOfLines = numberOfLines;
	}
	return self;
}

- (id)initWithTextColor:(UIColor *)textColor
        backgroundColor:(UIColor *)backgroundColor
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines
{
	if (self == [super init]) {
		self.textColor = textColor;
		self.textAlignment = textAlignment;
		self.backgroundColor = backgroundColor;
		self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		self.numberOfLines = numberOfLines;
	}
	return self;
}

- (id)initWithTextColor:(UIColor *)textColor
        backgroundColor:(UIColor *)backgroundColor
				   font:(UIFont *)font
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines
{
	if (self == [super init]) {
		self.textColor = textColor;
		self.textAlignment = textAlignment;
		self.backgroundColor = backgroundColor;
		self.font = font;
		self.numberOfLines = numberOfLines;
	}
	return self;
}

+ (UIFont *)boldSmallSystemFont
{
	return [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
}

+ (UIFont *)boldSystemFont
{
	return [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
}

+ (UIFont *)smallSystemFont
{
	return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}

+ (UIFont *)systemFont
{
	return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}

@end
