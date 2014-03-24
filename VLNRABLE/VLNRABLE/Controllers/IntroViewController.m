//
//  IntroViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)loadView
{
	IntroView *introView = [[IntroView alloc] init];
	
	[self setView:introView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Action methods


@end
