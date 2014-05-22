//
//  HomeViewController.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableView;

@interface HomeViewController : UIViewController

@property (nonatomic, readonly, strong) TableView *tableView;
@property (nonatomic, readonly, strong) UIRefreshControl *refreshControl;

@end
