//
//  NSFileManager+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "NSFileManager+VLNRAdditions.h"

@implementation NSFileManager (VLNRAdditions)

+ (NSURL *)URLToApplicationDocumentDirectory
{
	return [[[self defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)URLToApplicationLibraryDirectory
{
	return [[[self defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)URLToApplicationSupportDirectory
{
	NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
	BOOL isDirectory = NO;
	NSError *error;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:applicationSupportDirectory
						   isDirectory:&isDirectory] && !isDirectory) {
		[fileManager createDirectoryAtPath:applicationSupportDirectory
			   withIntermediateDirectories:NO
								attributes:nil
									 error:&error];
	}
	return [NSURL fileURLWithPath:applicationSupportDirectory];
}

@end
