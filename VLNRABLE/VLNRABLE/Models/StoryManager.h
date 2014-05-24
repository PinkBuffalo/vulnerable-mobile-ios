//
//  StoryManager.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Story;
@class User;

#define kStoryManagerFetchBatchSize 20

typedef void (^StoryManagerSuccessBlock)(NSSet *stories);
typedef void (^StoryManagerFailureBlock)(NSError *error);
typedef void (^StoryManagerCompletionBlock)(NSSet *stories);

@interface StoryManager : NSObject

@property (nonatomic, readonly, strong) NSSet *stories;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

+ (StoryManager *)sharedManager;

- (void)getStoriesForUser:(User *)user
			 successBlock:(StoryManagerSuccessBlock)successBlock
			 failureBlock:(StoryManagerFailureBlock)failureBlock;

- (void)postStoryForUser:(User *)user
			successBlock:(StoryManagerSuccessBlock)successBlock
			failureBlock:(StoryManagerFailureBlock)failureBlock;

- (void)fetchStoriesForUser:(User *)user
			completionBlock:(StoryManagerCompletionBlock)completionBlock;

@end
