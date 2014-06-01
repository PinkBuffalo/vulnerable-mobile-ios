//
//  VLNRTextView.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "VLNRTextView.h"

#define PLACEHOLDER_LABEL_TAG 999

static CGFloat const UIPlaceholderTextChangedAnimationDuration = 0.3f;

@interface VLNRTextView ()

@property (nonatomic, readwrite, strong) UILabel *placeholderLabel;

@end

@implementation VLNRTextView

- (instancetype)init
{
	if (self = [super init]) {
		_padding = 5.0f;

		self.textContainerInset = UIEdgeInsetsMake((_padding * 2.0f),
												   _padding,
												   (_padding * 2.0f),
												   _padding);

		self.font = [VLNRAppManager largeSystemFont];

		_placeholder = @"";
		_placeholderColor = [UIColor lightGrayColor];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(textDidChange:)
													 name:UITextViewTextDidChangeNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)placeholderLabel
{
	if (!_placeholderLabel) {
		_placeholderLabel = [[UILabel alloc] init];
		_placeholderLabel.frame = CGRectInset(self.bounds, (_padding * 2.0f), (_padding * 2.0f));
		_placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_placeholderLabel.numberOfLines = 0;
		_placeholderLabel.font = self.font;
		_placeholderLabel.backgroundColor = [UIColor clearColor];
		_placeholderLabel.textColor = self.placeholderColor;
		_placeholderLabel.alpha = 0.0f;
		_placeholderLabel.tag = PLACEHOLDER_LABEL_TAG;
		[self addSubview:_placeholderLabel];
	}
	return _placeholderLabel;
}

- (void)setText:(NSString *)text
{
	[super setText:text];

	[self textDidChange:nil];
}

- (void)drawRect:(CGRect)rect
{
	if (self.placeholder.length) {
		self.placeholderLabel.text = self.placeholder;
		[self.placeholderLabel sizeToFit];
		[self sendSubviewToBack:self.placeholderLabel];
	}

	if (!self.text.length && self.placeholder.length > 0) {
		[self viewWithTag:PLACEHOLDER_LABEL_TAG].alpha = 1.0f;
	}

	rect = CGRectInset(rect, (_padding * 4.0f), (_padding * 4.0f));
	[super drawRect:rect];
}

- (void)textDidChange:(NSNotification *)notification
{
	if (!self.placeholder.length) {
		return;
	}

	[UIView animateWithDuration:UIPlaceholderTextChangedAnimationDuration animations:^{
		if (!self.text.length) {
			[self viewWithTag:PLACEHOLDER_LABEL_TAG].alpha = 1.0f;
		} else {
			[self viewWithTag:PLACEHOLDER_LABEL_TAG].alpha = 0.0f;
		}
	}];
}

@end
