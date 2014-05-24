//
//  NSFetchRequest+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "NSFetchRequest+VLNRAdditions.h"

@implementation NSFetchRequest (VLNRAdditions)

+ (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName
									 batchSize:(NSUInteger)batchSize
										faults:(BOOL)faults
{
	NSFetchRequest *fetchRequest  = [self fetchRequestWithEntityName:entityName];
	[fetchRequest setFetchBatchSize:batchSize];
	[fetchRequest setReturnsObjectsAsFaults:faults];
	return fetchRequest;
}

@end
