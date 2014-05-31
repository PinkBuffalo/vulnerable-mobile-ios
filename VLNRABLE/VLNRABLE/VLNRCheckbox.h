//
//  VLNRCheckbox.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLNRCheckbox : UIButton

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat checkboxWidthAndHeight;

@property (nonatomic, readonly, strong) UILabel *textLabel;
@property (nonatomic, readwrite, strong) NSString *text;
@property (nonatomic, getter = isChecked) BOOL checked;

@end
