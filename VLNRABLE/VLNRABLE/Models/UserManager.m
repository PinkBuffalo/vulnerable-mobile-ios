//
//  UserManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "UserManager.h"
#import "User.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CoreDataManager.h"

@interface UserManager ()

@property (nonatomic, readwrite, strong) User *user;

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

//---------------------------------------------
/* Test User */
//---------------------------------------------
//											 //
//  ID: 4									 //
//  Name: Paris								 //
//  Email: paris@email.com					 //
//											 //
//---------------------------------------------
//---------------------------------------------

#pragma mark - Parsing methods
- (NSDictionary *)responseObjectFromResponseData:(NSData *)responseData
{
	NSError *responseError;
	return [NSJSONSerialization JSONObjectWithData:responseData
										   options:kNilOptions
											 error:&responseError];
}

#pragma mark - GET methods
- (void)getUserWithUserInfo:(NSDictionary *)userInfo
			   successBlock:(UserManagerSuccessBlock)successBlock
			   failureBlock:(UserManagerFailureBlock)failureBlock
{
	self.userIsLoading = YES;

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
	operation.requestSerializer = [AFHTTPRequestSerializer serializer];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation GET:@"http://localhost:3000/api/v1/users/4"
		parameters:nil
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
			   weakSelf.userIsLoading = NO;
			   NSDictionary *response = [weakSelf responseObjectFromResponseData:operation.responseData];
			   [weakSelf saveUserWithUserInfo:response];
			   NSLog(@"SUCCESS: %@", response);
		   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			   weakSelf.userIsLoading = NO;
			   NSDictionary *response = [weakSelf responseObjectFromResponseData:operation.responseData];
			   NSLog(@"FAILED: %@, %@", response, error);
		   }];
}

#pragma mark - POST methods
- (void)postUserWithUserInfo:(NSDictionary *)userInfo
				successBlock:(UserManagerSuccessBlock)successBlock
				failureBlock:(UserManagerFailureBlock)failureBlock
{
	self.userIsLoading = YES;

	__typeof__(self) __weak weakSelf = self;
	NSDictionary *parameters = @{ @"user": userInfo };
	AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
	operation.requestSerializer = [AFJSONRequestSerializer serializer];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation POST:@"http://localhost:3000/api/v1/users"
		 parameters:parameters
			success:^(AFHTTPRequestOperation *operation, id responseObject) {
				weakSelf.userIsLoading = NO;
				NSDictionary *response = [weakSelf responseObjectFromResponseData:operation.responseData];
				[weakSelf saveUserWithUserInfo:response];
				NSLog(@"SUCCESS: %@", response);
				successBlock(weakSelf.user);
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				weakSelf.userIsLoading = NO;
				NSDictionary *response = [weakSelf responseObjectFromResponseData:operation.responseData];
				NSLog(@"FAILED: %@, %@", response, error);
				failureBlock(error);
			}];
}

#pragma mark - SAVE methods
- (void)saveUserWithUserInfo:(NSDictionary *)userInfo
{
	if (!userInfo.allKeys.count || !userInfo.allValues.count) {
		return;
	}

	// Begin fetch & save requests.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kUserEntityName];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	[fetchRequest setFetchBatchSize:kUserManagerFetchBatchSize];

	NSDictionary *dictionary = userInfo[@"user"];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@", dictionary[@"id"]];
	[fetchRequest setPredicate:predicate];

	NSError *error;
	User *user = [[[CoreDataManager mainQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
	if (!user) {
		user = (User *)[NSEntityDescription insertNewObjectForEntityForName:kUserEntityName
													 inManagedObjectContext:[CoreDataManager mainQueueContext]];
	}

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

	user.user_id = @([dictionary[@"id"] integerValue]);
	user.username = dictionary[@"name"];
	user.email = dictionary[@"email"];
	user.created_at = [dateFormatter dateFromString:dictionary[@"created_at"]];
	user.updated_at = [dateFormatter dateFromString:dictionary[@"updated_at"]];

	[self fetchUserWithCompletionBlock:nil];
	[[CoreDataManager sharedManager] savePrivateQueueContext];
}

#pragma mark - FETCH methods
- (void)fetchUserWithCompletionBlock:(UserManagerCompletionBlock)completionBlock
{
	// Begin fetch request.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kUserEntityName];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	[fetchRequest setFetchBatchSize:kUserManagerFetchBatchSize];

	NSError *error;
	self.user = (User *)[[[CoreDataManager mainQueueContext] executeFetchRequest:fetchRequest error:&error] firstObject];
	if (completionBlock) completionBlock(self.user);
}

@end
