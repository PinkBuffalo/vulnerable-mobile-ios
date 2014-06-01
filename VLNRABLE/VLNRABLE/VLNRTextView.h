//
//  VLNRTextView.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLNRTextView : UITextView

@property (nonatomic, readwrite) CGFloat padding;

@property (nonatomic, readwrite, strong) NSString *placeholder;
@property (nonatomic, readwrite, strong) UIColor *placeholderColor;

- (void)textDidChange:(NSNotification *)notification;

@end
