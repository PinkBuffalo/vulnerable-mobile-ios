//
//  TabBarViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "IntroViewController.h"
#import "MyAccountViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)init
{
	if (self == [super init]) {

		HomeViewController *homeVC = [[HomeViewController alloc] init];

		// TODO: Add actual view controllers once they are created.
		UIViewController *vc1 = [UIViewController new];
		vc1.view.backgroundColor = [UIColor cyanColor];
		vc1.title = @"Discover";

		UIViewController *vc2 = [UIViewController new];
		vc2.view.backgroundColor = [UIColor yellowColor];
		vc2.title = @"Write";

		MyAccountViewController *myAccountVC = [[MyAccountViewController alloc] init];

		self.viewControllers = @[ homeVC,
								  vc1,
								  vc2,
								  myAccountVC ];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tabBar.barTintColor = [UIColor blackColor];
	self.tabBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// TODO: Need to set this key-value to NSUserDefaults.
	// Change if to !userExists to skip to HomeViewController.
	BOOL userExists;
	if (userExists) {
		return;
	}

	IntroViewController *introVC = [[IntroViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVC];
	navController.navigationBar.barTintColor = [VLNRColor tealColor];
	navController.navigationBar.tintColor = [UIColor whiteColor];
	[self.navigationController presentViewController:navController animated:NO completion:nil];
}

@end
