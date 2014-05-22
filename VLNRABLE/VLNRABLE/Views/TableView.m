//
//  TableView.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/21/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "TableView.h"

@implementation TableView

- (instancetype)init
{
	if (self = [super init]) {
		self.backgroundColor = [VLNRColor lightTealColor];
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.separatorInset = UIEdgeInsetsZero;
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [VLNRColor lightTealColor];
		self.separatorColor = [VLNRColor tealColor];
    }
    return self;
}

- (instancetype)initWithSeparators
{
	if (self = [super init]) {
		self.backgroundColor = [VLNRColor lightTealColor];
		self.separatorColor = [VLNRColor tealColor];
	}
	return self;
}

@end
