//
//  DetailTableViewCell.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/25/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UILabel *contentLabel;

+ (CGFloat)height;

@end
