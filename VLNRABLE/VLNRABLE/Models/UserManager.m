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

@interface UserManager ()

@property (nonatomic, readwrite, strong) User *user;
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
		VLNRLogInfo(@"Response: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
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
		VLNRLogInfo(@"Response: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
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
	if (!responseObject.allKeys.count || !responseObject.allValues.count) {
		return;
	}

	responseObject = [responseObject dictionaryByReplacingNullsWithEmptyStrings];

	// Begin fetch & save requests.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:[User fetchBatchSize]
																	   faults:NO];

	NSDictionary *userInfo = responseObject[@"user"];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@", [userInfo valueForKey:@"id"]];
	[fetchRequest setPredicate:predicate];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

	NSError *error;
	User *user = [[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
	if (!user) {
		user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];

		user.user_id = @([[userInfo valueForKey:@"id"] integerValue]);
		user.username = [userInfo valueForKey:@"name"];
		user.email = [userInfo valueForKey:@"email"];
		user.password = [userInfo valueForKey:@"password"];
		user.passcode = [userInfo valueForKey:@"passcode"];
		user.created_at = [dateFormatter dateFromString:[userInfo valueForKey:@"created_at"]];
		user.updated_at = [dateFormatter dateFromString:[userInfo valueForKey:@"updated_at"]];
	}

	[self fetchUserWithCompletionBlock:nil];
	[[CoreDataManager sharedManager] savePrivateQueueContext];
}

#pragma mark - FETCH methods
- (void)fetchUserWithCompletionBlock:(UserManagerCompletionBlock)completionBlock
{
	// Begin fetch request.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:[User fetchBatchSize]
																	   faults:NO];

	NSError *error;
	self.user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] firstObject];
	if (completionBlock) completionBlock(self.user);
}

@end
