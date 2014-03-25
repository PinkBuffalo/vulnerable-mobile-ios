//
//  GetStartedViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "GetStartedViewController.h"
#import "GetStartedView.h"

@interface GetStartedViewController ()

@property (strong, nonatomic, readwrite) GetStartedView *getStartedView;

@end

@implementation GetStartedViewController

- (void)loadView
{
	[self setView:self.getStartedView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - Lazy loading methods
- (GetStartedView *)getStartedView
{
	if (!_getStartedView) {
		_getStartedView = [[GetStartedView alloc] init];
	}
	return _getStartedView;
}

#pragma mark - Action methods
- (void)presentSignUpViewController
{
	
}

@end
