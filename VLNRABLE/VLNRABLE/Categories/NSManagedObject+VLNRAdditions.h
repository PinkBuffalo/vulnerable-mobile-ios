//
//  NSManagedObject+VLNRAdditions.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (VLNRAdditions)

+ (instancetype)createManagedObjectInContext:(NSManagedObjectContext *)context;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

+ (NSString *)entityName;
+ (NSUInteger)fetchBatchSize;

@end
