//
//  NSFileManager+VLNRAdditions.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/24/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (VLNRAdditions)

+ (NSURL *)URLToApplicationDocumentDirectory;
+ (NSURL *)URLToApplicationLibraryDirectory;
+ (NSURL *)URLToApplicationSupportDirectory;

@end
