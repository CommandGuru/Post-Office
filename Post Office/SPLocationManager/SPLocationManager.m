//
//  SPLocationManager.m
//  SallyPark
//
//  Created by Andrea Gelati on 2/8/10.
//  Copyright 2010 Doseido. All rights reserved.
//

#import "SPLocationManager.h"

@implementation SPLocationManager

@synthesize currentLocation, currentHeading, locationManager;

- (id) init {
	self = [super init];
	if (self != nil) {
		locationManager = [[CLLocationManager alloc] init];
	
		[locationManager setDelegate:self];
		[locationManager setDistanceFilter:kCLDistanceFilterNone]; // be notified of all movements
		[locationManager setDesiredAccuracy:kCLLocationAccuracyBest]; // best accuracy
		[locationManager setHeadingFilter:kCLHeadingFilterNone]; // be notified of all rotations

	}
	return self;
}

- (void) dealloc {
	if(currentLocation) {
		[currentLocation release];
	}

	[locationManager release];
#ifdef __IPHONE_5_0 
#else
	if(reverseGeocoder) {
		[reverseGeocoder release];
	}
#endif
	[super dealloc];
}


#pragma mark -
#pragma mark Methods

+ (SPLocationManager *)sharedLocationManager {
	static SPLocationManager *locationManager = nil;
	if(!locationManager) {
		locationManager = [[SPLocationManager alloc] init];
	}
	return locationManager;
}

- (void)startUpdatingLocation {
	[locationManager startUpdatingLocation];
}

- (void)startUpdatingHeading {
	[locationManager startUpdatingHeading];
}

- (void)stopUpdatingLocation {
	[locationManager stopUpdatingLocation];
}

- (void)stopUpdatingHeading {
	[locationManager stopUpdatingHeading];
}

- (void)startReverseGeocoderByLocation:(CLLocation *)location {
#ifdef __IPHONE_5_0 
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"%@",[error userInfo]);
        for (CLPlacemark * placemark in placemarks) {
           	NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@", [placemark administrativeArea], 
                  [placemark country],
                  [placemark ISOcountryCode], 
                  [placemark locality], 
                  [placemark postalCode], 
                  [placemark subAdministrativeArea], 
                  [placemark subLocality], 
                  [placemark subThoroughfare], 
                  [placemark thoroughfare]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerReverseGeocoderCompleteNotification
                                                                object:placemark];
        }    
    }];    
#else
    
    if(reverseGeocoder) {
		[reverseGeocoder release];
		reverseGeocoder = nil;
	}
	
	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:[location coordinate]];
	
	[reverseGeocoder setDelegate:self];
	[reverseGeocoder start];
#endif  
}

- (void)cancelReverseGeocoder {
#ifdef __IPHONE_5_0 
    
#else
	if(reverseGeocoder && [reverseGeocoder isQuerying]) {
		[reverseGeocoder cancel];
	}
#endif
}

- (BOOL)locationServicesEnabled {
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_3_2
	return [locationManager locationServicesEnabled];
#else
	return [CLLocationManager locationServicesEnabled];
#endif
}

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location {
	if(currentLocation && location) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_3_2
		return [currentLocation getDistanceFrom:location];
#else
		return [currentLocation distanceFromLocation:location];
#endif
	} else {
		return 0;
	}
}

-(float)angleToRadians:(float)angle {
    return ((angle/180)*M_PI);
}


- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
	
//	Following
//	Formula:	θ =	atan2(	sin(Δlong).cos(lat2),
//					cos(lat1)*sin(lat2) − sin(lat1)*cos(lat2)*cos(Δlong) )
	
    float fromLat = [self angleToRadians:fromLoc.latitude];
    float fromLng = [self angleToRadians:fromLoc.longitude];
    float toLat = [self angleToRadians:toLoc.latitude];
    float toLng = [self angleToRadians:toLoc.longitude];
	
	if (toLng - fromLng == 0.0) {
		toLng += 0.0001;
	}
	
	float varX = sin(toLng-fromLng)*cos(fromLat);
	float varY = cos(fromLat)*sin(toLat)-sin(fromLat)*cos(toLat)*cos(toLng-fromLng);
	
    return atan2(varX,varY);         
}


- (CLLocationDirection)directionToLocation:(CLLocation *)location {

	float angleDirection = 0;
	angleDirection = [self getHeadingForDirectionFromCoordinate:currentLocation.coordinate toCoordinate:location.coordinate];
	

	return angleDirection;
	
}

