//
//  HomeViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "HomeViewController.h"
#import "StoryTableViewCell.h"
#import "AFNetworking.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface HomeViewController () <UITabBarControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong, readwrite) NSArray *stories;

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
							action:@selector(refresh:)
				  forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:self.refreshControl];

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
	storyCell.titleLabel.text = [self.stories objectAtIndex:indexPath.row];
	storyCell.timeLabel.text = @"15m";
	storyCell.storyLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc facilisis felis erat, quis porttitor dui aliquam id. Fusce in sapien nisl. Vivamus id quam sit amet felis molestie porttitor quis at eros.";

	NSMutableAttributedString *categoryStr = [[NSMutableAttributedString alloc] initWithString:@"Trending in: Relationships"];
	NSRange range = [[categoryStr string] rangeOfString:@"Trending in: "];
	[categoryStr addAttribute:NSForegroundColorAttributeName value:[VLNRColor grayColor] range:range];

	storyCell.categoryLabel.attributedText = categoryStr;
}

- (void)refresh:(id)sender
{
	// TODO: Add real request.
	NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSUInteger statusCode = operation.response.statusCode;
		[weakSelf.tableView reloadData];
		[(UIRefreshControl *)sender endRefreshing];
		NSLog(@"\nSUCCESS (%lu):\n%@\n", (unsigned long)statusCode, operation.responseString);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSUInteger statusCode = operation.response.statusCode;
		[weakSelf.tableView reloadData];
		[(UIRefreshControl *)sender endRefreshing];
		NSLog(@"\nFAILURE (%lu):\n%@\n", (unsigned long)statusCode, operation.responseString);
	}];

	[[[AFHTTPRequestOperationManager manager] operationQueue] addOperation:operation];
}

@end
