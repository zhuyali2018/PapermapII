//
//  PM2ViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"

#import "PM2ViewController.h"

//#import "MapScrollView.h"
//#import "TappableMapScrollView.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"
#import "DrawableMapScrollView.h"
#import "MapSources.h"
#import "Recorder.h"
#import "LineProperty.h"

#import "PM2OnScreenButtons.h"

@interface PM2ViewController ()

@end

@implementation PM2ViewController

@synthesize mapScrollView;
@synthesize mapSources;
//@synthesize arrAllTracks,arrAllGpsTracks;

-(void)addOnScreeButtons{
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    [bns addButtons:(UIView *)[self view]];
}
-(void)add_MapScrollView{
    float bazel=20;     //set to 0 to maxmize map area
	CGRect visibleBounds = [self.view bounds];
	float width=visibleBounds.size.width-2*bazel;
	float height=visibleBounds.size.height-2*bazel;

    mapScrollView=[DrawableMapScrollView sharedMap];
    [mapScrollView setFrame:CGRectMake(bazel,bazel,height,width)];  //TODO: change height and width back
    //create a mapsource object
    mapSources=[[MapSources alloc]init];
    mapSources.mapType=googleMap;
    //specifying mapsource
    mapScrollView.mapsourceDelegate=mapSources;
	//display map view
    [mapScrollView restoreMapState];
    [[self view] addSubview:mapScrollView];
    
    mapScrollView.recordingDelegate=[Recorder sharedRecorder];
    [[Recorder sharedRecorder] initializeAllTracks];
    [[Recorder sharedRecorder] initializeAllGpsTracks];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self add_MapScrollView];    //add map tile scroll view
    [self addOnScreeButtons];
    //TODO: remove following lines for release
    //set drawing line property
    //LineProperty * lp=[LineProperty sharedDrawingLineProperty];
    //lp.red=0;lp.green=0.8;lp.blue=0.2;lp.alpha=0.8;lp.lineWidth=3;
    //LineProperty * gp=[LineProperty sharedGPSTrackProperty];   //gpsTrackProperty
    //gp.red=0;gp.green=0;gp.blue=1.0;gp.alpha=0.8;gp.lineWidth=3;
    
    //TODO: Fix the following 2 lines not working, why?
    //UIApplication *app=[UIApplication sharedApplication];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)applicationWillTerminate:(NSNotification *)notification{
	NSLOG5(@"=====>calling applicationWillTerminate:");
    [mapScrollView saveMapState];
    [[Recorder sharedRecorder] saveAllTracks];
    [[Recorder sharedRecorder] saveAllGpsTracks];
}
@end