#pragma mark -
#pragma mark CLLocationManager Delegate

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerShouldDisplayHeadingCalibrationNotification
														object:nil];
	
	return NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	if(!updateHeadingTimeoutTimer) {
		updateHeadingTimeoutTimer = [[NSTimer scheduledTimerWithTimeInterval:LOCATION_MANAGER_HEADING_TIMER_TIMEOUT
																	  target:self 
																	selector:@selector(updateHeadingTimeoutTimerElapsed:)
																	userInfo:nil 
																	 repeats:NO] retain];
	}

	if (signbit([newHeading headingAccuracy])) {
		return;
	}

//	if (-[[newHeading timestamp] timeIntervalSinceNow] > LOCATION_MANAGER_MIN_HEADING_TIME_STAMP_FILTER) {
//		return;
//	}
		
//	if (currentHeading && ([newHeading headingAccuracy] > [currentHeading headingAccuracy])) {
//		return;
//	}
		
	if(currentHeading) {
		[currentHeading release];
		currentHeading = nil;
	}
	currentHeading = [newHeading retain];
	
//	if([newHeading headingAccuracy] <= LOCATION_MANAGER_MIN_HEADING_ACCURACY) {
		if(updateHeadingTimeoutTimer && [updateHeadingTimeoutTimer isValid]) {
			[updateHeadingTimeoutTimer invalidate];
			[updateHeadingTimeoutTimer release];
			updateHeadingTimeoutTimer = nil;
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerUpdateHeadingCompleteNotification
															object:currentHeading];
//	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

	if(!updateLocationTimeoutTimer) {
		updateLocationTimeoutTimer = [[NSTimer scheduledTimerWithTimeInterval:LOCATION_MANAGER_LOCATION_TIMER_TIMEOUT
																	   target:self 
																	 selector:@selector(updateLocationTimeoutTimerElapsed:)
																	 userInfo:nil 
																	  repeats:NO] retain];
	}
	
	if (signbit([newLocation horizontalAccuracy])) {
		return;
	}

	if (-[[newLocation timestamp] timeIntervalSinceNow] > LOCATION_MANAGER_MIN_LOCATION_TIME_STAMP_FILTER) { // secs
		return;
	}
		
//	if (currentLocation && ([newLocation horizontalAccuracy] > [currentLocation horizontalAccuracy])) {
//		return;
//	}	

    if(currentLocation) {
        [currentLocation release];
        currentLocation = nil;
    }
    currentLocation = [newLocation retain];
   
    
	if([newLocation horizontalAccuracy] <= LOCATION_MANAGER_MIN_LOCATION_HORIZONTAL_ACCURACY) {
        NSLog(@"Current Update %@",[currentLocation description]);
		if(updateLocationTimeoutTimer && [updateLocationTimeoutTimer isValid]) {
			[updateLocationTimeoutTimer invalidate];
			[updateLocationTimeoutTimer release];
			updateLocationTimeoutTimer = nil;
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerUpdateLocationCompleteNotification
															object:currentLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerUpdateLocationFailNotification
														object:error];
}

#pragma mark -
#pragma mark NSTimer Actions

- (void)updateHeadingTimeoutTimerElapsed:(NSTimer *)timer {
	if(updateHeadingTimeoutTimer && [updateHeadingTimeoutTimer isValid]) {
		[updateHeadingTimeoutTimer invalidate];
		[updateHeadingTimeoutTimer release];
		updateHeadingTimeoutTimer = nil;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerUpdateHeadingCompleteNotification
														object:currentHeading];
}

- (void)updateLocationTimeoutTimerElapsed:(NSTimer *)timer {
	if(updateLocationTimeoutTimer && [updateLocationTimeoutTimer isValid]) {
		[updateLocationTimeoutTimer invalidate];
		[updateLocationTimeoutTimer release];
		updateLocationTimeoutTimer = nil;
	}
    NSLog(@"Current Timer %@",[currentLocation description]);
	[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerUpdateLocationCompleteNotification
														object:currentLocation];
}

#pragma mark -
#pragma mark MKReverseGeocoder Delegate

#ifdef __IPHONE_5_0 

#else

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@", [placemark administrativeArea], 
											[placemark country],
											[placemark countryCode], 
											[placemark locality], 
											[placemark postalCode], 
											[placemark subAdministrativeArea], 
											[placemark subLocality], 
											[placemark subThoroughfare], 
											[placemark thoroughfare]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerReverseGeocoderCompleteNotification
														object:placemark];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	[[NSNotificationCenter defaultCenter] postNotificationName:SPLocationManagerReverseGeocoderFailNotification
														object:error];
}
#endif
@end
