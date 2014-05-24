//
//  StoryManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "StoryManager.h"
#import "Story.h"
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

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setValue:kVLNRParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
	[manager.requestSerializer setValue:kVLNRParseRESTAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	[manager GET:@"https://api.parse.com/1/classes/Story" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		weakSelf.loading = NO;
		VLNRLogInfo(@"Response: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		weakSelf.loading = NO;
		VLNRLogError(@"Error: %@", error.localizedDescription);
	}];
}

#pragma mark - SAVE methods
- (void)saveStoriesForUser:(User *)user
		withResponseObject:(NSDictionary *)responseObject
{
	if (!responseObject.allKeys.count || !responseObject.allValues.count) {
		return;
	}

	responseObject = [responseObject dictionaryByReplacingNullsWithEmptyStrings];

	// Begin fetch & save requests.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Story entityName]
																	batchSize:[Story fetchBatchSize]
																	   faults:NO];

	NSArray *stories = [[NSSet setWithArray:[responseObject valueForKey:@"stories"]] allObjects];
	for (NSDictionary *storyInfo in stories) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"story_id == %@", [storyInfo valueForKey:@"id"]];
		[fetchRequest setPredicate:predicate];

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

		NSError *error;
		Story *story = [[[CoreDataManager privateQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
		if (!story) {
			story = [Story insertNewObjectIntoContext:[CoreDataManager privateQueueContext]];

			story.story_id = [storyInfo valueForKey:@"id"];
			story.title = [storyInfo valueForKey:@"title"];
			story.body = [storyInfo valueForKey:@"body"];
			story.mood = nil;
			story.status = @"active";
			story.created_at = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
			story.updated_at = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];

			[user addStoriesObject:story];
		}

		[self saveUserForStory:story withStoryInfo:storyInfo];

	}
	[self fetchStoriesForUser:user completionBlock:nil];
	[[CoreDataManager sharedManager] savePrivateQueueContext];
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

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@", @([[storyInfo valueForKeyPath:@"user_id"] integerValue])];
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
- (void)fetchStoriesForUser:(User *)user
			completionBlock:(StoryManagerCompletionBlock)completionBlock
{
	// Begin fetch request.
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
