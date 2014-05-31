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
#import "WriteViewController.h"

@interface TabBarViewController ()

@property (nonatomic, readwrite, strong) UINavigationController *homeNavController;
@property (nonatomic, readwrite, strong) UINavigationController *writeNavController;
@property (nonatomic, readwrite, strong) UINavigationController *myAccountNavController;
@property (nonatomic, readwrite) NSUInteger previousSelectedIndex;

@end

@implementation TabBarViewController

- (id)init
{
	if (self == [super init]) {
		HomeViewController *homeVC = [[HomeViewController alloc] init];
		_homeNavController = [[UINavigationController alloc] initWithRootViewController:homeVC];

		// TODO: Add actual view controllers once they are created.
		UIViewController *vc1 = [UIViewController new];
		vc1.view.backgroundColor = [UIColor cyanColor];
		UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];

		WriteViewController *writeVC = [[WriteViewController alloc] init];
		_writeNavController = [[UINavigationController alloc] initWithRootViewController:writeVC];

		MyAccountViewController *myAccountVC = [[MyAccountViewController alloc] init];
		_myAccountNavController = [[UINavigationController alloc] initWithRootViewController:myAccountVC];

		self.viewControllers = @[ _homeNavController,
								  nav1,
								  _writeNavController,
								  _myAccountNavController ];
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	NSUInteger selectedIndex = [tabBar.items indexOfObject:item];
	if (selectedIndex != [self.viewControllers indexOfObject:_writeNavController]) {
		self.previousSelectedIndex = selectedIndex;
	}
}

@end
