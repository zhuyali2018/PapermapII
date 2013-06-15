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

@interface PM2ViewController ()

@end

@implementation PM2ViewController

@synthesize mapScrollView;
@synthesize mapSources;
@synthesize lineProperty;
@synthesize arrAllTracks;
@synthesize drawButton,fdrawButton;

-(void)add_Buttons{
    [self addDrawButton];
    [self addFreeDrawButton];
    [self addUndoButton];
}
-(void)addUndoButton{
    UIButton * drawButton1=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [drawButton1 setFrame:CGRectMake([[self view] bounds].size.width-150, 150, 100, 30)];
    [drawButton1 setTitle:@"Undo" forState:UIControlStateNormal];
    [drawButton1 addTarget:self action:@selector(undoDrawing:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:drawButton1];
}
-(void)addFreeDrawButton{
    fdrawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [fdrawButton setFrame:CGRectMake([[self view] bounds].size.width-150, 100, 100, 30)];
    [fdrawButton setTitle:@"Free Draw" forState:UIControlStateNormal];
    [fdrawButton addTarget:self action:@selector(switchToFreeDraw:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:fdrawButton];
    //[fdrawButton setEnabled:FALSE];
    [fdrawButton setHidden:TRUE];
}
-(void)addDrawButton{
    drawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [drawButton setFrame:CGRectMake([[self view] bounds].size.width-150, 50, 100, 30)];
    [drawButton setTitle:@"Draw" forState:UIControlStateNormal];
    [drawButton addTarget:self action:@selector(startDrawingRecorder:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:drawButton];
}
-(void)undoDrawing:(UIButton *)bn{
    [self.routRecorder undo];
    NSLOG5(@"Undo drawing called");
    [self.mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];
    [self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard setNeedsDisplay];
}
-(void)switchToFreeDraw:(UIButton *)bn{
    NSLOG4(@"Free Draw button tapped. Button title is %@",[bn.titleLabel text]);
    if ([[bn.titleLabel text] compare:@"Free Draw"]==NSOrderedSame) {
        [bn setTitle:@"No Free Draw" forState:UIControlStateNormal];
        self.mapScrollView.freeDraw=true;
        self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard.preDraw=FALSE;
        [self.routRecorder startNewTrack];
    }else{
        [bn setTitle:@"Free Draw" forState:UIControlStateNormal];
        self.mapScrollView.freeDraw=false;
        self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard.preDraw=TRUE;
    }
}

-(void)startDrawingRecorder:(UIButton *)bn{
    NSLOG4(@"Button title is %@",[bn.titleLabel text]);
    if ([[bn.titleLabel text] compare:@"Draw"]==NSOrderedSame) {
        [bn setTitle:@"Exit Draw" forState:UIControlStateNormal];
        
        [self.routRecorder start:[lineProperty copy]];   //user tap to enter into drawing state here        
        NSLOG4(@"Recorder started!");
        self.mapScrollView.mapPined=TRUE;                  
        [self.mapScrollView setScrollEnabled:NO];          
        self.mapScrollView.freeDraw=false;                 
        self.mapScrollView.bDrawing=true;
        self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard.preDraw=true;
        [fdrawButton setHidden:FALSE];
    }else{
        [bn setTitle:@"Draw" forState:UIControlStateNormal];
        
        [self.routRecorder stop];                                
        NSLOG4(@"Recorder Stopped!");                                                   
        self.mapScrollView.mapPined=FALSE;
        [self.mapScrollView setScrollEnabled:YES];          
        [self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard clearAll];                 
        self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard.firstPt=CGPointMake(0,0);  
        self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard.lastPt=CGPointMake(0,0);
        [self.mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];
        //reset the free draw button too
        [fdrawButton setTitle:@"Free Draw" forState:UIControlStateNormal];
        self.mapScrollView.freeDraw=false;
        self.mapScrollView.zoomView.gpsTrackPOIBoard.drawingBoard.preDraw=TRUE;
        [fdrawButton setHidden:TRUE];
    }
}
-(void)add_MapScrollView{
    float bazel=20;     //set to 0 to maxmize map area
	CGRect visibleBounds = [self.view bounds];
	float width=visibleBounds.size.width-2*bazel;
	float height=visibleBounds.size.height-2*bazel;
	//mapScrollView=[[TappableMapScrollView alloc] initWithFrame:CGRectMake(bazel,bazel,width,height)];
    mapScrollView=[[DrawableMapScrollView alloc] initWithFrame:CGRectMake(bazel,bazel,width,height)];
    //create a mapsource object
    mapSources=[[MapSources alloc]init];
    mapSources.mapType=googleMap;
    //specifying mapsource
    mapScrollView.mapsourceDelegate=mapSources;
	//display map view
    [mapScrollView restoreMapState];
    [[self view] addSubview:mapScrollView];
    
    //create a Drawing Recoder or GPS Recorder
    self.routRecorder=[[Recorder alloc]init];
    if(self.routRecorder)
        mapScrollView.recordingDelegate=_routRecorder;
    
    //initializing the lineproperty of lines for drawing 
    lineProperty=[[LineProperty alloc]initWithRed:0.2 green:0.3 blue:0.9 alpha:0.8 linewidth:3];
    
    
    //register array of tracks to be drawn
    [mapScrollView registTracksToBeDrawn:arrAllTracks];
    [arrAllTracks addObject:self.routRecorder.trackArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //initialize arrAllTracks
    arrAllTracks=[[NSMutableArray alloc]initWithCapacity:2];
    [self add_MapScrollView];    //add map tile scroll view
    [self add_Buttons];

    //TODO: Fixe the following 2 lines not working, why?
    UIApplication *app=[UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)applicationWillTerminate:(NSNotification *)notification{
	NSLOG5(@"=====>calling applicationWillTerminate:");
    [mapScrollView saveMapState];
}
@end
