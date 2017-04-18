//
//  LocationManager.m
//  WeatherForecast
//
//  Created by abcinc on 2017/4/10.
//  Copyright © 2017年 abcinc. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation LocationManager

SingleImplementation(LocationManager)

- (void)startUpdatingLocation
{
    if(!_locationManager){
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            
        }
        
        //设置代理
        [self.locationManager setDelegate:self];
        //设置定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //设置距离筛选
        [self.locationManager setDistanceFilter:100];
        //开始定位
        [self.locationManager startUpdatingLocation];
        //设置开始识别方向
        [self.locationManager startUpdatingHeading];
        
    } else {
        
        //开始定位
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    [self reverseGeocoder:locations.lastObject];
}

- (void)reverseGeocoder:(CLLocation *)currentLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //        一个地址编码后不一定是唯一的位置
        //        CLPlacemark 地址信息类
        CLPlacemark *placeMark = [placemarks firstObject];
        //        addressDictionary 地址信息
        if ([_delegate respondsToSelector:@selector(LocationManager:placemark:)]) {
            [_delegate LocationManager:self.locationManager placemark:placeMark];
        }
        NSLog(@"Country=%@",placeMark.addressDictionary[@"Country"]);
        NSLog(@"State=%@",placeMark.addressDictionary[@"State"]);
        NSLog(@"City=%@",placeMark.addressDictionary[@"City"]);
        NSLog(@"SubLocality=%@",placeMark.addressDictionary[@"SubLocality"]);
        NSLog(@"Thoroughfare=%@",placeMark.addressDictionary[@"Thoroughfare"]);
        NSLog(@"Street=%@",placeMark.addressDictionary[@"Street"]);
        NSLog(@"Name=%@",placeMark.addressDictionary[@"Name"]);
        NSLog(@"FormattedAddressLines=%@",placeMark.addressDictionary[@"FormattedAddressLines"][0]);
    }];
}


@end
