//
//  TableView.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/21/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableView : UITableView

- (instancetype)initWithSeparators:(BOOL)separators;
- (instancetype)initWithSeparators:(BOOL)separators
							 style:(UITableViewStyle)style;

@end
