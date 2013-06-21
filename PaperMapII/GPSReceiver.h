//
//  GPSReceiver.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CoreLocation/CoreLocation.h>

@interface GPSReceiver : NSObject

@property (nonatomic) CLLocationManager * locationManager;
@property (nonatomic) CLLocation		* currentLocation;
@property BOOL GPSRunning;

+ (id)sharedGPSReceiver;
-(void)start;
-(void)stop;
@end
