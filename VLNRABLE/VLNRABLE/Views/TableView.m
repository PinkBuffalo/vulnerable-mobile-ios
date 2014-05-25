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
		self.separatorColor = [VLNRColor lightTealTextColor];
    }
    return self;
}

- (instancetype)initWithSeparators:(BOOL)separators
{
	if (self = [super init]) {
		self.backgroundColor = [VLNRColor lightTealColor];
		if (separators) {
			self.separatorColor = [VLNRColor lightTealTextColor];
		} else {
			self.separatorStyle = UITableViewCellSeparatorStyleNone;
			self.separatorInset = UIEdgeInsetsZero;
		}
	}
	return self;
}

- (instancetype)initWithSeparators:(BOOL)separators
							 style:(UITableViewStyle)style
{
	if (self = [super init]) {
		self = [[TableView alloc] initWithFrame:CGRectZero style:style];
		self.backgroundColor = [VLNRColor lightTealColor];
		self.separatorInset = UIEdgeInsetsZero;
		if (separators) {
			self.separatorColor = [VLNRColor lightTealTextColor];
		} else {
			self.separatorStyle = UITableViewCellSeparatorStyleNone;
		}
	}
	return self;
}

@end
