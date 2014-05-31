//
//  WriteViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/30/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "WriteViewController.h"
#import "WriteView.h"

@interface WriteViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, readwrite, strong) WriteView *writeView;
@property (nonatomic, readwrite, strong) NSLayoutConstraint *constraintToAdjust;

@end

@implementation WriteViewController

- (instancetype)init
{
	if (self = [super init]) {
		self.title = @"Write";
	}
	return self;
}

- (void)loadView
{
	_writeView = [[WriteView alloc] initWithDelegate:self];
	[self setView:_writeView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																						   action:@selector(hideKeyboard)];

	[self.navigationController.view addGestureRecognizer:tapGestureRecognizer];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.tabBarController.navigationItem.title = @"New Story";
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Lazy loading methods


#pragma mark - Keyboard delegate
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

#pragma mark - Action methods
- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info
{
	UITextView *textView = self.writeView.textView;

    // Transform the UIViewAnimationCurve to a UIViewAnimationOptions mask.
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }

    [textView setNeedsUpdateConstraints];

    if (showKeyboard) {
        UIDeviceOrientation orientation = (UIDeviceOrientation)self.interfaceOrientation;
        BOOL isPortrait = UIDeviceOrientationIsPortrait(orientation);

        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;

        // Adjust the constraint constant to include the keyboard's height.
        self.constraintToAdjust.constant += height;
    }
    else {
        self.constraintToAdjust.constant = 0;
    }

    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];

    // Now that the frame has changed, move to the selection or point of edit.
    NSRange selectedRange = textView.selectedRange;
    [textView scrollRangeToVisible:selectedRange];
}

- (void)hideKeyboard
{
	[self.writeView endEditing:YES];
}

@end
