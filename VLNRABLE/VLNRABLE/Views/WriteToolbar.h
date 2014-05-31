//
//  WriteToolbar.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLNRCheckbox.h"

@interface WriteToolbar : UIToolbar

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readonly) NSUInteger maxLength;

@property (nonatomic, readonly, strong) UILabel *textLabel;
@property (nonatomic, readonly, strong) VLNRCheckbox *checkbox;

@end
