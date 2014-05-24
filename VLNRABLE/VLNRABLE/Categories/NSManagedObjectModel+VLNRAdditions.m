//
//  NSManagedObjectModel+VLNRAdditions.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "NSManagedObjectModel+VLNRAdditions.h"

@implementation NSManagedObjectModel (VLNRAdditions)

- (NSString *)modelName
{
	NSString *modelName;
	NSArray *modelPaths = [NSManagedObjectModel allModelPaths];
	for (NSString *modelPath in modelPaths) {
		NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
		NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
		if ([model isEqual:self]) {
			modelName = [[modelURL lastPathComponent] stringByDeletingPathExtension];
			break;
		}
	}
	return modelName;
}

- (NSString *)modelNameForDirectory:(NSString *)directory
{
	NSString *modelName;
	NSArray *modelPaths = [NSManagedObjectModel modelPathsForDirectory:directory];
	for (NSString *modelPath in modelPaths) {
		NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
		NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
		if ([model isEqual:self]) {
			modelName = [[modelURL lastPathComponent] stringByDeletingPathExtension];
		}
	}
	return modelName;
}

+ (NSArray *)allModelPaths
{
	// Locate all of the .momd and .mom files in the Resources bundle.
	NSMutableArray *modelPaths = [NSMutableArray array];
	NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd"
															inDirectory:nil];
	[modelPaths addObjectsFromArray:momdArray];

	for (NSString *momdPath in momdArray) {
		NSString *resourceSubpath = [momdPath lastPathComponent];
		NSArray *tempArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
																inDirectory:resourceSubpath];
		[modelPaths addObjectsFromArray:tempArray];
	}
	return [modelPaths copy];
}

+ (NSArray *)modelPathsForDirectory:(NSString *)directory
{
	// Locate all of the .momd and .mom files in the given bundle.
	NSMutableArray *modelPaths = [NSMutableArray array];
	NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd"
															inDirectory:directory];
	[modelPaths addObjectsFromArray:momdArray];

	for (NSString *momdPath in momdArray) {
		NSString *resourceSubpath = [momdPath lastPathComponent];
		NSArray *tempArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
																inDirectory:resourceSubpath];
		[modelPaths addObjectsFromArray:tempArray];
	}
	return [modelPaths copy];
}

@end
