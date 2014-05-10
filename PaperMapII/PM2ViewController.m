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
#import "OnScreenMeter.h"
#import "Settings.h"

@interface PM2ViewController ()

@end

@implementation PM2ViewController

@synthesize mapScrollView;
@synthesize mapSources;
@synthesize orientationChanging;
//@synthesize arrAllTracks,arrAllGpsTracks;

-(void)addOnScreeButtons{
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    //[bns addButtons:(UIView *)[self view]];
    [bns addToolBar:[self view]];
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
    [[Recorder sharedRecorder] initializeAllPOIs];
}

//version 5.0 ///////////////////
NSString * satVersion;
-(void)URLLoadingInThread{
    NSString * iphoneName=[[UIDevice currentDevice] name];
    NSString * iPhoneName=[iphoneName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString * iphoneID=[[UIDevice currentDevice] systemVersion];//uniqueIdentifier];
    NSString * iphonemodel=[[UIDevice currentDevice] model];
    NSString * iphoneModel=[iphonemodel stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString * URLWithIphoneName=[[NSString alloc] initWithFormat:@"http://www.yalisoft.org:900/PaperMapSatVersion/verPaperMapiPad.asp?iphonename=%@&iphonemodel=%@&iphoneid=%@",iPhoneName,iphoneModel,iphoneID];
    NSData * versionData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URLWithIphoneName]];
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    
    dataLength = [versionData length];
    dataBytes  = [versionData bytes];
    
    NSString * msg=[[NSString alloc]initWithBytes:dataBytes length:dataLength encoding:NSASCIIStringEncoding];
    if (msg.length>8) {
        if([msg rangeOfString:@"version="].location==0){
            msg=[msg substringFromIndex:8];
            
            satVersion = msg;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:satVersion forKey:@"SatMapVersion"];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //version 5.0 ///////////////////
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	satVersion=[defaults stringForKey:@"SatMapVersion"];   //version 5.0
	if ((satVersion==nil)||([satVersion compare:@""]==NSOrderedSame)) {
		satVersion=@"138";
        [defaults setBool:TRUE forKey:@"AutoSat"];
	}
    bool autosat=[defaults boolForKey:@"AutoSat"];
    if(autosat){
        //get current version from yali server
        [self performSelectorInBackground:@selector(URLLoadingInThread) withObject:nil];   //this line returns right away
	}
    ///////////////////////////////

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
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if ([Recorder sharedRecorder].gpsRecording) {
        orientationChanging=TRUE;
        [DrawableMapScrollView sharedMap].transform=CGAffineTransformIdentity;  //set to no rotation before device orientation changes, key to correctly calculate the frame of mapview
    }
}
extern float zmc;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    orientationChanging=FALSE;
	int screenW=[[self view] bounds].size.width;
	int screenH=[[self view] bounds].size.height;
    //[self.mapScrollView setFrame:CGRectMake(0, 0, screenW,screenH)];
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    [bns repositionButtonsFromX:screenW-110 Y:screenH];
    [bns positionStartBnWidth:screenW Height:screenH];
    NSLOG9(@"did Rotate !!!");
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).lockupScreen setFrame:CGRectMake(0,0,screenW,screenH)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).compassBn setFrame:CGRectMake(screenW-60, 50, 60, 60)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).speedLabel  setFrame:CGRectMake(0,  screenH-180, 400, 140)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).heightLabel setFrame:CGRectMake(402,screenH-80,  200,  40)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).tripLabel setFrame:CGRectMake(402,screenH-122,  200,  40)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).timerLabel setFrame:CGRectMake(402,screenH-164,  200,  40)];
    [MapCenterIndicator sharedMapCenter:CGRectMake(screenW/2-10-1, (screenH-20)/2-10+9, 20, 20)];
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).messageLabel setFrame:CGRectMake(0, screenH-40, screenW, 40)];
    //reposition tool bar
    CGFloat toolbarHeight = 40;
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).toolbar setFrame:CGRectMake(0,screenH-toolbarHeight,screenW,toolbarHeight)];
    
    //mapview setup
    //CGRect windowfr = [[UIScreen mainScreen] bounds];
    if([[Settings sharedSettings] getSetting:DIRECTION_UP]&&[Recorder sharedRecorder].gpsRecording){
        int W=screenW;
        int H=screenH;
        [[DrawableMapScrollView sharedMap] setFrame:CGRectMake((W-1280)/2,(H-1280)/2,1280,1280)];
        zmc=1.3;
    }else {
        int W=screenW;
        int H=screenH;
        [[DrawableMapScrollView sharedMap] setFrame:CGRectMake(0,0,W,H)];
        zmc=1.0;
    }
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 	return YES;
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
    [[Recorder sharedRecorder] saveAllPOIs];
}
@end
