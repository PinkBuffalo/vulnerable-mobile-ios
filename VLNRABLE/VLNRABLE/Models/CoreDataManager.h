//
//  CoreDataManager.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/9/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const kStoryEntityName;
extern NSString * const kUserEntityName;

@interface CoreDataManager : NSObject

+ (instancetype)sharedManager;

- (NSURL *)persistentStoreURL;
- (NSDictionary *)persistentStoreOptions;
- (void)saveMainQueueContext;
- (void)savePrivateQueueContext;

+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;

@end
