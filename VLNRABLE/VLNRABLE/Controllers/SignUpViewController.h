//
//  SignUpViewController.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpView.h"

@interface SignUpViewController : UIViewController

@property (nonatomic, strong, readonly) SignUpView *signUpView;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

@end