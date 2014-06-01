//
//  VLNRAppManager.m
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
NSString * const kVLNRTestFlightAppTokenKey = @"f0c47698-54ee-498c-a9cf-acb8dbf785a4";

// Date Formatter
NSString * const VLNRDateFormatterStringToDateKey = @"VLNRDateFormatterStringToDateKey";
NSString * const VLNRDateFormatterDateToStringKey = @"VLNRDateFormatterDateToStringKey";

#import "VLNRAppManager.h"

@implementation VLNRAppManager

#pragma mark - Singleton access methods
+ (VLNRAppManager *)sharedManager
{
	static VLNRAppManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[VLNRAppManager alloc] init];
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

+ (NSDateFormatter *)dateToStringFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
{
	// Create a thread-safe date formatter.
	NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
	NSDateFormatter *dateFormatter = [threadDictionary objectForKey:VLNRDateFormatterDateToStringKey];
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:dateStyle];
		[threadDictionary setObject:dateFormatter forKey:VLNRDateFormatterDateToStringKey];
	}
	[dateFormatter setDateStyle:dateStyle];
	return dateFormatter;
}

+ (NSDateFormatter *)stringToDateFormatter
{
	// Create a thread-safe date formatter.
	NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
	NSDateFormatter *dateFormatter = [threadDictionary objectForKey:VLNRDateFormatterStringToDateKey];
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
		[threadDictionary setObject:dateFormatter forKey:VLNRDateFormatterStringToDateKey];
	}
	return dateFormatter;
}

+ (UIFont *)boldSmallSystemFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:[UIFont smallSystemFontSize]];
}

+ (UIFont *)boldSystemFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:[UIFont systemFontSize]];
}

+ (UIFont *)boldLargeSystemFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
}

+ (UIFont *)smallSystemFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Light" size:[UIFont smallSystemFontSize]];
}

+ (UIFont *)systemFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Light" size:[UIFont systemFontSize]];
}

+ (UIFont *)largeSystemFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
}

@end