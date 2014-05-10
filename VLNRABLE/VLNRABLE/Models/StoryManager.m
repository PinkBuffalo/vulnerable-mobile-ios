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

@interface StoryManager ()

@property (nonatomic, readwrite, strong) NSSet *stories;

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

//---------------------------------------------
/* Test Story */
//---------------------------------------------
//											 //
//  ID: 1									 //
//  Author: Paris							 //
//  Title: Hello							 //
//  Body: Hello World!						 //
//  Status: active							 //
//  Mood: (null)							 //
//											 //
//---------------------------------------------
//---------------------------------------------

#pragma mark - GET methods
- (void)getStoriesForUser:(User *)user
			 successBlock:(StoryManagerSuccessBlock)successBlock
			 failureBlock:(StoryManagerFailureBlock)failureBlock
{
	self.storiesAreLoading = YES;
	NSString *storiesURL;
	if (user) {
		storiesURL = [NSString stringWithFormat:@"http://localhost:3000/api/v1/users/%@/stories.json", user.user_id];
	} else {
		storiesURL = @"http://localhost:3000/api/v1/stories.json";
	}

	__typeof__(self) __weak weakSelf = self;
	AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
	operation.requestSerializer = [AFHTTPRequestSerializer serializer];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation GET:storiesURL
		parameters:nil
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
			   weakSelf.storiesAreLoading = NO;
			   [weakSelf saveStoriesForUser:user
						 withResponseObject:responseObject];
			   VLNRLogInfo(@"\nSUCCESS: %@\n", responseObject);
			   successBlock([weakSelf.stories copy]);
		   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			   weakSelf.storiesAreLoading = NO;
			   VLNRLogError(@"\nFAILED: %@, %@\n", operation.responseObject, error);
			   failureBlock(error);
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
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kStoryEntityName];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	[fetchRequest setFetchBatchSize:kStoryManagerFetchBatchSize];

	NSArray *stories = [[NSSet setWithArray:[responseObject valueForKey:@"stories"]] allObjects];
	for (NSDictionary *storyInfo in stories) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"story_id == %@", [storyInfo valueForKey:@"id"]];
		[fetchRequest setPredicate:predicate];

		NSError *error;
		Story *story = [[[CoreDataManager mainQueueContext] executeFetchRequest:fetchRequest error:&error] lastObject];
		if (!story) {
			story = (Story *)[NSEntityDescription insertNewObjectForEntityForName:kStoryEntityName
														   inManagedObjectContext:[CoreDataManager privateQueueContext]];
		}

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

		// TODO: Figure out how to add these attributes to the rails schema.
		story.story_id = [storyInfo valueForKey:@"id"];
		story.author = @"";
		story.title = @"";
		story.body = [storyInfo valueForKey:@"body"];
		story.mood = nil;
		story.status = @"active";
		story.created_at = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
		story.updated_at = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
	}
	[self fetchStoriesForUser:user completionBlock:nil];
	[[CoreDataManager sharedManager] savePrivateQueueContext];
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
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kStoryEntityName];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	[fetchRequest setFetchBatchSize:kStoryManagerFetchBatchSize];

	NSError *error;
	if (user) {
		user.stories = [NSSet setWithArray:[[CoreDataManager mainQueueContext] executeFetchRequest:fetchRequest error:&error]];
		if (completionBlock) completionBlock([user.stories copy]);
	} else {
		self.stories = [NSSet setWithArray:[[CoreDataManager mainQueueContext] executeFetchRequest:fetchRequest error:&error]];
		if (completionBlock) completionBlock([self.stories copy]);
	}
}

@end
