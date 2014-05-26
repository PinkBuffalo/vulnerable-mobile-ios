//
//  StoryManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "StoryManager.h"
#import "Story.h"
#import "UserManager.h"
#import "User.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CoreDataManager.h"
#import "NSDictionary+VLNRAdditions.h"
#import "NSFetchRequest+VLNRAdditions.h"

@interface StoryManager ()

@property (nonatomic, readwrite, strong) NSSet *stories;
@property (nonatomic, assign) BOOL loading;

@end

@implementation StoryManager

#pragma mark - Singleton access methods
+ (StoryManager *)sharedManager
{
	static StoryManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[StoryManager alloc] init];
		[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	});
	return sharedManager;
}

#pragma mark - GET methods
- (void)getStoriesWithSuccessBlock:(StoryManagerSuccessBlock)successBlock
					  failureBlock:(StoryManagerFailureBlock)failureBlock
{
	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager GET:@"https://api.parse.com/1/classes/Story" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		[weakSelf saveStoriesFromResponseObject:responseObject];
		VLNRLogInfo(@"Response: %@", responseObject);
		successBlock(weakSelf.stories);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
		failureBlock(error);
	}];
}

- (void)getStoriesForUser:(User *)user
			 successBlock:(StoryManagerSuccessBlock)successBlock
			 failureBlock:(StoryManagerFailureBlock)failureBlock
{
	self.loading = YES;

	/*
	PFQuery *query = [PFQuery queryWithClassName:@"Story"];
	[query getObjectInBackgroundWithId:@"wGZ73QnVkG" block:^(PFObject *object, NSError *error) {
		VLNRLogInfo(@"Story: %@", object);
		if (error) {
			VLNRLogError(@"Error: %@", error.localizedDescription);
		}
	}];
	 */

	NSDictionary *parameters;
	if (user) {
		parameters = @{ @"where" : @{ @"user" : @{ @"__type" : @"Pointer",
												   @"className" : @"_User",
												   @"objectId" : user.objectId } } };
	}

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager GET:@"https://api.parse.com/1/classes/Story" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		[weakSelf saveStoriesForUser:user withResponseObject:responseObject];
		VLNRLogInfo(@"Response: %@", responseObject);
		successBlock(weakSelf.stories);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
		failureBlock(error);
	}];
}

#pragma mark - SAVE methods
- (void)saveStoriesFromResponseObject:(NSDictionary *)responseObject
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Story entityName]
																	batchSize:[Story fetchBatchSize]
																	   faults:NO];

	NSArray *results = responseObject[@"results"];
	for (NSDictionary *storyInfo in results) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", storyInfo[@"objectId"]];
		[fetchRequest setPredicate:predicate];

		NSDateFormatter *dateFormatter = [VLNRAppManager stringToDateFormatter];

		NSError *error;
		Story *story = [[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
		if (!story) {
			story = [Story insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
		}
		story.content = storyInfo[@"content"];
		story.objectId = storyInfo[@"objectId"];
		story.status = storyInfo[@"status"];
		story.title = storyInfo[@"title"];
		story.createdAt = [dateFormatter dateFromString:storyInfo[@"createdAt"]];
		story.updatedAt = [dateFormatter dateFromString:storyInfo[@"updatedAt"]];

		NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	   batchSize:[User fetchBatchSize] faults:NO];

		NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"objectId == %@", [storyInfo valueForKeyPath:@"user.objectId"]];
		[userRequest setPredicate:userPredicate];

		NSError *userError;
		User *user = (User *)[[[CoreDataManager privateQueueContext] executeFetchRequest:userRequest error:&userError] lastObject];
		if (!user) {
			user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
		}
		[user addStoriesObject:story];
	}

	[self fetchStoriesWithCompletionBlock:nil];
}

- (void)saveStoriesForUser:(User *)user
		withResponseObject:(NSDictionary *)responseObject
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Story entityName]
																	batchSize:[Story fetchBatchSize]
																	   faults:NO];

	NSArray *results = responseObject[@"results"];
	for (NSDictionary *storyInfo in results) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", storyInfo[@"objectId"]];
		[fetchRequest setPredicate:predicate];

		NSDateFormatter *dateFormatter = [VLNRAppManager stringToDateFormatter];

		NSError *error;
		Story *story = [[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
		if (!story) {
			story = [Story insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
		}
		story.content = storyInfo[@"content"];
		story.objectId = storyInfo[@"objectId"];
		story.status = storyInfo[@"status"];
		story.title = storyInfo[@"title"];
		story.user = user;
		story.createdAt = [dateFormatter dateFromString:storyInfo[@"createdAt"]];
		story.updatedAt = [dateFormatter dateFromString:storyInfo[@"updatedAt"]];
	}

	[self fetchStoriesForUser:user completionBlock:nil];
}

- (void)saveUserForStory:(Story *)story
		   withStoryInfo:(NSDictionary *)storyInfo
{
	if (!storyInfo.allKeys.count || !storyInfo.allValues.count) {
		return;
	}

	storyInfo = [storyInfo dictionaryByReplacingNullsWithEmptyStrings];

	// Begin fetch & save requests.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[User entityName]
																	batchSize:[User fetchBatchSize]
																	   faults:NO];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectID == %@", [storyInfo valueForKeyPath:@"objectId"]];
	[fetchRequest setPredicate:predicate];

	NSError *error;
	User *user = [[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
	if (!user) {
		user = [User insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];
	}
	story.user = user;
}

#pragma mark - POST methods
- (void)postStoryForUser:(User *)user
			successBlock:(StoryManagerSuccessBlock)successBlock
			failureBlock:(StoryManagerFailureBlock)failureBlock
{

}

#pragma mark - FETCH methods
- (void)fetchStoriesWithCompletionBlock:(StoryManagerCompletionBlock)completionBlock
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Story entityName]
																	batchSize:[Story fetchBatchSize]
																	   faults:NO];

	NSError *error;
	self.stories = [NSSet setWithArray:[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error]];
	if (completionBlock) completionBlock([self.stories copy]);
}

- (void)fetchStoriesForUser:(User *)user
			completionBlock:(StoryManagerCompletionBlock)completionBlock
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Story entityName]
																	batchSize:[Story fetchBatchSize]
																	   faults:NO];

	NSError *error;
	if (user) {
		user.stories = [NSSet setWithArray:[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error]];
		if (completionBlock) completionBlock([user.stories copy]);
	} else {
		self.stories = [NSSet setWithArray:[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error]];
		if (completionBlock) completionBlock([self.stories copy]);
	}
}

@end
