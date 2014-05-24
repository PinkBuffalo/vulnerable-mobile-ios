//
//  NSFetchRequest+VLNRAdditions.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (VLNRAdditions)

+ (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName
									 batchSize:(NSUInteger)batchSize
										faults:(BOOL)faults;

@end
