//
//  GetStartedTableViewCell.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/25/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetStartedTableViewCell : UITableViewCell

@property (nonatomic, readwrite) CGFloat padding;

@property (strong, nonatomic, readonly) UIImageView *leftImageView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *detailLabel;

+ (CGFloat)height;

@end
