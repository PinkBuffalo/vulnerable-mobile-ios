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
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CoreDataManager.h"
#import "NSDictionary+VLNRAdditions.h"
#import "NSFetchRequest+VLNRAdditions.h"

NSString * const kUserEmailKey = @"UserEmailKey";
NSString * const kUserLocationKey = @"UserLocationKey";
NSString * const kUserNicknameKey = @"UserNicknameKey";
NSString * const kUserObjectIdKey = @"UserObjectIdKey";
NSString * const kUserPasscodeKey = @"UserPasscodeKey";
NSString * const kUserSessionTokenKey = @"UserSessionTokenKey";

NSString * const kUserManagerUserDidFinishLoadingNotification = @"UserManagerUserDidFinishLoadingNotification";
NSString * const kUserManagerUserDidFailLoadingNotification = @"UserManagerUserDidFailLoadingNotification";

@interface UserManager () <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) NSSet *users;
@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;
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

#pragma mark - Lazy loading methods
- (CLLocationManager *)locationManager
{
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locationManager.distanceFilter = kCLDistanceFilterNone;
		_locationManager.headingFilter = kCLHeadingFilterNone;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
	}
	return _locationManager;
}

#pragma mark - GET methods
- (void)getUserWithSuccessBlock:(UserManagerSuccessBlock)successBlock
				   failureBlock:(UserManagerFailureBlock)failureBlock
{
	self.loading = YES;

	__typeof__(self) __weak weakSelf = self;

	NSString *sessionToken = self.user.sessionToken ?: [[NSUserDefaults standardUserDefaults] objectForKey:kUserSessionTokenKey];
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	[manager.requestSerializer setValue:sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager GET:@"https://api.parse.com/1/users/me" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		[weakSelf saveUserDefaultsWithResponseObject:responseObject];
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
		[weakSelf saveUserDefaultsWithResponseObject:responseObject];
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
		[weakSelf saveUserDefaultsWithResponseObject:responseObject];
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

#pragma mark - PUT methods
- (void)updateUserWithUserInfo:(NSDictionary *)userInfo
				  successBlock:(UserManagerSuccessBlock)successBlock
				  failureBlock:(UserManagerFailureBlock)failureBlock
{
	self.loading = YES;

	NSString *urlString = [NSString stringWithFormat:@"https://api.parse.com/1/users/%@", self.user.objectId ?: [PFUser currentUser].objectId];
	NSString *sessionToken = self.user.sessionToken ?: userInfo[@"sessionToken"];

	VLNRLogVerbose(@"Parameters: %@", userInfo);

	NSMutableDictionary *parameters = [userInfo mutableCopy];
	for (NSString *key in userInfo) {
		if ([key isEqualToString:@"objectId"] || [key isEqualToString:@"sessionToken"]) {
			[parameters removeObjectForKey:key];
		}
	}

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	[manager.requestSerializer setValue:sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
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

- (void)updateLocationWithCompletionBlock:(UserManagerCompletionBlock)completionBlock
{
	if (!self.locationManager.location) {
		if (completionBlock) completionBlock(self.user);
		VLNRLogWarn(@"No location found@");
		return;
	}
	NSDictionary *parameters = @{ @"location": @{ @"__type": @"GeoPoint",
												  @"latitude": @(self.locationManager.location.coordinate.latitude),
												  @"longitude": @(self.locationManager.location.coordinate.longitude) }};

	__typeof__(self) __weak weakSelf = self;
	[[UserManager sharedManager] updateUserWithUserInfo:parameters successBlock:^(User *user) {
		VLNRLogInfo(@"User: %@", user);
		if (completionBlock) completionBlock(weakSelf.user);
	} failureBlock:^(NSError *error) {
		VLNRLogError(@"Error: %@", error.localizedDescription);
		if (completionBlock) completionBlock(weakSelf.user);
	}];
}

#pragma mark - SAVE methods
- (void)saveUserDefaultsWithResponseObject:(NSDictionary *)responseObject
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:responseObject[@"email"] forKey:kUserEmailKey];
	[defaults setObject:responseObject[@"nickname"] forKey:kUserNicknameKey];
	[defaults setObject:responseObject[@"objectId"] forKey:kUserObjectIdKey];
	[defaults setObject:responseObject[@"passcode"] forKey:kUserPasscodeKey];
	[defaults setObject:responseObject[@"sessionToken"] forKey:kUserSessionTokenKey];
	if (![defaults synchronize]) {
		VLNRLogError(@"Error: User defaults not synched!");
	}
}

- (void)saveUserWithResponseObject:(NSDictionary *)responseObject
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:1
																	   faults:NO];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", responseObject[@"objectId"]];
	[fetchRequest setPredicate:predicate];

	NSDateFormatter *dateFormatter = [VLNRAppManager stringToDateFormatter];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:responseObject[@"email"] forKey:kUserEmailKey];
	[defaults setObject:responseObject[@"nickname"] forKey:kUserNicknameKey];
	[defaults setObject:responseObject[@"objectId"] forKey:kUserObjectIdKey];
	[defaults setObject:responseObject[@"passcode"] forKey:kUserPasscodeKey];
	[defaults setObject:responseObject[@"sessionToken"] forKey:kUserSessionTokenKey];
	if (![defaults synchronize]) {
		VLNRLogError(@"Error: User defaults not synched!");
	}

	NSError *error;
	User *user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
	if (!user) {
		user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
	}
	user.email = responseObject[@"email"];
	user.nickname = responseObject[@"nickname"];
	user.objectId = responseObject[@"objectId"];
	user.passcode = responseObject[@"passcode"];
	user.latitude = responseObject[@"latitude"];
	user.longitude = responseObject[@"longitude"];
	user.sessionToken = responseObject[@"sessionToken"];
	user.username = responseObject[@"username"];
	user.createdAt = [dateFormatter dateFromString:responseObject[@"createdAt"]];
	user.updatedAt = [dateFormatter dateFromString:responseObject[@"updatedAt"]];

	[self fetchUserWithCompletionBlock:nil];
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

		NSDateFormatter *dateFormatter = [VLNRAppManager stringToDateFormatter];

		NSError *error;
		User *user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
		if (!user) {
			user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
		}
		user.email = userInfo[@"email"];
		user.nickname = userInfo[@"nickname"];
		user.objectId = userInfo[@"objectId"];
		user.passcode = userInfo[@"passcode"];
		user.latitude = userInfo[@"latitude"];
		user.longitude = userInfo[@"longitude"];
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

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", [defaults valueForKey:kUserObjectIdKey]];
	[fetchRequest setPredicate:predicate];

	NSError *error;
	User *user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] firstObject];
	user.latitude = @(self.locationManager.location.coordinate.latitude);
	user.longitude = @(self.locationManager.location.coordinate.longitude);
	self.user = user;
}

