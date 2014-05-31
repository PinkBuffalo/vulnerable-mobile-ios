//
//  WriteViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/30/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "WriteViewController.h"
#import "WriteView.h"
#import "TabBarViewController.h"

@interface WriteViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, readwrite, strong) WriteView *writeView;
@property (nonatomic, readwrite, strong) UIView *accessoryView;
@property (nonatomic, readwrite, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, readwrite, strong) UIBarButtonItem *doneButton;
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
	_writeView.textField.textLabel.textColor = [VLNRColor tealColor];
	_writeView.textField.textLabel.font = [VLNRAppManager systemFont];
	_writeView.textField.textLabel.text = @"Title:";
	[self setView:_writeView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																						   action:@selector(hideKeyboard:)];

	[self.tabBarController.navigationController.navigationBar addGestureRecognizer:tapGestureRecognizer];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.tabBarController.navigationItem.leftBarButtonItem = self.cancelButton;
	self.tabBarController.navigationItem.rightBarButtonItem = self.doneButton;

	[self.writeView.textField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.tabBarController.navigationItem.title = @"New Story";
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	self.tabBarController.navigationItem.leftBarButtonItem = nil;
	self.tabBarController.navigationItem.rightBarButtonItem = nil;
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
- (UIBarButtonItem *)cancelButton
{
	if (!_cancelButton) {
		_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	  target:self
																	  action:@selector(cancelAction:)];
		_cancelButton.tintColor = [UIColor whiteColor];
	}
	return _cancelButton;
}

- (UIBarButtonItem *)doneButton
{
	if (!_doneButton) {
		_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																	target:self
																	action:@selector(doneAction:)];
		_doneButton.tintColor = [UIColor whiteColor];
	}
	return _doneButton;
}

#pragma mark - Text field delegate


#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (!textView.inputAccessoryView) {
		textView.inputAccessoryView = self.accessoryView;
	}
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[textView resignFirstResponder];
	return YES;
}

#pragma mark - Keyboard delegate
- (void)keyboardWillShow:(NSNotification *)notification
{
	UITextView *textView = self.writeView.textView;

	// Get view bounds of keyboard.
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	keyboardRect = [self.view convertRect:keyboardRect toView:nil];

	// Adjust the content inset to incorporate the keyboard height.
	UIEdgeInsets contentInsets = textView.contentInset;
	contentInsets.bottom = CGRectGetHeight(keyboardRect) - self.writeView.textFieldHeight;

	textView.contentInset = contentInsets;
	textView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	UITextView *textView = self.writeView.textView;

	UIEdgeInsets contentInsets = textView.contentInset;
	contentInsets.bottom = 0;

	textView.contentInset = contentInsets;
	textView.scrollIndicatorInsets = contentInsets;

	[textView.superview layoutIfNeeded];
}

#pragma mark - Action methods
- (void)hideKeyboard:(id)sender
{
	[self.writeView endEditing:YES];
}

- (void)cancelAction:(id)sender
{
	[self hideKeyboard:sender];
	[self.tabBarController setSelectedIndex:[(TabBarViewController *)self.tabBarController previousSelectedIndex]];
}

- (void)doneAction:(id)sender
{
	[self hideKeyboard:sender];
	[self.tabBarController setSelectedIndex:0];
}

@end
