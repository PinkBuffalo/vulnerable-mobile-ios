//
//  AppDelegate.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 3/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "CoreDataManager.h"
#import "DDTTYLogger.h"
#import "NSFileManager+VLNRAdditions.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[DDLog addLogger:[DDTTYLogger sharedInstance]];

	NSString *version = [NSString stringWithFormat:@"%@ %@ (%@)",
						 [VLNRAppManager applicationName],
						 [VLNRAppManager applicationVersion],
						 [VLNRAppManager buildNumber]];

	VLNRLogInfo(@"%@", version);

	[Parse setApplicationId:kVLNRParseApplicationID
				  clientKey:kVLNRParseClientKey];

	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

	[PFFacebookUtils initializeFacebook];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
		[[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
		[[UINavigationBar appearance] setBarTintColor:[VLNRColor tealColor]];
	}
	
	[application setStatusBarStyle:UIStatusBarStyleLightContent];

	TabBarViewController *tabBarVC = [[TabBarViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabBarVC];

	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[self saveManagedObjectContextWhenApplicationWillEnterBackrgound:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[self saveManagedObjectContextWhenApplicationWillEnterBackrgound:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	if ([[CoreDataManager sharedManager] migrationIsNeeded]) {
		[[CoreDataManager mainQueueContext] persistentStoreCoordinator];
	}
	[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
	[self saveManagedObjectContextWhenApplicationWillEnterBackrgound:application];
	[[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	return [FBAppCall handleOpenURL:url
				  sourceApplication:sourceApplication
						withSession:[PFFacebookUtils session]];
}

#pragma mark - Core Data stack
- (void)saveManagedObjectContextWhenApplicationWillEnterBackrgound:(UIApplication *)application
{
	// Enable save to run even while user exits app.
	__block UIBackgroundTaskIdentifier backgroundTask;
	backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
		[application endBackgroundTask:backgroundTask];
		backgroundTask = UIBackgroundTaskInvalid;
	}];
	[[CoreDataManager sharedManager] savePrivateQueueContext];
	[[CoreDataManager sharedManager] saveMainQueueContext];
	VLNRLogInfo(@"Background Task Save!");
}

@end