- (void)fetchUsersWithCompletionBlock:(UserManagerUsersCompletionBlock)completionBlock
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:[User fetchBatchSize]
																	   faults:NO];

	NSError *error;
	self.users = [NSSet setWithArray:[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error]];
	if (completionBlock) completionBlock(self.users);
}

#pragma mark - Facebook methods
- (void)requestFacebookDataWithCompletionBlock:(UserManagerCompletionBlock)completionBlock
{
	User *user;
	if (!self.user) {
		user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
		user.objectId = [PFUser currentUser].objectId;
		user.sessionToken = [PFUser currentUser].sessionToken;
		self.user.objectId = user.objectId;
		self.user.sessionToken = user.sessionToken;
	}

	__typeof__(self) __weak weakSelf = self;
	FBRequest *request = [FBRequest requestForMe];
	[request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
		if (error) {
			VLNRLogError(@"Error: %@", error);
		} else {
			NSDictionary *responseObject = (NSDictionary *)result;
			NSString *firstName = responseObject[@"first_name"];
			NSString *email = responseObject[@"email"];

			self.user.nickname = firstName;
			self.user.email = email;

			NSDictionary *userInfo = @{ @"objectId": [PFUser currentUser].objectId,
										@"sessionToken": [PFUser currentUser].sessionToken,
										@"email": email,
										@"nickname": firstName };

			if ([UserManager sharedManager].isLoading) {
				if (completionBlock) completionBlock(weakSelf.user);
				return;
			}

			[[UserManager sharedManager] updateUserWithUserInfo:userInfo successBlock:^(User *user) {
				VLNRLogInfo(@"User: %@", user);
				if (completionBlock) completionBlock(weakSelf.user);
			} failureBlock:^(NSError *error) {
				VLNRLogError(@"Error: %@", error);
				if (completionBlock) completionBlock(weakSelf.user);
			}];
		}
	}];
}

@end
