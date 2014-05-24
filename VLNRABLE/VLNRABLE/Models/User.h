//
//  User.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/23/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+VLNRAdditions.h"

@class Story;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSNumber * objectId;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sessionToken;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *favorites;
@property (nonatomic, retain) NSSet *stories;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFavoritesObject:(Story *)value;
- (void)removeFavoritesObject:(Story *)value;
- (void)addFavorites:(NSSet *)values;
- (void)removeFavorites:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
