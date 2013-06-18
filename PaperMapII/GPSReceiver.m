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
        locationManager.delegate=self;
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
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [locationManager startUpdatingLocation];
    GPSRunning=TRUE;
}
-(void)stop{
    if(!GPSRunning)return;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [locationManager stopUpdatingLocation];
    [self saveGPSTrack];
    GPSRunning=TRUE;
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    [bns.messageLabel setText:@""];
}
-(void)saveGPSTrack{

}
#pragma marks delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    static int n=0;
    n++;
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    float accuracy=newLocation.horizontalAccuracy;
    NSString * msg=[[NSString alloc]initWithFormat:@"Starting GPS, Accuracy=%3.1f meters (%d)",accuracy,n];
    [bns.messageLabel setText:msg];
    if(accuracy>50){  //if acuracy is not accurate enough, do nothing
        [bns.messageLabel setTextColor:[UIColor redColor]];
    }else{
        [bns.messageLabel setTextColor:[UIColor greenColor]];
    }
}

@end
