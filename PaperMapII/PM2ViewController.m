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
#import "MapCenterIndicator.h"

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
    mapSources=[MapSources sharedManager]; //[[MapSources alloc]init];
    [[MainQ sharedManager] register:mapSources withID:MAPSOURCE];
    [mapSources setMapSourceType:googleMap];
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
    
    //[self didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeRight];  //this line does not work here, too early. do it in viewDidAppear !
    //TODO: Fix the following 2 lines not working, why?
    //UIApplication *app=[UIApplication sharedApplication];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
}
-(void)viewDidAppear:(BOOL)animated{
    [self didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	int screenW=[[self view] bounds].size.width;
	int screenH=[[self view] bounds].size.height;
    [self.mapScrollView setFrame:CGRectMake(0, 0, screenW,screenH)];
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    [bns repositionButtonsFromX:screenW-110+200 Y:150];
    [bns positionStartBnWidth:screenW Height:screenH];
    NSLOG9(@"did Rotate !!!");
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).speedLabel  setFrame:CGRectMake(0,  screenH-180, 400, 140)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).heightLabel setFrame:CGRectMake(402,screenH-80,  300,  40)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).tripLabel setFrame:CGRectMake(402,screenH-122,  300,  40)];
    [MapCenterIndicator sharedMapCenter:CGRectMake(screenW/2-10-1, (screenH-20)/2-10+9, 20, 20)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).messageLabel setFrame:CGRectMake(0, screenH-40, screenW, 40)];
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
