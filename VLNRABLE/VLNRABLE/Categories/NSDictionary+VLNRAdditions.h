//
//  NSDictionary+VLNRAdditions.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/10/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VLNRAdditions)

- (NSDictionary *)dictionaryByReplacingNullsWithEmptyStrings;
- (id)objectForKeyNotNull:(id)key;
- (id)valueForKeyNotNull:(id)key;
- (id)valueForKeyPathNotNull:(id)keyPath;

@end
