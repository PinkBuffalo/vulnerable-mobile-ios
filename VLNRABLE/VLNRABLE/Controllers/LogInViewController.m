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
#import "LogInView.h"

#define LOG_IN_SEGMENT_INDEX 0
#define SIGN_UP_SEGMENT_INDEX 1

@interface LogInViewController () <UIScrollViewDelegate, UITextFieldDelegate>

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

	UITapGestureRecognizer *scrollTap = [[UITapGestureRecognizer alloc] init];
	[scrollTap addTarget:self action:@selector(hideKeyboard)];
	[self.logInView.scrollView addGestureRecognizer:scrollTap];

	[self.logInView.facebookButton addTarget:self
									  action:@selector(logInAction)
							forControlEvents:UIControlEventTouchUpInside];

	[self.logInView.logInButton addTarget:self
								   action:@selector(logInAction)
						 forControlEvents:UIControlEventTouchUpInside];

	[self.segmentedControl addTarget:self
							  action:@selector(switchView:)
					forControlEvents:UIControlEventValueChanged];

	self.navigationItem.titleView = self.segmentedControl;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (LogInView *)logInView
{
	if (!_logInView) {
		_logInView = [[LogInView alloc] initWithDelegate:self];
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

#pragma mark - Text field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
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

- (void)hideKeyboard
{
	[self.logInView endEditing:YES];
}

- (void)logInAction
{
	// TODO: Change these test to the user log in action when ready.
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
