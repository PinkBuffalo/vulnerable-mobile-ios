//
//  WriteView.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/30/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "WriteView.h"

@interface WriteView ()

@property (nonatomic, readwrite, strong) UITextField *textField;
@property (nonatomic, readwrite, strong) UITextView *textView;
@property (nonatomic, readwrite, strong) UIToolbar *toolbar;

@end

@implementation WriteView

- (id)initWithDelegate:(id<UITextFieldDelegate,UITextViewDelegate>)delegate
{
    if (self = [super init]) {
		_padding = 5.0f;
		_textFieldHeight = 44.0f;

		_textField = [[UITextField alloc] init];
		_textField.delegate = delegate;
		_textField.borderStyle = UITextBorderStyleNone;
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.layer.borderColor = [UIColor whiteColor].CGColor;
		_textField.layer.borderWidth = 0.0f;

		_textView = [[UITextView alloc] init];
		_textView.delegate = delegate;
		_textView.layer.borderColor = [VLNRColor lightTealColor].CGColor;
		_textView.layer.borderWidth = 1.0f;

		[self addSubview:_textField];
		[self addSubview:_textView];
		[self addSubview:_toolbar];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;

	CGFloat xOrigin = bounds.origin.x;
	CGFloat yOrigin = bounds.origin.y;

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
