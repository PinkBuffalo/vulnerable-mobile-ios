//
//  WriteToolbar.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "WriteToolbar.h"

@interface WriteToolbar ()

@property (nonatomic, readwrite) NSUInteger maxLength;
@property (nonatomic, readwrite, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, readwrite, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, readwrite, strong) UILabel *textLabel;
@property (nonatomic, readwrite, strong) VLNRCheckbox *checkbox;

@end

@implementation WriteToolbar

- (id)init
{
    if (self = [super init]) {
		self.backgroundColor = [UIColor whiteColor];
		self.barStyle = UIBarStyleDefault;

		_padding = 5.0f;
		_maxLength = 1000;

		_checkbox = [[VLNRCheckbox alloc] init];
		[_checkbox sizeToFit];

		_textLabel = [[UILabel alloc] init];
		_textLabel.font = [VLNRAppManager boldLargeSystemFont];
		_textLabel.textColor = [VLNRColor tealColor];
		_textLabel.text = [NSString stringWithFormat:@"%i", _maxLength];
		_textLabel.textAlignment = NSTextAlignmentRight;
		[_textLabel sizeToFit];

		_leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_checkbox];

		_rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_textLabel];

		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

		self.items = @[ _leftBarButtonItem, flexibleSpace, _rightBarButtonItem ];
    }
    return self;
}

@end
