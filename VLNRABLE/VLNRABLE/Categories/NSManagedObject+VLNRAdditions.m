//
//  NSManagedObject+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "NSManagedObject+VLNRAdditions.h"

@implementation NSManagedObject (VLNRAdditions)

+ (instancetype)createManagedObjectInContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName]
											  inManagedObjectContext:context];
	return [[[self class] alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
										 inManagedObjectContext:context];
}

+ (NSString *)entityName
{
	return NSStringFromClass([self class]);
}

+ (NSUInteger)fetchBatchSize
{
	return 20;
}

@end
