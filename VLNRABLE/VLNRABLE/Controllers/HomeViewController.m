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
#import "TableView.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface HomeViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) TableView *tableView;
@property (nonatomic, readwrite, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (instancetype)init
{
	if (self = [super init]) {
		self.title = @"Home";
	}
	return self;
}

- (void)loadView
{
	_tableView = [[TableView alloc] init];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self setView:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.refreshControl = [[UIRefreshControl alloc] init];

	[self.refreshControl addTarget:self
							action:@selector(refreshStories:)
				  forControlEvents:UIControlEventValueChanged];

	[self.tableView addSubview:self.refreshControl];

	self.tableView.backgroundColor = [VLNRColor lightTealColor];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		self.refreshControl.tintColor = [VLNRColor tealColor];
		self.tableView.separatorInset = UIEdgeInsetsZero;
		self.automaticallyAdjustsScrollViewInsets = NO;
	}

	[self.tableView registerClass:[StoryTableViewCell class]
		   forCellReuseIdentifier:cellIdentifier];

	[self refreshStories:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

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
	storyCell.timeLabel.text = @"15m";
	storyCell.storyLabel.text = story.body;

	NSString *storyTitle = [NSString stringWithFormat:@"%@ written by %@", story.title, story.author];
	NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:storyTitle];
	NSRange titleRange = [[titleStr string] rangeOfString:story.title];
	[titleStr addAttribute:NSForegroundColorAttributeName value:[VLNRColor blueColor] range:titleRange];
	storyCell.titleLabel.attributedText = titleStr;

	NSString *storyCategory = @"Trending in: Relationships";
	NSMutableAttributedString *categoryStr = [[NSMutableAttributedString alloc] initWithString:storyCategory];
	NSRange categoryRange = [[categoryStr string] rangeOfString:@"Trending in:"];
	[categoryStr addAttribute:NSForegroundColorAttributeName value:[VLNRColor grayTextColor] range:categoryRange];
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
