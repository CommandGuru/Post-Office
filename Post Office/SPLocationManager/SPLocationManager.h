//
//  SPLocationManager.h
//  SallyPark
//
//  Created by Andrea Gelati on 2/8/10.
//  Copyright 2010 Doseido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define SPLocationManagerUpdateLocationCompleteNotification @"SPLocationManagerUpdateLocationCompleteNotification"
#define SPLocationManagerUpdateLocationFailNotification @"SPLocationManagerUpdateLocationFailNotification"
#define SPLocationManagerUpdateHeadingCompleteNotification @"SPLocationManagerUpdateHeadingCompleteNotification"
#define SPLocationManagerShouldDisplayHeadingCalibrationNotification @"SPLocationManagerShouldDisplayHeadingCalibrationNotification"
#define SPLocationManagerReverseGeocoderCompleteNotification @"SPLocationManagerReverseGeocoderCompleteNotification"
#define SPLocationManagerReverseGeocoderFailNotification @"SPLocationManagerReverseGeocoderFailNotification"

#define LOCATION_MANAGER_MIN_LOCATION_HORIZONTAL_ACCURACY 1000.0 // meters around the currentLocation
#define LOCATION_MANAGER_MIN_HEADING_ACCURACY 20.0 // degrees around the currentLocation

#define LOCATION_MANAGER_MIN_LOCATION_TIME_STAMP_FILTER 10.0 // value between the old location.timeStamp and now in seconds
#define LOCATION_MANAGER_MIN_HEADING_TIME_STAMP_FILTER 10.0 // value between the old heading.timeStamp and now in seconds
#define LOCATION_MANAGER_LOCATION_TIMER_TIMEOUT 5.0 // the locationManager do not receive a better location after 8 seconds
#define LOCATION_MANAGER_HEADING_TIMER_TIMEOUT 4.0 // the locationManager do not receive a better heading after 4 seconds

#ifdef __IPHONE_5_0 
@interface SPLocationManager : NSObject <CLLocationManagerDelegate> {
    CLGeocoder *geocoder;
#else
@interface SPLocationManager : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
    MKReverseGeocoder *reverseGeocoder;
#endif
	CLLocation *currentLocation;
	CLHeading *currentHeading;
	CLLocationManager *locationManager;

	NSTimer *updateHeadingTimeoutTimer;
	NSTimer *updateLocationTimeoutTimer;
}

@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic, readonly) CLHeading *currentHeading;
@property (nonatomic, readonly) CLLocationManager *locationManager;;

#pragma mark -
#pragma mark Methods

+ (SPLocationManager *)sharedLocationManager;

- (void)startUpdatingLocation;
- (void)startUpdatingHeading;
- (void)stopUpdatingLocation;
- (void)stopUpdatingHeading;

- (void)startReverseGeocoderByLocation:(CLLocation *)location; // return the address from the location point.
- (void)cancelReverseGeocoder;
    
- (BOOL)locationServicesEnabled; // return if the location service is enabled or not. 

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;
- (CLLocationDirection)directionToLocation:(CLLocation *)location;

@end
