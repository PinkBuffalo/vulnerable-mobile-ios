//
//  IntroView.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroView : UIView

@property (nonatomic, readwrite) CGFloat padding;
@property (nonatomic, readwrite) CGFloat buttonHeight;

@property (strong, nonatomic, readonly) UIImageView *logoView;
@property (strong, nonatomic, readonly) UIButton *logInButton;
@property (strong, nonatomic, readonly) UIButton *signUpButton;
@property (strong, nonatomic, readonly) UILabel *learnMoreLabel;

@end
