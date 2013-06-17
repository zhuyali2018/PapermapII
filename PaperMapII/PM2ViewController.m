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
@synthesize arrAllTracks;

-(void)addOnScreeButtons{
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    [bns addButtons:(UIView *)[self view]];
}
-(void)addRecorder{
    _routRecorder=[Recorder sharedRecorder];
}
-(void)add_MapScrollView{
    float bazel=20;     //set to 0 to maxmize map area
	CGRect visibleBounds = [self.view bounds];
	float width=visibleBounds.size.width-2*bazel;
	float height=visibleBounds.size.height-2*bazel;

    mapScrollView=[DrawableMapScrollView sharedMap];
    [mapScrollView setFrame:CGRectMake(bazel,bazel,width,height)];
    //create a mapsource object
    mapSources=[[MapSources alloc]init];
    mapSources.mapType=googleMap;
    //specifying mapsource
    mapScrollView.mapsourceDelegate=mapSources;
	//display map view
    [mapScrollView restoreMapState];
    [[self view] addSubview:mapScrollView];
    
    //create a Drawing Recoder or GPS Recorder
    _routRecorder=[Recorder sharedRecorder];
    if(self.routRecorder)
        mapScrollView.recordingDelegate=_routRecorder;
    
    //register array of tracks to be drawn
    [mapScrollView registTracksToBeDrawn:arrAllTracks];
    [arrAllTracks addObject:self.routRecorder.trackArray];
}

-(NSString *)dataFilePath{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"DrawList.plist"];
}
-(void) saveArrayAllTracks{
    NSMutableData * data=[[NSMutableData alloc] init];
	NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:arrAllTracks forKey:@"arrAllTracks"];
	[archiver finishEncoding];
	
	[data writeToFile:[self dataFilePath] atomically:YES];
}
-(void)initializeArrAllTracks{
    //initialize arrAllTracks
    NSString * filePath=[self dataFilePath];
	//NSLog(@"data file path=%@",filePath);
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
		NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		
		arrAllTracks=[unarchiver decodeObjectForKey:@"arrAllTracks"];
		[unarchiver finishDecoding];
	}
    
    if(!arrAllTracks)
        arrAllTracks=[[NSMutableArray alloc]initWithCapacity:2];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //initialize arrAllTracks
    [self initializeArrAllTracks];
    [self addRecorder];
    [self add_MapScrollView];    //add map tile scroll view
    [self addOnScreeButtons];
    //TODO: remove following lines for release
    //set drawing line property
    LineProperty * lp=[LineProperty sharedDrawingLineProperty];
    lp.red=0;lp.green=0;lp.blue=1.0;lp.alpha=0.8;lp.lineWidth=3;
    
    //TODO: Fixe the following 2 lines not working, why?
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
    [self saveArrayAllTracks];
}
@end
