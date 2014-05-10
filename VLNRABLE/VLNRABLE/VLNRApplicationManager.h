//
//  VLNRApplicationManager.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>

//---------------------------------------------
/* VLNR imports */
//---------------------------------------------
#import "VLNRColor.h"
#import "VLNRLogger.h"

//---------------------------------------------
/* Apple device idioms */
//---------------------------------------------
#define IDIOM	UI_USER_INTERFACE_IDIOM()
#define IPAD	UIUserInterfaceIdiomPad
#define IPHONE	UIUserInterfaceIdiomPhone

//---------------------------------------------
/* System versioning macros */
//---------------------------------------------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//---------------------------------------------
/* Cocoa lumberjack logger levels */
//---------------------------------------------
// LOG_LEVEL_ERROR		Only see DDLogError statements.
// LOG_LEVEL_WARN		Only see DDLogError and DDLogWarn statements.
// LOG_LEVEL_INFO		Only see DDLogError, DDLogWarn, and DDLogInfo statements.
// LOG_LEVEL_VERBOSE	See all DDLog statements.
// LOG_LEVEL_OFF		See no DDLog statements.

//---------------------------------------------
/* Cocoa lumberjack logger macros */
//---------------------------------------------
#define VLNRLogError(fmt, ...) DDLogError((@"ERROR: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define VLNRLogWarn(fmt, ...) DDLogWarn((@"WARN: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define VLNRLogInfo(fmt, ...) DDLogInfo((@"INFO: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define VLNRLogVerbose(fmt, ...) DDLogVerbose((@"VERBOSE: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

//---------------------------------------------
/* HTTP status codes */
//---------------------------------------------
typedef NS_ENUM(NSUInteger, HTTPStatusCodes) {
    HTTPStatusCode0NoResponse = 0,
    // Successful 2xx
    HTTPStatusCode200Success = 200,
    HTTPStatusCode201Created,
    HTTPStatusCode202Accepted,
    HTTPStatusCode204NoContent = 204,
    HTTPStatusCode206PartialContent = 206,
    // Client Error 4xx
    HTTPStatusCode400BadRequest = 400,
    HTTPStatusCode401UnauthorizedAccess,
    HTTPStatusCode402PaymentRequired,
    HTTPStatusCode403Forbidden,
    HTTPStatusCode404NotFound,
    HTTPStatusCode408RequestTimeout = 408,
	HTTPStatusCode422UnprocessableEntity = 422,
    // Server Error 5xx
    HTTPStatusCode500InternalServerError = 500,
    HTTPStatusCode501NotImplemented,
    HTTPStatusCode502BadGateway,
    HTTPStatusCode503ServiceUnavailable,
    HTTPStatusCode504GatewayTimeout
};

@interface VLNRApplicationManager : NSObject

+ (VLNRApplicationManager *)sharedManager;

+ (NSString *)applicationName;
+ (NSString *)applicationVersion;
+ (NSString *)buildNumber;

@end
