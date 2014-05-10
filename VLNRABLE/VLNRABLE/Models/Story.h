//
//  Story.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/9/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * mood;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) User *user;

@end
