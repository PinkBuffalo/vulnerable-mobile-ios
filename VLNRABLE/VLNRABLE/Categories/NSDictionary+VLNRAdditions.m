//
//  NSDictionary+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "NSDictionary+VLNRAdditions.h"
#import "NSArray+VLNRAdditions.h"

@implementation NSDictionary (VLNRAdditions)

- (NSDictionary *)dictionaryByReplacingNullsWithEmptyStrings
{
	const NSMutableDictionary *tempDictionary = [self mutableCopy];
	const id null = [NSNull null];
	const NSString *emptyStr = @"";
	for (NSString *key in self) {
		id object = [self objectForKey:key];
		if (object == null) {
			[tempDictionary setObject:emptyStr forKey:key];
		} else if ([object isKindOfClass:[NSDictionary class]]) {
			[tempDictionary setObject:[object dictionaryByReplacingNullsWithEmptyStrings] forKey:key];
		} else if ([object isKindOfClass:[NSArray class]]) {
			[tempDictionary setObject:[object arrayByReplacingNullsWithEmptyStrings] forKey:key];
		}
	}
	return [tempDictionary copy];
}

- (id)objectForKeyNotNull:(id)key
{
	id object = [self objectForKey:key];
	if (object == [NSNull null] || !object) {
		return @"";
	}
	return object;
}

- (id)valueForKeyNotNull:(id)key
{
	id value = [self valueForKey:key];
	if (value == [NSNull null] || !value) {
		value = @"";
	}
	return value;
}

- (id)valueForKeyPathNotNull:(id)keyPath
{
	id value = [self valueForKeyPath:keyPath];
	if (value == [NSNull null] || !value) {
		return @"";
	}
	return value;
}

@end
