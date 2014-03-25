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

@interface IntroViewController ()

@property (strong, nonatomic, readwrite) IntroView *introView;
@property (strong, nonatomic, readwrite) GetStartedViewController *getStartedVC;
@property (strong, nonatomic, readwrite) UITapGestureRecognizer *learnMoreLabelTap;
@property (strong, nonatomic, readwrite) UITapGestureRecognizer *learnMoreArrowTap;

@end

@implementation IntroViewController

- (void)loadView
{
	[self setView:self.introView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.introView addGestureRecognizer:self.learnMoreLabelTap];
	[self.introView addGestureRecognizer:self.learnMoreArrowTap];
}

#pragma mark - Lazy loading methods
- (IntroView *)introView
{
	if (!_introView) {
		_introView = [[IntroView alloc] init];
	}
	return _introView;
}

- (UITapGestureRecognizer *)learnMoreLabelTap
{
	if (!_learnMoreLabelTap) {
		_learnMoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																	 action:@selector(presentGetStartedViewController)];

	}
	return _learnMoreLabelTap;
}

- (UITapGestureRecognizer *)learnMoreArrowTap
{
	if (!_learnMoreArrowTap) {
		_learnMoreArrowTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																	 action:@selector(presentGetStartedViewController)];

	}
	return _learnMoreArrowTap;
}

#pragma mark - Action methods
- (void)presentGetStartedViewController
{
	self.getStartedVC = [[GetStartedViewController alloc] init];
	[self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self.navigationController presentViewController:self.getStartedVC animated:YES completion:nil];
}

@end
