//
//  UILabel+VLNRAdditions.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VLNRAdditions)

- (id)initWithTextColor:(UIColor *)textColor
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines;

- (id)initWithTextColor:(UIColor *)textColor
				   font:(UIFont *)font
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines;

- (id)initWithTextColor:(UIColor *)textColor
        backgroundColor:(UIColor *)backgroundColor
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines;

- (id)initWithTextColor:(UIColor *)textColor
        backgroundColor:(UIColor *)backgroundColor
				   font:(UIFont *)font
          textAlignment:(NSTextAlignment)textAlignment
          numberOfLines:(NSInteger)numberOfLines;

@end
