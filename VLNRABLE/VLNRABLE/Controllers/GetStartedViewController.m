//
//  GetStartedViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "GetStartedViewController.h"
#import "GetStartedView.h"
#import "GetStartedTableViewCell.h"

NSString * const kGetStartedWriteKey = @"Write";
NSString * const kGetStartedDiscoverKey = @"Discover";
NSString * const kGetStartedPrivacyKey = @"Privacy";

static NSString *getStartedCellIdentifier = @"getStartedCellIdentifier";

@interface GetStartedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readwrite) GetStartedView *getStartedView;
@property (strong, nonatomic, readwrite) NSDictionary *descriptionInfo;

@end

@implementation GetStartedViewController

- (void)loadView
{
	[self setView:self.getStartedView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.getStartedView.tableView registerClass:[GetStartedTableViewCell class]
						  forCellReuseIdentifier:getStartedCellIdentifier];

	[self.getStartedView.getStartedButton addTarget:self
											 action:@selector(dismissViewController)
								   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Lazy loading methods
- (GetStartedView *)getStartedView
{
	if (!_getStartedView) {
		_getStartedView = [[GetStartedView alloc] init];
		_getStartedView.tableView.dataSource = self;
		_getStartedView.tableView.delegate = self;
	}
	return _getStartedView;
}

- (NSDictionary *)descriptionInfo
{
	if (!_descriptionInfo) {
		_descriptionInfo = @{ kGetStartedWriteKey: @"Explain a past experience or get a secret off your chest, then share your story anonymously with others.",
							  kGetStartedDiscoverKey: @"Browse stories that interest you, select from categories or find new ones from users that you follow.",
							  kGetStartedPrivacyKey: @"The only personal information shared in the app is your first name or a pseudonym, if desired." };
	}
	return _descriptionInfo;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.descriptionInfo allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	GetStartedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:getStartedCellIdentifier forIndexPath:indexPath];

	cell.titleLabel.text = [[self.descriptionInfo allKeys] objectAtIndex:indexPath.row];
	cell.detailLabel.text = [[self.descriptionInfo allValues] objectAtIndex:indexPath.row];

	return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [GetStartedTableViewCell height];
}

#pragma mark - Action methods
- (void)dismissViewController
{
//	SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
//	UINavigationController *navController = (UINavigationController *)self.presentingViewController;
//	[navController setViewControllers:@[ signUpVC ]];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
