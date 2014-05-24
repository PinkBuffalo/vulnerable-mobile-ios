//
//  NSManagedObjectModel+VLNRAdditions.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (VLNRAdditions)

- (NSString *)modelName;
- (NSString *)modelNameForDirectory:(NSString *)directory;

+ (NSArray *)allModelPaths;
+ (NSArray *)modelPathsForDirectory:(NSString *)directory;

@end
