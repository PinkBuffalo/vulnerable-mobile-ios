//
//  VLNRABLEColor.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "VLNRABLEColor.h"

@implementation VLNRABLEColor

#pragma mark - Primary colors
+ (UIColor *)blueColor
{
	return UIColorFromRGB(0x0087A9);
}

+ (UIColor *)tealColor
{
	return UIColorFromRGB(0x00A3A9);
}

#pragma mark - Secondary colors
+ (UIColor *)lightGrayColor
{
	return UIColorFromRGB(0xADADAD);
}

+ (UIColor *)grayColor
{
	return UIColorFromRGB(0xCCCCCC);
}

+ (UIColor *)darkGrayColor
{
	return UIColorFromRGB(0x454545);
}

#pragma mark - Gradient layers
+ (CAGradientLayer *)blueToTealGradient
{
	NSArray *colors = @[ (id)[VLNRABLEColor blueColor].CGColor,
						 (id)[VLNRABLEColor tealColor].CGColor ];

	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.colors = colors;

	return gradientLayer;
}

+ (CAGradientLayer *)tealToBlueGradient
{
	NSArray *colors = @[ (id)[VLNRABLEColor tealColor].CGColor,
						 (id)[VLNRABLEColor blueColor].CGColor ];

	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.colors = colors;

	return gradientLayer;
}

@end
