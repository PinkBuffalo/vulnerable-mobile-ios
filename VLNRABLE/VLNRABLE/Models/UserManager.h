//
//  UserManager.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

extern NSString * const kUserManagerUserDidFinishLoadingNotification;
extern NSString * const kUserManagerUserDidFailLoadingNotification;

#import <Foundation/Foundation.h>

@class User;
@class Story;

typedef void (^UserManagerSuccessBlock)(User *user);
typedef void (^UserManagerFailureBlock)(NSError *error);
typedef void (^UserManagerCompletionBlock)(User *user);
typedef void (^UserManagerUsersSuccessBlock)(NSSet *users);
typedef void (^UserManagerUsersFailureBlock)(NSError *error);
typedef void (^UserManagerUsersCompletionBlock)(NSSet *users);

@interface UserManager : NSObject

@property (nonatomic, readonly, strong) User *user;
@property (nonatomic, readonly, strong) NSSet *users;
@property (nonatomic, readonly, strong) CLLocationManager *locationManager;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

+ (UserManager *)sharedManager;

- (void)getUserWithSuccessBlock:(UserManagerSuccessBlock)successBlock
				   failureBlock:(UserManagerFailureBlock)failureBlock;

- (void)loginUserWithUserInfo:(NSDictionary *)userInfo
				 successBlock:(UserManagerSuccessBlock)successBlock
				 failureBlock:(UserManagerFailureBlock)failureBlock;

- (void)signUpUserWithUserInfo:(NSDictionary *)userInfo
				  successBlock:(UserManagerSuccessBlock)successBlock
				  failureBlock:(UserManagerFailureBlock)failureBlock;

- (void)updateUserWithUserInfo:(NSDictionary *)userInfo
				  successBlock:(UserManagerSuccessBlock)successBlock
				  failureBlock:(UserManagerFailureBlock)failureBlock;

- (void)updateLocationWithCompletionBlock:(UserManagerCompletionBlock)completionBlock;

- (void)getUsersWithSuccessBlock:(UserManagerUsersSuccessBlock)successBlock
					failureBlock:(UserManagerUsersFailureBlock)failureBlock;

- (void)fetchUserWithCompletionBlock:(UserManagerCompletionBlock)completionBlock;

- (void)fetchUsersWithCompletionBlock:(UserManagerUsersCompletionBlock)completionBlock;

@end
