//
//  VLNRLogger.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "VLNRLogger.h"
#import <TestFlight.h>

@implementation VLNRLogger

- (void)logMessage:(DDLogMessage *)logMessage
{
	NSString *logMsg = logMessage->logMsg;
	if (logMsg) {
		TFLogPreFormatted(logMsg);
	}
}

@end
