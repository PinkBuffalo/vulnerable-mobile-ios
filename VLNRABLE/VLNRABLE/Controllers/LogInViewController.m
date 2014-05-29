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
#import "UserManager.h"

#define LOG_IN_SEGMENT_INDEX 0
#define SIGN_UP_SEGMENT_INDEX 1

@interface LogInViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong, readwrite) LogInView *logInView;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activityIndicator;

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

	self.logInView.emailTextField.text = @"holler@dennisgable.com";
	self.logInView.passwordTextField.text = @"password123";

	[self.logInView.facebookButton addTarget:self
									  action:@selector(facebookAction)
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

#pragma mark - Lazy loading methods
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

- (UIActivityIndicatorView *)activityIndicator
{
	if (!_activityIndicator) {
		_activityIndicator = [[UIActivityIndicatorView alloc] init];
		_activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	}
	return _activityIndicator;
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	switch (textField.tag) {
		case LogInViewEmailTextFieldTag:
			[[self.logInView viewWithTag:(textField.tag + 1)] becomeFirstResponder];
			break;
			case LogInViewPasswordTextFieldTag:
		{
			if ([self textFieldsAreValid]) {
				[self logInAction];
			}
			break;
		}
		default:
			break;
	}
	return YES;
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

- (BOOL)textFieldsAreValid
{
	BOOL validTextField = NO;
	for (UIView *subview in self.logInView.scrollView.subviews) {
		if ([subview isKindOfClass:[UITextField class]]) {
			UITextField *textField = (UITextField *)subview;
			if (textField.text.length > 0) {
				validTextField = YES;
			} else {
				validTextField = NO;
				[textField becomeFirstResponder];
				break;
			}
		}
	}
	return validTextField;
}

- (void)logInAction
{
	if ([[UserManager sharedManager] isLoading] || ![self textFieldsAreValid]) {
		return;
	}

	[self.activityIndicator startAnimating];

	NSDictionary *userInfo = @{ @"username": [self.logInView.emailTextField.text copy],
								@"password": [self.logInView.passwordTextField.text copy] };

	__typeof__(self) __weak weakSelf = self;
	[[UserManager sharedManager] loginUserWithUserInfo:userInfo successBlock:^(User *user) {
		VLNRLogVerbose(@"\nUser: %@\n", user);
		[weakSelf.activityIndicator stopAnimating];
		[weakSelf dismissViewControllerAnimated:YES completion:nil];
	} failureBlock:^(NSError *error) {
		VLNRLogError(@"\nError: %@\n", error);
		[weakSelf.activityIndicator stopAnimating];
		[[[UIAlertView alloc] initWithTitle:@"Log In Failed"
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}];
}

- (void)facebookAction
{
	NSArray *permissions = @[ @"public_profile", @"email", @"user_location" ];

	__typeof__(self) __weak weakSelf = self;
	[PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
		[weakSelf.activityIndicator stopAnimating];
		if (!user) {
			if (!error) {
				VLNRLogWarn(@"User cancelled Facebook log in.");
				[[[UIAlertView alloc] initWithTitle:@"Log In Failed"
											message:@"User cancelled the log in."
										   delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
			} else {
				VLNRLogError(@"Error: %@", error);
				[[[UIAlertView alloc] initWithTitle:@"Log In Failed"
											message:error.localizedDescription
										   delegate:nil
								  cancelButtonTitle:@"Dismiss"
								  otherButtonTitles:nil] show];
			}
		} else if (user.isNew) {
			VLNRLogInfo(@"User signed up and logged in with Facebook!");
			[[UserManager sharedManager] requestFacebookDataWithCompletionBlock:^(User *user) {
				[weakSelf dismissViewControllerAnimated:YES completion:nil];
			}];
		} else {
			VLNRLogInfo(@"User logged in with Facebook!");
			[[UserManager sharedManager] requestFacebookDataWithCompletionBlock:^(User *user) {
				[weakSelf dismissViewControllerAnimated:YES completion:nil];
			}];
		}
	}];
	[self.activityIndicator startAnimating];
}

@end
