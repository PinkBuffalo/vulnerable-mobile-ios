//
//  VLNRABLEColor.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface VLNRABLEColor : UIColor

//---------------------------------------------
/* Primary colors */
//---------------------------------------------
+ (UIColor *)blueColor;
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
