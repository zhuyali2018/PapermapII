//
//  GPSReceiver.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "GPSReceiver.h"
#import "PM2OnScreenButtons.h"
#import "Recorder.h"

@implementation GPSReceiver
@synthesize locationManager;
@synthesize GPSRunning;

+ (id)sharedGPSReceiver{
    static GPSReceiver *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init {
    self = [super init];
    if (self) {
        locationManager=[[CLLocationManager alloc]init];
        locationManager.delegate=[Recorder sharedRecorder];
        locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        // This setup pauses location manager if location wasn't changed
        [self.locationManager setPausesLocationUpdatesAutomatically:YES];
        // For iOS9 we have to call this method if we want to receive location updates in background mode
        if([self.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]){
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        GPSRunning=FALSE;
    }
    return self;
}
-(void)start{
    NSLOG8(@"Starting GPS...");
    if (GPSRunning) {
        return;
    }
    [[Recorder sharedRecorder] gpsStart];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])    //without this check, following line will crash on iOS 7 or earlier
        [locationManager requestAlwaysAuthorization];      //NEW this must be called before the locationManager startUpdatingLocation for iOS 8 or later
    
    [locationManager startUpdatingLocation];
    GPSRunning=TRUE;
}
-(void)stop{
    if(!GPSRunning)return;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [locationManager stopUpdatingLocation];
    [self saveGPSTrack];
    GPSRunning=FALSE;
    [[Recorder sharedRecorder] gpsStop];
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    [bns.messageLabel setText:@""];
}
//TODO:SaveGPSTrack On Stop
-(void)saveGPSTrack{

}

@end
