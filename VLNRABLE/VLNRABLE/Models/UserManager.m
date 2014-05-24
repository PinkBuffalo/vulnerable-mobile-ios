//
//  UserManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "UserManager.h"
#import "User.h"
#import "Story.h"
#import "StoryManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CoreDataManager.h"
#import "NSDictionary+VLNRAdditions.h"
#import "NSFetchRequest+VLNRAdditions.h"

static NSString * const kUserObjectIdKey = @"UserObjectIdKey";
static NSString * const kUserSessionTokenKey = @"UserSessionTokenKey";

NSString * const kUserManagerUserDidFinishLoadingNotification = @"UserManagerUserDidFinishLoadingNotification";
NSString * const kUserManagerUserDidFailLoadingNotification = @"UserManagerUserDidFailLoadingNotification";

@interface UserManager ()

@property (nonatomic, readwrite, strong) User *user;
@property (nonatomic, readwrite, strong) NSSet *users;
@property (nonatomic, assign) BOOL loading;

@end

@implementation UserManager

#pragma mark - Singleton access methods
+ (UserManager *)sharedManager
{
	static UserManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[UserManager alloc] init];
		[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	});
	return sharedManager;
}

#pragma mark - GET methods
- (void)loginUserWithUserInfo:(NSDictionary *)userInfo
			   successBlock:(UserManagerSuccessBlock)successBlock
			   failureBlock:(UserManagerFailureBlock)failureBlock
{
	self.loading = YES;

	NSDictionary *parameters = @{ @"username" : userInfo[@"username"],
								  @"password" : userInfo[@"password"] };

	VLNRLogVerbose(@"Parameters: %@", parameters);

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager GET:@"https://api.parse.com/1/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		[weakSelf saveUserWithResponseObject:responseObject];
		VLNRLogInfo(@"Response: %@", responseObject);
		[[NSNotificationCenter defaultCenter] postNotificationName:kUserManagerUserDidFinishLoadingNotification object:nil];
		successBlock(weakSelf.user);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
		[[NSNotificationCenter defaultCenter] postNotificationName:kUserManagerUserDidFailLoadingNotification object:nil];
		failureBlock(error);
	}];
}

- (void)getUsersWithSuccessBlock:(UserManagerUsersSuccessBlock)successBlock
					failureBlock:(UserManagerUsersFailureBlock)failureBlock
{
	self.loading = YES;

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager GET:@"https://api.parse.com/1/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		[weakSelf saveUsersWithResponseObject:responseObject];
		VLNRLogInfo(@"Response: %@", responseObject);
		successBlock(weakSelf.users);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
		failureBlock(error);
	}];
}

#pragma mark - POST methods
- (void)signUpUserWithUserInfo:(NSDictionary *)userInfo
				  successBlock:(UserManagerSuccessBlock)successBlock
				  failureBlock:(UserManagerFailureBlock)failureBlock
{
	self.loading = YES;

	NSDictionary *parameters = @{ @"nickname" : userInfo[@"nickname"],
								  @"username" : userInfo[@"username"],
								  @"email" : userInfo[@"username"],
								  @"password" : userInfo[@"password"] };

	VLNRLogVerbose(@"Parameters: %@", parameters);

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager POST:@"https://api.parse.com/1/users" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		[weakSelf saveUsersWithResponseObject:responseObject];
		VLNRLogInfo(@"Response: %@", responseObject);
		[[NSNotificationCenter defaultCenter] postNotificationName:kUserManagerUserDidFinishLoadingNotification object:nil];
		successBlock(weakSelf.user);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
		[[NSNotificationCenter defaultCenter] postNotificationName:kUserManagerUserDidFailLoadingNotification object:nil];
		failureBlock(error);
	}];
}

#pragma mark - PATCH methods
- (void)updateUserWithUserInfo:(NSDictionary *)userInfo
				  successBlock:(UserManagerSuccessBlock)successBlock
				  failureBlock:(UserManagerFailureBlock)failureBlock
{

}

#pragma mark - PUT methods
- (void)replaceUserWithUserInfo:(NSDictionary *)userInfo
				   successBlock:(UserManagerSuccessBlock)successBlock
				   failureBlock:(UserManagerFailureBlock)failureBlock
{

}

#pragma mark - SAVE methods
- (void)saveUserWithResponseObject:(NSDictionary *)responseObject
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:1
																	   faults:NO];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", responseObject[@"objectId"]];
	[fetchRequest setPredicate:predicate];

	NSDateFormatter *dateFormatter = [VLNRApplicationManager stringToDateFormatter];

	NSError *error;
	User *user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
	if (!user) {
		user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
	}
	user.email = responseObject[@"email"];
	user.nickname = responseObject[@"nickname"];
	user.objectId = responseObject[@"objectId"];
	user.passcode = responseObject[@"passcode"];
	user.sessionToken = responseObject[@"sessionToken"];
	user.username = responseObject[@"username"];
	user.createdAt = [dateFormatter dateFromString:responseObject[@"createdAt"]];
	user.updatedAt = [dateFormatter dateFromString:responseObject[@"updatedAt"]];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:user.objectId forKey:kUserObjectIdKey];
	[userDefaults setObject:user.sessionToken forKey:kUserSessionTokenKey];
	if (![userDefaults synchronize]) {
		VLNRLogError(@"Error: User defaults not synched!");
	}

	self.user = user;
}

- (void)saveUsersWithResponseObject:(NSDictionary *)responseObject
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:[User fetchBatchSize]
																	   faults:NO];

	NSArray *results = responseObject[@"results"];
	for (NSDictionary *userInfo in results) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", userInfo[@"objectId"]];
		[fetchRequest setPredicate:predicate];

		NSDateFormatter *dateFormatter = [VLNRApplicationManager stringToDateFormatter];

		NSError *error;
		User *user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
		if (!user) {
			user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
		}
		user.email = userInfo[@"email"];
		user.nickname = userInfo[@"nickname"];
		user.objectId = userInfo[@"objectId"];
		user.passcode = userInfo[@"passcode"];
		user.sessionToken = userInfo[@"sessionToken"];
		user.username = userInfo[@"username"];
		user.createdAt = [dateFormatter dateFromString:userInfo[@"createdAt"]];
		user.updatedAt = [dateFormatter dateFromString:userInfo[@"updatedAt"]];
	}

	[self fetchUsersWithCompletionBlock:nil];
}

#pragma mark - FETCH methods
- (void)fetchUserWithCompletionBlock:(UserManagerCompletionBlock)completionBlock
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:1
																	   faults:NO];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectID == %@", [[NSUserDefaults standardUserDefaults]objectForKey:kUserObjectIdKey]];
	[fetchRequest setPredicate:predicate];

	NSError *error;
	self.user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] firstObject];
	if (completionBlock) completionBlock(self.user);
}

- (void)fetchUsersWithCompletionBlock:(UserManagerUsersCompletionBlock)completionBlock
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:[User fetchBatchSize]
																	   faults:NO];

	NSError *error;
	self.users = [NSSet setWithArray:[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error]];
	if (completionBlock) completionBlock([self.users copy]);
}

@end
