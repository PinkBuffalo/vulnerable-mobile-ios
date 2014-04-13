//
//  LogInViewController.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "LogInViewController.h"
#import "IntroViewController.h"
#import "SignUpViewController.h"

#define LOG_IN_SEGMENT_INDEX 0
#define SIGN_UP_SEGMENT_INDEX 1

@interface LogInViewController ()

@property (nonatomic, strong, readwrite) LogInView *logInView;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;

@end

@implementation LogInViewController

- (void)loadView
{
	[self setView:self.logInView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.segmentedControl addTarget:self
							  action:@selector(switchView:)
					forControlEvents:UIControlEventValueChanged];

	self.navigationItem.titleView = self.segmentedControl;
	self.navigationController.navigationBar.barTintColor = [VLNRColor tealColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (LogInView *)logInView
{
	if (!_logInView) {
		_logInView = [[LogInView alloc] init];
	}
	return _logInView;
}

- (UISegmentedControl *)segmentedControl
{
	if (!_segmentedControl) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"Log In", @"Sign Up" ]];
		_segmentedControl.selectedSegmentIndex = LOG_IN_SEGMENT_INDEX;
		CGFloat screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
		[_segmentedControl setWidth:(screenWidth / 4.0f) forSegmentAtIndex:LOG_IN_SEGMENT_INDEX];
		[_segmentedControl setWidth:(screenWidth / 4.0f) forSegmentAtIndex:SIGN_UP_SEGMENT_INDEX];
	}
	return _segmentedControl;
}

#pragma mark - Action methods
- (void)switchView:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == LOG_IN_SEGMENT_INDEX) {
		return;
	}

	SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
	IntroViewController *introVC = [[self.navigationController viewControllers] firstObject];
	[self.navigationController setViewControllers:@[ introVC, signUpVC ]];
}

@end
