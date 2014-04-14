//
//  HomeViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "HomeViewController.h"
#import "StoryTableViewCell.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface HomeViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong, readwrite) NSArray *stories;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView.backgroundColor = [VLNRColor lightTealColor];
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		self.tableView.separatorInset = UIEdgeInsetsZero;
	}

	[self.tableView registerClass:[StoryTableViewCell class]
		   forCellReuseIdentifier:cellIdentifier];

	self.title = @"Home";
	self.tabBarController.navigationItem.title = @"Home";
}

- (NSArray *)stories
{
	if (!_stories) {
		_stories = @[ @"Skeletons in the Closet",
					  @"What Happened in Vegas",
					  @"I'm Dating Her Ex",
					  @"I Didn't Deserve This",
					  @"I Still Love Her" ];
	}
	return _stories;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.stories.count;
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
															forIndexPath:indexPath];

	cell.titleLabel.text = [self.stories objectAtIndex:indexPath.row];
	cell.timeLabel.text = @"15m";
	cell.storyLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc facilisis felis erat, quis porttitor dui aliquam id. Fusce in sapien nisl. Vivamus id quam sit amet felis molestie porttitor quis at eros.";
	cell.categoryLabel.text = @"Trending in: Relationships";

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [StoryTableViewCell height];
}


@end
