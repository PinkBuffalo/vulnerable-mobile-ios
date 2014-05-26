//
//  LocationManagerDelegate.h
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/25/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

@optional
- (void)locationManagerDidUpdateLocation:(CLLocation *)location;

@end
