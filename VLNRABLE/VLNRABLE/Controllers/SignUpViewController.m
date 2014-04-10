//  Copyright (c) 2014 VLNRABLE. All rights reserved.

#import "SignUpViewController.h"
#import "SignUpView.h"

@interface SignUpViewController ()

@property (strong, nonatomic, readwrite) SignUpView *signUpView;

@end

@implementation SignUpViewController

- (void)loadView
{
	[self setView:self.signUpView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

#pragma mark - Action method


@end
