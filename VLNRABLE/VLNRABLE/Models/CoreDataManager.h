//
//  CoreDataManager.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/9/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (instancetype)sharedManager;

- (NSURL *)persistentStoreURL;
- (NSDictionary *)persistentStoreOptions;
- (BOOL)migrationIsNeeded;

- (void)saveMainQueueContext;
- (void)savePrivateQueueContext;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;

@end
