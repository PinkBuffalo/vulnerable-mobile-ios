//
//  User.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/9/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Story;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) NSSet *favorites;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

- (void)addFavoritesObject:(Story *)value;
- (void)removeFavoritesObject:(Story *)value;
- (void)addFavorites:(NSSet *)values;
- (void)removeFavorites:(NSSet *)values;

@end
