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
#import "SignUpView.h"
#import "UserManager.h"

#define LOG_IN_SEGMENT_INDEX 0
#define SIGN_UP_SEGMENT_INDEX 1

@interface SignUpViewController () <UIScrollViewDelegate, UITextFieldDelegate, TTTAttributedLabelDelegate>

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

	UITapGestureRecognizer *scrollTap = [[UITapGestureRecognizer alloc] init];
	[scrollTap addTarget:self action:@selector(hideKeyboard)];
	[self.signUpView.scrollView addGestureRecognizer:scrollTap];

	[self.signUpView.facebookButton addTarget:self
									   action:@selector(signUpAction)
							 forControlEvents:UIControlEventTouchUpInside];

	[self.signUpView.signUpButton addTarget:self
									   action:@selector(signUpAction)
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

- (SignUpView *)signUpView
{
	if (!_signUpView) {
		_signUpView = [[SignUpView alloc] initWithDelegate:self];
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

#pragma mark - Text field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

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

- (void)hideKeyboard
{
	[self.signUpView endEditing:YES];
}

- (void)signUpAction
{
	NSDictionary *userinfo = @{ @"name": [self.signUpView.nameTextField.text copy],
								@"email": [self.signUpView.emailTextField.text copy] };

	__typeof__(self) __weak weakSelf = self;
	[[UserManager sharedManager] postUserWithUserInfo:userinfo successBlock:^(User *user) {
		NSLog(@"User: %@", user);
		[weakSelf dismissViewControllerAnimated:YES completion:nil];
	} failureBlock:^(NSError *error) {
		NSLog(@"Error: %@", error);
		[[[UIAlertView alloc] initWithTitle:@"Sign Up Failed"
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}];
}

@end
