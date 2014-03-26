//
//  GetStartedView.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetStartedView : UIView

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat buttonHeight;

@property (strong, nonatomic, readonly) UITableView *tableView;
@property (strong, nonatomic, readonly) UIView *tableHeaderView;
@property (strong, nonatomic, readonly) UIView *tableFooterView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UIButton *getStartedButton;

@end
