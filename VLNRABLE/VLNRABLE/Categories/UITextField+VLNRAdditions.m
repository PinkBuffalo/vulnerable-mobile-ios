//
//  UITextField+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 4/13/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "UITextField+VLNRAdditions.h"

@implementation UITextField (VLNRAdditions)

- (id)init
{
    if (self == [super init]) {
		self.backgroundColor = [VLNRColor lightTealColor];
		self.borderStyle = UITextBorderStyleRoundedRect;
		self.font = [UIFont systemFontOfSize:16.0f];
		self.keyboardAppearance = UIKeyboardAppearanceLight;
		self.textColor = [VLNRColor tealColor];

		self.layer.borderColor = [VLNRColor lightTealTextColor].CGColor;
		self.layer.borderWidth = 1.0f;
		self.layer.cornerRadius = 6.0f;
    }
    return self;
}

- (id)initWithDelegate:(id<UITextFieldDelegate>)delegate
{
	if (self == [super init]) {
		self.backgroundColor = [VLNRColor lightTealColor];
		self.borderStyle = UITextBorderStyleRoundedRect;
		self.delegate = delegate;
		self.font = [UIFont systemFontOfSize:16.0f];
		self.keyboardAppearance = UIKeyboardAppearanceLight;
		self.textColor = [VLNRColor tealColor];

		self.layer.borderColor = [VLNRColor lightTealTextColor].CGColor;
		self.layer.borderWidth = 1.0f;
		self.layer.cornerRadius = 8.0f;
    }
    return self;
}

- (id)initWithDelegate:(id<UITextFieldDelegate>)delegate
		   placeholder:(NSString *)placeholder
{
	if (self == [super init]) {
		self.backgroundColor = [VLNRColor lightTealColor];
		self.borderStyle = UITextBorderStyleRoundedRect;
		self.delegate = delegate;
		self.font = [UIFont systemFontOfSize:16.0f];
		self.keyboardAppearance = UIKeyboardAppearanceLight;
		self.textColor = [VLNRColor tealColor];

		NSAttributedString *placeHolderString = [[NSAttributedString alloc] initWithString:placeholder
																				attributes:@{ NSForegroundColorAttributeName: [VLNRColor lightTealTextColor] }];
		self.attributedPlaceholder = placeHolderString;

		self.layer.borderColor = [VLNRColor lightTealTextColor].CGColor;
		self.layer.borderWidth = 1.0f;
		self.layer.cornerRadius = 8.0f;
    }
    return self;
}

@end
