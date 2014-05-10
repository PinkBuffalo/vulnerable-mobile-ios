//
//  HomeViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "HomeViewController.h"
#import "StoryTableViewCell.h"
#import "UserManager.h"
#import "StoryManager.h"
#import "Story.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface HomeViewController () <UITabBarControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.refreshControl = [[UIRefreshControl alloc] init];
	if ([self.refreshControl respondsToSelector:@selector(setTintColor:)]) {
		self.refreshControl.tintColor = [VLNRColor tealColor];
	}
	[self.refreshControl addTarget:self
							action:@selector(refreshStories:)
				  forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:self.refreshControl];

	self.tableView.backgroundColor = [VLNRColor lightTealColor];
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		self.tableView.separatorInset = UIEdgeInsetsZero;
	}

	[self.tableView registerClass:[StoryTableViewCell class]
		   forCellReuseIdentifier:cellIdentifier];

	[self refreshStories:nil];

	self.title = @"Home";
	self.tabBarController.navigationItem.title = @"Home";
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [StoryManager sharedManager].stories.count;
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
															forIndexPath:indexPath];

	[self configureCell:cell forRowAtIndexPath:indexPath];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [StoryTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	StoryTableViewCell *storyCell = (StoryTableViewCell *)cell;
	Story *story = [[[StoryManager sharedManager].stories allObjects] objectAtIndex:indexPath.row];
	storyCell.titleLabel.text = story.title;
	storyCell.timeLabel.text = @"15m";
	storyCell.storyLabel.text = story.body;

	NSMutableAttributedString *categoryStr = [[NSMutableAttributedString alloc] initWithString:@"Trending in: Relationships"];
	NSRange range = [[categoryStr string] rangeOfString:@"Trending in: "];
	[categoryStr addAttribute:NSForegroundColorAttributeName value:[VLNRColor grayColor] range:range];

	storyCell.categoryLabel.attributedText = categoryStr;
}

- (void)refreshStories:(id)sender
{
	if ([[StoryManager sharedManager] areStoriesLoading]) {
		return;
	}

	__typeof__(self) __weak weakSelf = self;
	[[StoryManager sharedManager] getStoriesForUser:nil successBlock:^(NSSet *stories) {
		[weakSelf.tableView reloadData];
		[(UIRefreshControl *)sender endRefreshing];
		VLNRLogVerbose(@"\nSUCCESS: %@\n", stories);
	} failureBlock:^(NSError *error) {
		[weakSelf.tableView reloadData];
		VLNRLogError(@"\nFAILURE: %@\n", error);
		[(UIRefreshControl *)sender endRefreshing];
	}];
}

@end
