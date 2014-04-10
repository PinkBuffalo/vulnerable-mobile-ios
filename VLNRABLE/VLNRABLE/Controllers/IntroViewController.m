//
//  IntroViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView.h"
#import "GetStartedViewController.h"
#import "SignUpViewController.h"

@interface IntroViewController ()

@property (strong, nonatomic, readwrite) IntroView *introView;

@end

@implementation IntroViewController

- (void)loadView
{
	[self setView:self.introView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.introView.signUpButton addTarget:self
									action:@selector(pushToSignUpViewController)
						  forControlEvents:UIControlEventTouchUpInside];

	//TODO: Figure out why these taps don't work for the subviews.
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

	self.navigationController.navigationBarHidden = YES;
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
}

@end
