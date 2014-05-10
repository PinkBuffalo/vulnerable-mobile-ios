//
//  VLNRColor.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//---------------------------------------------
/* RGB color macro */
//---------------------------------------------
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//---------------------------------------------
/* RGB color macro with alpha */
//---------------------------------------------
#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define FACEBOOK_BLUE UIColorFromRGB(0x4C66A4)

@interface VLNRColor : UIColor

//---------------------------------------------
/* Primary colors */
//---------------------------------------------
+ (UIColor *)lightBlueColor;
+ (UIColor *)lightBlueTextColor;
+ (UIColor *)blueColor;
+ (UIColor *)lightTealColor;
+ (UIColor *)lightTealTextColor;
+ (UIColor *)tealColor;

//---------------------------------------------
/* Secondary colors */
//---------------------------------------------
+ (UIColor *)lightGrayColor;
+ (UIColor *)grayColor;
+ (UIColor *)grayTextColor;
+ (UIColor *)darkGrayColor;

//---------------------------------------------
/* Gradient layers */
//---------------------------------------------
+ (CAGradientLayer *)blueToTealGradient;
+ (CAGradientLayer *)tealToBlueGradient;

@end
