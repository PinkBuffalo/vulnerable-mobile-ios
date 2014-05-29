//
//  MyAccountViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/21/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "MyAccountViewController.h"
#import "UserManager.h"
#import "User.h"
#import "TableView.h"
#import "DetailTableViewCell.h"

static NSString * const kUserLocationKey = @"UserLocationKey";
static NSString *cellIdentifier = @"cellIdentifier";

@interface MyAccountViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) TableView *tableView;
@property (nonatomic, readwrite, strong) UIRefreshControl *refreshControl;
@property (nonatomic, readwrite, strong) NSMutableDictionary *profileInfo;
@property (nonatomic, readwrite, strong) NSMutableDictionary *storiesInfo;
@property (nonatomic, readwrite, strong) NSMutableDictionary *settingsInfo;
@property (nonatomic, readwrite, strong) NSString *location;

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
	_tableView = [[TableView alloc] initWithSeparators:YES style:UITableViewStyleGrouped];
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
	}

	[self.tableView registerClass:[DetailTableViewCell class]
		   forCellReuseIdentifier:cellIdentifier];

	[self refreshMyAccount:nil];

	[UserManager sharedManager].locationManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.tabBarController.navigationItem.title = @"My Account";
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Lazy loading methods
- (NSMutableDictionary *)profileInfo
{
	User *user = [UserManager sharedManager].user;
	return [NSMutableDictionary dictionaryWithDictionary:@{ @"Email": user.email ?: @"",
															@"Nickname": user.nickname ?: @"",
															@"Location": self.location ?: @"" }];
}

- (NSMutableDictionary *)storiesInfo
{
	User *user = [UserManager sharedManager].user;
	return [NSMutableDictionary dictionaryWithDictionary:@{ @"My Stories": user.stories ?: @"",
															@"Favorite Stories": user.favorites ?: @"",
															@"Hidden Stories": user.stories ?: @"" }];
}

- (NSMutableDictionary *)settingsInfo
{
	User *user = [UserManager sharedManager].user;
	return [NSMutableDictionary dictionaryWithDictionary:@{ @"Edit Profile": user ?: @"",
															@"Change Password": user ?: @"" }];
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
			return [self.profileInfo.allValues count];
			break;
		case 1:
			return [self.storiesInfo.allValues count];
			break;
		case 2:
			return [self.settingsInfo.allValues count];
			break;
		default:
			return 0;
			break;
	}
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
																forIndexPath:indexPath];

	[self configureCell:cell forRowAtIndexPath:indexPath];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DetailTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([[userDefaults objectForKey:kUserLocationKey] isEqualToString:self.location]) {
		return;
	}

	if (!locations || !locations.count) {
		return;
	}

	__typeof__(self) __weak weakSelf = self;
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:[locations firstObject] completionHandler:^(NSArray *placemarks, NSError *error) {
		for (CLPlacemark *placemark in placemarks) {
			weakSelf.location = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
			[userDefaults setObject:weakSelf.location forKey:kUserLocationKey];
			if (![userDefaults synchronize]) {
				VLNRLogError(@"Error: User defaults not synched!");
			}
			[weakSelf.tableView reloadData];
			break;
		}
	}];
}

#pragma mark - Action methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	DetailTableViewCell *detailCell = (DetailTableViewCell *)cell;
	detailCell.textLabel.font = [VLNRAppManager systemFont];

	switch (indexPath.section) {
		case 0:
		{
			detailCell.titleLabel.text = [self.profileInfo.allKeys objectAtIndex:indexPath.row];
			detailCell.contentLabel.text = [self.profileInfo.allValues objectAtIndex:indexPath.row];
			break;
		}
		case 1:
		{
			detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			detailCell.titleLabel.text = [self.storiesInfo.allKeys objectAtIndex:indexPath.row];
			break;
		}
		case 2:
		{
			detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			detailCell.titleLabel.text = [self.settingsInfo.allKeys objectAtIndex:indexPath.row];
			break;
		}
		default:
			break;
	}
}

- (void)refreshMyAccount:(id)sender
{
	if ([[UserManager sharedManager] isLoading]) {
		return;
	}

	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

@end
