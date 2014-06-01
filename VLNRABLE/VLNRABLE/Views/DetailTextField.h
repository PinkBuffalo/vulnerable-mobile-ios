//
//  DetailTextField.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTextField : UITextField

@property (nonatomic, readwrite) CGFloat padding;

@property (nonatomic, readonly, strong) UILabel *textLabel;

@end
