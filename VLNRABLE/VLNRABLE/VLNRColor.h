//
//  VLNRColor.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define FACEBOOK_BLUE UIColorFromRGB(0x4C66A4)

@interface VLNRColor : UIColor

//---------------------------------------------
/* Primary colors */
//---------------------------------------------
+ (UIColor *)blueColor;
+ (UIColor *)lightTealColor;
+ (UIColor *)lightTealTextColor;
+ (UIColor *)tealColor;

//---------------------------------------------
/* Secondary colors */
//---------------------------------------------
+ (UIColor *)lightGrayColor;
+ (UIColor *)grayColor;
+ (UIColor *)darkGrayColor;

//---------------------------------------------
/* Gradient layers */
//---------------------------------------------
+ (CAGradientLayer *)blueToTealGradient;
+ (CAGradientLayer *)tealToBlueGradient;

@end
