//
//  UserManager.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Story;

#define kUserManagerFetchBatchSize 1

typedef void (^UserManagerSuccessBlock)(User *user);
typedef void (^UserManagerFailureBlock)(NSError *error);
typedef void (^UserManagerCompletionBlock)(User *user);

@interface UserManager : NSObject

@property (nonatomic, readonly, strong) User *user;
@property (nonatomic, assign, getter = isUserLoading) BOOL userIsLoading;

+ (UserManager *)sharedManager;

- (void)getUserWithUserInfo:(NSDictionary *)userInfo
			   successBlock:(UserManagerSuccessBlock)successBlock
			   failureBlock:(UserManagerFailureBlock)failureBlock;

- (void)postUserWithUserInfo:(NSDictionary *)userInfo
				successBlock:(UserManagerSuccessBlock)successBlock
				failureBlock:(UserManagerFailureBlock)failureBlock;

- (void)fetchUserWithCompletionBlock:(UserManagerCompletionBlock)completionBlock;

@end
