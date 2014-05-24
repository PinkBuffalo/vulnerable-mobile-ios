//
//  NSArray+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "NSArray+VLNRAdditions.h"
#import "NSDictionary+VLNRAdditions.h"

@implementation NSArray (VLNRAdditions)

- (NSArray *)arrayByReplacingNullsWithEmptyStrings
{
	const NSMutableArray *tempArray = [self mutableCopy];
	const id null = [NSNull null];
	const NSString *emptyString = @"";
	for (int i = 0; i < tempArray.count; i++) {
		id object = [tempArray objectAtIndex:i];
		if (object == null) {
			[tempArray replaceObjectAtIndex:i withObject:emptyString];
		} else if ([object isKindOfClass:[NSDictionary class]]) {
			[tempArray replaceObjectAtIndex:i withObject:[object dictionaryByReplacingNullsWithEmptyStrings]];
		} else if ([object isKindOfClass:[NSArray class]]) {
			[tempArray replaceObjectAtIndex:i withObject:[object arrayByReplacingNullsWithEmptyStrings]];
		}
	}
	return [tempArray copy];
}

@end
