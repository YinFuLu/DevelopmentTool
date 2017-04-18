//
//  LocationManager.h
//  WeatherForecast
//
//  Created by abcinc on 2017/4/10.
//  Copyright © 2017年 abcinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Single.h"

@protocol LocationManagerDelegate <NSObject>

- (void)LocationManager:(id)manager placemark:(CLPlacemark *)placemark;

@end

@interface LocationManager : NSObject

SingleInterface(LocationManager)

@property (nonatomic, assign) id<LocationManagerDelegate> delegate;

- (void)startUpdatingLocation;

@end
