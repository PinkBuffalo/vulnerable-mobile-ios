//
//  IntroViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "IntroViewController.h"
#import "GetStartedViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"

@interface IntroViewController ()

@property (nonatomic, strong, readwrite) IntroView *introView;

@end

@implementation IntroViewController

- (void)loadView
{
	[self setView:self.introView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.introView.logInButton addTarget:self
									action:@selector(pushToLogInViewController)
						  forControlEvents:UIControlEventTouchUpInside];

	[self.introView.signUpButton addTarget:self
									action:@selector(pushToSignUpViewController)
						  forControlEvents:UIControlEventTouchUpInside];

	UITapGestureRecognizer *learnMoreLabelTap = [[UITapGestureRecognizer alloc] init];
	[learnMoreLabelTap addTarget:self action:@selector(presentGetStartedViewController)];
	[self.introView.learnMoreLabel setUserInteractionEnabled:YES];
	[self.introView.learnMoreLabel addGestureRecognizer:learnMoreLabelTap];

	UITapGestureRecognizer *learnMoreArrowTap = [[UITapGestureRecognizer alloc] init];
	[learnMoreArrowTap addTarget:self action:@selector(presentGetStartedViewController)];
	[self.introView.arrowImageView setUserInteractionEnabled:YES];
	[self.introView.arrowImageView addGestureRecognizer:learnMoreArrowTap];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Lazy loading methods
- (IntroView *)introView
{
	if (!_introView) {
		_introView = [[IntroView alloc] init];
	}
	return _introView;
}

#pragma mark - Action methods
- (UINavigationController *)customNavigationController
{
	UINavigationController *navController;
	if (self.navigationController) {
		navController = self.navigationController;
	} else {
		navController = (UINavigationController *)self.presentingViewController;
	}
	return navController;
}

- (void)pushToLogInViewController
{
	LogInViewController *logInVC = [[LogInViewController alloc] init];
	[self.navigationController pushViewController:logInVC animated:YES];
}

- (void)pushToSignUpViewController
{
	SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
	[self.navigationController pushViewController:signUpVC animated:YES];
}

- (void)presentGetStartedViewController
{
	GetStartedViewController *getStartedVC = [[GetStartedViewController alloc] init];
	[self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self.navigationController presentViewController:getStartedVC animated:YES completion:nil];
	[self.navigationController setNavigationBarHidden:YES];
}

@end
