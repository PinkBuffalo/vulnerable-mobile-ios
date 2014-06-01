//
//  WriteView.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/30/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "WriteView.h"
#import "VLNRTextView.h"

@interface WriteView ()

@property (nonatomic, readwrite, strong) DetailTextField *textField;
@property (nonatomic, readwrite, strong) VLNRTextView *textView;
@property (nonatomic, readwrite, strong) WriteToolbar *toolbar;
@property (nonatomic, readwrite, strong) UIScrollView *scrollView;

@end

@implementation WriteView

- (id)initWithDelegate:(id<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>)delegate
{
    if (self = [super init]) {
		_padding = 5.0f;
		_textFieldHeight = 44.0f;

		_scrollView = [[UIScrollView alloc] init];
		_scrollView.delegate = delegate;

		_toolbar = [[WriteToolbar alloc] init];

		_textField = [[DetailTextField alloc] init];
		_textField.delegate = delegate;
		_textField.font = [VLNRAppManager largeSystemFont];
		_textField.borderStyle = UITextBorderStyleNone;
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.layer.borderColor = [UIColor whiteColor].CGColor;
		_textField.layer.borderWidth = 0.0f;
		_textField.placeholder = @"Your story needs a title...";

		_textView = [[VLNRTextView alloc] init];
		_textView.delegate = delegate;
		_textView.textColor = [UIColor blackColor];
		_textView.layer.borderColor = [VLNRColor lightTealColor].CGColor;
		_textView.layer.borderWidth = 1.0f;
		_textView.placeholder = @"What story would you like to tell?";

		[_scrollView addSubview:_textField];
		[_scrollView addSubview:_textView];
		[_scrollView addSubview:_toolbar];
		[self addSubview:_scrollView];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	CGFloat xOrigin = bounds.origin.x;
	CGFloat yOrigin = bounds.origin.y;

	_scrollView.frame = bounds;

	_textField.frame = CGRectMake(xOrigin,
								  yOrigin,
								  bounds.size.width,
								  _textFieldHeight);

	yOrigin += _textField.frame.size.height;

	_textView.frame = CGRectMake(xOrigin,
								 yOrigin,
								 bounds.size.width,
								 bounds.size.height - _textField.frame.size.height);
}

@end
