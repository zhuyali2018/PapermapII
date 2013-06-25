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
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
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
    //if(!locationManager)
    //    locationManager=[[CLLocationManager alloc]init];
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
