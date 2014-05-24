//
//  MyAccountViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/21/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "MyAccountViewController.h"
#import "UserManager.h"
#import "TableView.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface MyAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) TableView *tableView;
@property (nonatomic, readwrite, strong) UIRefreshControl *refreshControl;
@property (nonatomic, readwrite, strong) NSMutableArray *profileRows;
@property (nonatomic, readwrite, strong) NSMutableArray *storiesRows;
@property (nonatomic, readwrite, strong) NSMutableArray *settingsRows;
@property (nonatomic, readwrite, strong) NSMutableDictionary *myAccountInfo;

@end

@implementation MyAccountViewController

- (instancetype)init
{
	if (self = [super init]) {
		self.title = @"Me";
	}
	return self;
}

- (void)loadView
{
	_tableView = [[TableView alloc] initWithSeparators];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self setView:_tableView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.refreshControl = [[UIRefreshControl alloc] init];

	[self.refreshControl addTarget:self
							action:@selector(refreshMyAccount:)
				  forControlEvents:UIControlEventValueChanged];

	[self.tableView addSubview:self.refreshControl];

	self.tableView.backgroundColor = [VLNRColor lightTealColor];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		self.refreshControl.tintColor = [VLNRColor tealColor];
		self.tableView.contentInset = UIEdgeInsetsMake(100.0f, 0, 0, 0);
		self.automaticallyAdjustsScrollViewInsets = NO;
	}

	[self.tableView registerClass:[UITableViewCell class]
		   forCellReuseIdentifier:cellIdentifier];

	[self refreshMyAccount:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.tabBarController.navigationItem.title = @"My Account";
}

#pragma mark - Lazy loading methods
- (NSMutableArray *)profileRows
{
	return [NSMutableArray arrayWithArray:@[ @"Paris",
											 @"hello@pxpgraphics.com" ]];
}

- (NSMutableArray *)storiesRows
{
	return [NSMutableArray arrayWithArray:@[ @"Favorite Stories",
											 @"Liked Stories",
											 @"Hidden Stories" ]];
}

- (NSMutableArray *)settingsRows
{
	return [NSMutableArray arrayWithArray:@[ @"Edit Profile",
											 @"Change Password" ]];
}

- (NSMutableDictionary *)myAccountInfo
{
	return [NSMutableDictionary dictionaryWithDictionary:@{ @"profile" : self.profileRows,
															@"stories" : self.storiesRows,
															@"settings" : self.settingsRows }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
		case 2:
			return 2;
			break;
		case 1:
			return 3;
		default:
			return 0;
			break;
	}
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
															forIndexPath:indexPath];

	cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];

	switch (indexPath.section) {
		case 0:
		{
			cell.textLabel.text = [self.myAccountInfo[@"profile"] objectAtIndex:indexPath.row];
			break;
		}
		case 1:
		{
			cell.textLabel.text = [self.myAccountInfo[@"stories"] objectAtIndex:indexPath.row];
			break;
		}
		case 2:
		{
			cell.textLabel.text = [self.myAccountInfo[@"settings"] objectAtIndex:indexPath.row];
			break;
		}
		default:
			break;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action methods
- (void)refreshMyAccount:(id)sender
{
	if ([[UserManager sharedManager] isLoading]) {
		return;
	}

	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

@end
