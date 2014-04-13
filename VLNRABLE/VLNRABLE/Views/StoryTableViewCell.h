//
//  StoryTableViewCell.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryTableViewCell : UITableViewCell

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat storyImageWidthAndHeight;

@property (nonatomic, strong, readonly) UIImageView *clockImageView;
@property (nonatomic, strong, readonly) UIImageView *heartImageView;
@property (nonatomic, strong, readonly) UIImageView *starImageView;
@property (nonatomic, strong, readonly) UIImageView *storyImageView;
@property (nonatomic, strong, readonly) UIImageView *visibilityImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *storyLabel;
@property (nonatomic, strong, readonly) UILabel *categoryLabel;

+ (CGFloat)height;

@end
