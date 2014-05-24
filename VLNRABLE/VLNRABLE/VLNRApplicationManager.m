//
//  VLNRApplicationManager.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

NSString * const kVLNRParseApplicationID = @"D3KkkC7xsH324JB48CenGDmfSBJZHH0Ky5tii4qj";
NSString * const kVLNRParseClientKey = @"kRH3AkVdlHSEqPLzQoqhkPAjtsEEyVD5vSpiBFCt";
NSString * const kVLNRParseJavascriptKey = @"tco96RdoDs6JqFTpfDIEc5TgZ893kZU5qzjKQnXU";
NSString * const kVLNRParseNETKey = @"KlmDYCwg7zUHnbjUSOTfnwsjZPVo9Xr02HXawxq6";
NSString * const kVLNRParseRESTAPIKey = @"ZE5an4AbvEdeXRQfFfgm6PncswFV9LUB6sLiLpsf";
NSString * const kVLNRParseMasterKey = @"xs4PUSQba3mV0CVFiXvovmqKzysvqhNSF161QIOd";

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