//
//  VLNRApplicationManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "VLNRApplicationManager.h"

@implementation VLNRApplicationManager

#pragma mark - Singleton access methods
+ (VLNRApplicationManager *)sharedManager
{
	static VLNRApplicationManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[VLNRApplicationManager alloc] init];
	});
	return sharedManager;
}

+ (NSString *)applicationName
{
	return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
}

+ (NSString *)applicationVersion
{
	return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildNumber
{
	return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
}

@end
