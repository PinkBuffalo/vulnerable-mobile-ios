//
//  SignUpViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "SignUpViewController.h"
#import "IntroViewController.h"
#import "LogInViewController.h"

#define LOG_IN_SEGMENT_INDEX 0
#define SIGN_UP_SEGMENT_INDEX 1

@interface SignUpViewController ()

@property (nonatomic, strong, readwrite) SignUpView *signUpView;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;

@end

@implementation SignUpViewController

- (void)loadView
{
	[self setView:self.signUpView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.segmentedControl addTarget:self
							  action:@selector(switchView:)
					forControlEvents:UIControlEventValueChanged];

	self.navigationItem.titleView = self.segmentedControl;
	self.navigationController.navigationBar.barTintColor = [VLNRABLEColor tealColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.navigationController.navigationBarHidden = NO;
}

- (SignUpView *)signUpView
{
	if (!_signUpView) {
		_signUpView = [[SignUpView alloc] init];
	}
	return _signUpView;
}

- (UISegmentedControl *)segmentedControl
{
	if (!_segmentedControl) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"Log In", @"Sign Up" ]];
		_segmentedControl.selectedSegmentIndex = SIGN_UP_SEGMENT_INDEX;
		CGFloat screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
		[_segmentedControl setWidth:(screenWidth / 4.0f) forSegmentAtIndex:LOG_IN_SEGMENT_INDEX];
		[_segmentedControl setWidth:(screenWidth / 4.0f) forSegmentAtIndex:SIGN_UP_SEGMENT_INDEX];
	}
	return _segmentedControl;
}

#pragma mark - Action methods
- (void)switchView:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == SIGN_UP_SEGMENT_INDEX) {
		return;
	}

	LogInViewController *logInVC = [[LogInViewController alloc] init];
	IntroViewController *introVC = [[self.navigationController viewControllers] firstObject];
	[self.navigationController setViewControllers:@[ introVC, logInVC ]];
}

@end
