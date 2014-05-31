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

#define DISCARD_ALERT_TAG 800

@interface WriteViewController () <UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, readwrite, strong) WriteView *writeView;
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
	_writeView.textField.textColor = [UIColor blackColor];
	_writeView.textField.textLabel.textColor = [VLNRColor tealColor];
	_writeView.textField.textLabel.font = [VLNRAppManager systemFont];
	_writeView.textField.textLabel.text = @"Title:";
	_writeView.toolbar.checkbox.text = @"Add Anonymously";

	[_writeView.toolbar.checkbox addTarget:self
									action:@selector(checkboxAction:)
						  forControlEvents:UIControlEventTouchUpInside];

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxAction:)];
	[_writeView.toolbar.checkbox.textLabel addGestureRecognizer:tapGesture];

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

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidChange:)
												 name:UITextViewTextDidChangeNotification
											   object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.tabBarController.navigationItem.leftBarButtonItem = self.cancelButton;
	self.tabBarController.navigationItem.rightBarButtonItem = self.doneButton;

	if (!self.writeView.textField.text.length) {
		[self.writeView.textField becomeFirstResponder];
	} else {
		[self.writeView.textView becomeFirstResponder];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self textDidChange:nil];

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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if (!textField.inputAccessoryView) {
		textField.inputAccessoryView = self.writeView.toolbar;
		[textField.inputAccessoryView sizeToFit];
	}
	return YES;
}


#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (!textView.inputAccessoryView) {
		textView.inputAccessoryView = self.writeView.toolbar;
		[textView.inputAccessoryView sizeToFit];
	}
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (textView.text.length - range.length + text.length > self.writeView.toolbar.maxLength) {
		return NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	CGRect currentTextLine = [textView caretRectForPosition:textView.selectedTextRange.start];
	CGFloat overflow = currentTextLine.origin.y + currentTextLine.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);

	if (overflow > 0) {
		CGFloat margin = 7.0f;
		CGPoint contentOffset = textView.contentOffset;
		contentOffset.y += overflow + margin;
		[UIView animateWithDuration:0.3 animations:^{
			textView.contentOffset = contentOffset;
		}];
	}
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

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag) {
		case DISCARD_ALERT_TAG:
			if (buttonIndex == 1) {
				[self discardAction];
			}
			break;

		default:
			break;
	}
}

#pragma mark - Action methods
- (void)textDidChange:(NSNotification *)notification
{
	NSUInteger textLength = self.writeView.textView.text.length;
	NSUInteger currentLength = self.writeView.toolbar.maxLength - textLength;
	self.writeView.toolbar.textLabel.text = [NSString stringWithFormat:@"%i", currentLength];
}

- (void)checkboxAction:(id)sender
{
	UIButton *checkbox = self.writeView.toolbar.checkbox;
	if ([checkbox isSelected]) {
		[checkbox setSelected:NO];
	} else {
		[checkbox setSelected:YES];
	}

	// TODO: Make story author anonymous.
}

- (void)hideKeyboard:(id)sender
{
	[self.writeView endEditing:YES];
}

- (void)cancelAction:(id)sender
{
	if (!self.writeView.textField.text.length && !self.writeView.textView.text.length) {
		[self discardAction];
		return;
	}

	UIAlertView *discardAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to discard this story?"
														   message:nil
														  delegate:self
												 cancelButtonTitle:@"Cancel"
												 otherButtonTitles:@"Discard", nil];
	discardAlert.tag = DISCARD_ALERT_TAG;
	[discardAlert show];
}

- (void)doneAction:(id)sender
{
	[self hideKeyboard:sender];
	[self.tabBarController setSelectedIndex:0];
}

- (void)discardAction
{
	[self hideKeyboard:nil];
	self.writeView.textField.text = nil;
	self.writeView.textView.text = nil;
	[self.tabBarController setSelectedIndex:[(TabBarViewController *)self.tabBarController previousSelectedIndex]];
}

@end
