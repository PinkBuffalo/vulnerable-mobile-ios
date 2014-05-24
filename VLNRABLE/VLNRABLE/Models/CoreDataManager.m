//
//  CoreDataManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/9/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "CoreDataManager.h"
#import "NSFileManager+VLNRAdditions.h"

@interface CoreDataManager ()

@property (nonatomic, readwrite, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readwrite, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readwrite, strong) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, readwrite, strong) NSManagedObjectContext *privateQueueContext;
@property (nonatomic, readwrite, strong) NSURL *persistentStoreURL;
@property (nonatomic, readwrite, strong) NSDictionary *persistentStoreOptions;
@property (nonatomic, readwrite, strong) NSString *persistentStoreType;

@end

@implementation CoreDataManager

#pragma mark - Singleton access methods
+ (instancetype)sharedManager
{
	static CoreDataManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[CoreDataManager alloc] init];
	});
	return sharedManager;
}

+ (NSManagedObjectContext *)mainQueueContext
{
	return [[self sharedManager] mainQueueContext];
}

+ (NSManagedObjectContext *)privateQueueContext
{
	return [[self sharedManager] privateQueueContext];
}

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)string
{
	return [[[self sharedManager] persistentStoreCoordinator]
			managedObjectIDForURIRepresentation:[NSURL URLWithString:string]];
}

#pragma mark - Initialization methods
- (instancetype)init
{
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(contextDidSavePrivateQueueContext:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:[self privateQueueContext]];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(contextDidSaveMainQueueContext:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:[self mainQueueContext]];
	}
	return self;
}

#pragma mark - Lazy loading methods
- (NSManagedObjectContext *)mainQueueContext
{
	if (!_mainQueueContext) {
		_mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	return _mainQueueContext;
}

- (NSManagedObjectContext *)privateQueueContext
{
	if (!_privateQueueContext) {
		_privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		_privateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	return _privateQueueContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (!_persistentStoreCoordinator) {
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
		NSError *error;
		if (![_persistentStoreCoordinator addPersistentStoreWithType:self.persistentStoreType
													   configuration:nil
																 URL:self.persistentStoreURL
															 options:self.persistentStoreOptions
															   error:&error]) {
			VLNRLogError(@"Error adding persistent store. %@, %@", error, [error userInfo]);
		}
	}
	return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (!_managedObjectModel) {
		_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
	}
	return _managedObjectModel;
}

- (NSURL *)persistentStoreURL
{
	if (!_persistentStoreURL) {;
		_persistentStoreURL = [[NSFileManager URLToApplicationSupportDirectory] URLByAppendingPathComponent:@"VLNRABLE-v1.sqlite"];
		VLNRLogInfo(@"Persistent Store URL: %@", _persistentStoreURL);
	}
	return _persistentStoreURL;
}

- (NSDictionary *)persistentStoreOptions
{
	if (!_persistentStoreOptions) {
		_persistentStoreOptions = @{ NSInferMappingModelAutomaticallyOption: @YES,
									 NSMigratePersistentStoresAutomaticallyOption: @YES,
									 NSSQLitePragmasOption: @{ @"synchronous": @"OFF" } };
	}
	return _persistentStoreOptions;
}

- (NSString *)persistentStoreType
{
	return NSSQLiteStoreType;
}

#pragma mark - Migration methods
- (BOOL)migrationIsNeeded
{
	NSError *error;
	NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self persistentStoreType]
																							  URL:[self persistentStoreURL]
																							error:&error];

	NSManagedObjectModel *destinationModel = self.persistentStoreCoordinator.managedObjectModel;
	BOOL isModelCompatible = [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
	return !isModelCompatible;
}

#pragma mark - Saving methods
- (void)saveMainQueueContext
{
	__typeof__(self) __weak weakSelf = self;
	[self.mainQueueContext performBlock:^{
		NSError *error;
		if (![weakSelf.mainQueueContext save:&error]) {
			VLNRLogError(@"Error saving main queue context. %@, %@", error, [error userInfo]);
		}
	}];
}

- (void)savePrivateQueueContext
{
	__typeof__(self) __weak weakSelf = self;
	[self.privateQueueContext performBlock:^{
		NSError *error;
		[weakSelf migrationIsNeeded];
		if (![weakSelf.privateQueueContext save:&error]) {
			VLNRLogError(@"Error saving private queue context. %@, %@", error, [error userInfo]);
		}
	}];
}

#pragma mark - Notifications methods
- (void)contextDidSaveMainQueueContext:(NSNotification *)notification
{
	@synchronized(self) {
		[self.mainQueueContext performBlock:^{
			[self.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
			VLNRLogInfo(@"Save!");
		}];
	}
}

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification
{
	@synchronized(self) {
		[self.privateQueueContext performBlock:^{
			[self.privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
			VLNRLogInfo(@"Save!");
		}];
	}
}

@end
