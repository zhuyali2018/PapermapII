//
//  PM2OnScreenButtons.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "PM2AppDelegate.h"
#import "PM2ViewController.h"
#import "PM2OnScreenButtons.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"
#import "ScaleRuler.h"
#import "MapCenterIndicator.h"
#import "GPSReceiver.h"
#import "Track.h"
#import "MapTile.h"
#import "MapSources.h"

@implementation PM2OnScreenButtons
@synthesize drawButton,fdrawButton,colorButton;
@synthesize mapScrollView;
@synthesize resLabel;
@synthesize messageLabel;
@synthesize gpsReceiver;
@synthesize colorPickPopover;
@synthesize linePropertyViewCtrlr;

@synthesize cleanupButton;
@synthesize gpsButton;
@synthesize stopGpsButton;
@synthesize undoButton;
@synthesize mapTypeButton;
@synthesize unloadDrawingButton;
@synthesize unloadGPSTrackButton;
@synthesize speedLabel;
@synthesize heightLabel;
@synthesize tripLabel;

+ (id)sharedBnManager {
    static PM2OnScreenButtons *onScreenbuttons = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onScreenbuttons = [[self alloc] init];
    });
    return onScreenbuttons;
}
- (id)init {
    if (self = [super init]) {
        _routRecorder=[Recorder sharedRecorder];
        mapScrollView=[DrawableMapScrollView sharedMap];
        gpsReceiver=[GPSReceiver sharedGPSReceiver];
    }
    return self;
}
-(void)addButtons:(UIView *)vc{
    _baseView=vc;
    [self addDrawButton];
    [self addFreeDrawButton];
    [self addUndoButton];
    [self addMapLevelLabel];
    [self addScaleRuler];
    [self addMapCenterIndicator:vc];
    [self addMessageLabel];
    [self addGPSButton];
    [self addStopGPSButton];
    [self addTrackCleanupButton];
    [self addColorButton];
    [self addMapTypeButton];
    [self addUnloadDrawingButton];
    [self addUnloadGPSTrackButton];
    [self repositionButtonsFromX:800 Y:0];
    [self add_SpeedPanel];
    [self add_HeightPanel];
    [self add_TripMeter];
}
-(void)repositionButtonsFromX:(int)x Y:(int)y{
    int w=150;
    [drawButton             setFrame:CGRectMake(x, y=y+50, w, 30)];
    [fdrawButton            setFrame:CGRectMake(x, y=y+50, w, 30)];
    [undoButton             setFrame:CGRectMake(x, y=y+50, w, 30)];
    [gpsButton              setFrame:CGRectMake(x, y=y+50, w, 30)];
    [stopGpsButton          setFrame:CGRectMake(x, y=y+50, w, 30)];
    [cleanupButton          setFrame:CGRectMake(x, y=y+50, w, 30)];
    [colorButton            setFrame:CGRectMake(x, y=y+50, w, 30)];
    [mapTypeButton          setFrame:CGRectMake(x, y=y+50, w, 30)];
    [unloadDrawingButton    setFrame:CGRectMake(x, y=y+50, w, 30)];
    [unloadGPSTrackButton   setFrame:CGRectMake(x, y=y+50, w, 30)];
}
-(void)addUnloadDrawingButton{
    unloadDrawingButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [unloadDrawingButton setTitle:@"Unload Drawings" forState:UIControlStateNormal];
    [unloadDrawingButton addTarget:self action:@selector(unloadDrawings:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:unloadDrawingButton];
}
-(void)addUnloadGPSTrackButton{
    unloadGPSTrackButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [unloadGPSTrackButton setTitle:@"Unload GPS Track" forState:UIControlStateNormal];
    [unloadGPSTrackButton addTarget:self action:@selector(unloadGPSTrack:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:unloadGPSTrackButton];
}
-(void) addMapTypeButton{
    mapTypeButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [mapTypeButton setTitle:@"Map" forState:UIControlStateNormal];
    [mapTypeButton addTarget:self action:@selector(toggleMapType:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:mapTypeButton];
}
-(void) addColorButton{
    colorButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [colorButton setTitle:@"Pick Color" forState:UIControlStateNormal];
    [colorButton addTarget:self action:@selector(colorPicker) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:colorButton];
}
-(void) addTrackCleanupButton{
    cleanupButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [cleanupButton setTitle:@"Clean up" forState:UIControlStateNormal];
    [cleanupButton addTarget:self action:@selector(cleanUpTrack) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:cleanupButton];
}
-(void) addGPSButton{
    gpsButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [gpsButton setTitle:@"Start GPS" forState:UIControlStateNormal];
    [gpsButton addTarget:self action:@selector(startGPS) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:gpsButton];
}
-(void) addStopGPSButton{
    stopGpsButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [stopGpsButton setTitle:@"Stop GPS" forState:UIControlStateNormal];
    [stopGpsButton addTarget:self action:@selector(stopGPS) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:stopGpsButton];
}

-(void)cleanUpTrack{  
    [_routRecorder unloadTracks];
    [mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];
}
-(void) colorPicker{
    NSLOG8(@"ColorPicker button tapped!");
    if (colorPickPopover == nil) {
        Class cls = NSClassFromString(@"UIPopoverController");
        if (cls != nil) {
			linePropertyViewCtrlr=[[LinePropertyViewController alloc] init];
            
            [linePropertyViewCtrlr setTitle:@"Line Property setting"];
            
			UINavigationController * ctrl=[[UINavigationController alloc]initWithRootViewController:linePropertyViewCtrlr];
			UIPopoverController *aPopoverController =[[cls alloc] initWithContentViewController:ctrl];
		    self.colorPickPopover = aPopoverController;
        }
    }
    if([colorPickPopover isPopoverVisible]){
		[colorPickPopover dismissPopoverAnimated:YES];
	}else{
		[colorPickPopover setPopoverContentSize:CGSizeMake(350,400) animated:YES];
        [colorPickPopover presentPopoverFromRect:colorButton.frame inView:_baseView permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
	}
}
-(void) startGPS{    
    [gpsReceiver start];
}
-(void) stopGPS{
    [gpsReceiver stop];
}
-(void) addMessageLabel{
    messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, 720, 40)];
	//[messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setBackgroundColor:[UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:0.7]];
	[messageLabel setTextColor:[UIColor greenColor]];
	[messageLabel setShadowColor:[UIColor blackColor]];
	[messageLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
	[messageLabel setFont:[UIFont boldSystemFontOfSize:20]];
	//[messageLabel setText:[NSString stringWithFormat:@" %d", mapScrollView.maplevel]];
    [_baseView addSubview:messageLabel];
}
-(void)addMapCenterIndicator:(UIView*)vc{
    int screenH=[vc bounds].size.width;
	int screenW=[vc bounds].size.height;
    MapCenterIndicator * mc=[MapCenterIndicator sharedMapCenter:CGRectMake(screenW/2-10-1, (screenH-20)/2-10+9, 20, 20)];
    [vc addSubview:mc];
}
    
-(void)addScaleRuler{
    ScaleRuler * scaleRuler=[ScaleRuler shareScaleRuler:CGRectMake(30, 0,700,30)];
    [scaleRuler setBackgroundColor:[UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:0.7]];
    [_baseView addSubview:scaleRuler];
}
-(void)addMapLevelLabel{
    resLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[resLabel setBackgroundColor:[UIColor clearColor]];
	[resLabel setTextColor:[UIColor greenColor]];
	[resLabel setShadowColor:[UIColor blackColor]];
	[resLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
	[resLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[resLabel setText:[NSString stringWithFormat:@" %d", mapScrollView.maplevel]];
    [_baseView addSubview:resLabel];
}
-(void)updateMapLevel{
    [resLabel setText:[NSString stringWithFormat:@" %d", mapScrollView.maplevel]];
}
-(void)addUndoButton{
    undoButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoDrawing:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:undoButton];
}
-(void)addFreeDrawButton{
    fdrawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [fdrawButton setTitle:@"Free Draw" forState:UIControlStateNormal];
    [fdrawButton addTarget:self action:@selector(switchToFreeDraw:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:fdrawButton];
    //[fdrawButton setEnabled:FALSE];
    [fdrawButton setHidden:TRUE];
}
-(void)addDrawButton{
    drawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [drawButton setTitle:@"Draw" forState:UIControlStateNormal];
    [drawButton addTarget:self action:@selector(startDrawingRecorder:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:drawButton];
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
        
        [self.routRecorder start];   //user tap to enter into drawing state here
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
-(void)toggleMapType:(UIButton *)bn{
    NSLOG9(@"toggleMapType here !");
    PM2AppDelegate * dele= [[UIApplication sharedApplication] delegate];
    if ([[bn.titleLabel text] compare:@"Map"]==NSOrderedSame) {
        [bn setTitle:@"Sat" forState:UIControlStateNormal];
        dele.viewController.mapSources.mapType=googleSat;
    }else{
        [bn setTitle:@"Map" forState:UIControlStateNormal];
        dele.viewController.mapSources.mapType=googleMap;
    }
    [[DrawableMapScrollView sharedMap] reloadData];
    [[DrawableMapScrollView sharedMap] setNeedsDisplay];
}
-(void)unloadGPSTrack:(UIButton *)bn{
    [_routRecorder unloadGPSTracks];
    [mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];
}
-(void)unloadDrawings:(UIButton *)bn{
    [_routRecorder unloadDrawings];
    [mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];
}
-(void)add_SpeedPanel{
    //Speed panel
    //int screenW=[[UIScreen mainScreen] applicationFrame].size.width;
	//int screenH=[[UIScreen mainScreen] applicationFrame].size.height;
    int screenH=[_baseView frame].size.height;
	speedLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,screenH-180, 400, 140)];
    //speedLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 400, 140)];
	[speedLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]];
	[speedLabel setTextColor:[UIColor yellowColor]];
	[speedLabel setShadowColor:[UIColor blackColor]];
	[speedLabel setShadowOffset:CGSizeMake(2.0, 2.0)];
	[speedLabel setFont:[UIFont boldSystemFontOfSize:130]];
	[speedLabel setText:[NSString stringWithFormat:@" %4.1f  ",128.2]];
	[speedLabel setTextAlignment:UITextAlignmentRight];
    [_baseView addSubview:speedLabel];
	speedLabel.hidden=NO;  //TODO: change to YES;
	
	//unit label
	UILabel * unitLabel=[[UILabel alloc] initWithFrame:CGRectMake(340, 90, 60, 40)];
	[unitLabel setBackgroundColor:[UIColor clearColor]];
	[unitLabel setTextColor:[UIColor whiteColor]];
	
	//[unitLabel setText:@"MPH"];
	[speedLabel addSubview:unitLabel];
	
	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSString * unit=(NSString *)[defaults objectForKey:@"unit"];
	//if([unit compare:@"km"]==0){
    bool bMetric=false;     //TODO: do sth with this line
    if(bMetric){
		//bMetric=TRUE;
		[unitLabel setText:@"KM/Hr"];
	}else {
		//bMetric=FALSE;
		[unitLabel setText:@"MPH"];
	}
    [_baseView addSubview:speedLabel];
}
-(void)add_HeightPanel{
    int screenH=[_baseView frame].size.height;
	heightLabel=[[UILabel alloc] initWithFrame:CGRectMake(402,screenH-80, 200, 40)];
	[heightLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.4 alpha:0.5]];
	[heightLabel setTextColor:[UIColor yellowColor]];
	[heightLabel setShadowColor:[UIColor blackColor]];
	[heightLabel setShadowOffset:CGSizeMake(2.0, 2.0)];
	[heightLabel setFont:[UIFont boldSystemFontOfSize:40]];
	//[heightLabel setText:[NSString stringWithFormat:@" %4.1fm ",128.2]];
	[heightLabel setTextAlignment:UITextAlignmentRight];
    [_baseView addSubview:heightLabel];
}
-(void)add_TripMeter{
    int screenH=[_baseView frame].size.height;
	tripLabel=[[UILabel alloc] initWithFrame:CGRectMake(402,screenH-122, 200, 40)];
	[tripLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.5]];
	[tripLabel setTextColor:[UIColor yellowColor]];
	[tripLabel setShadowColor:[UIColor blackColor]];
	[tripLabel setShadowOffset:CGSizeMake(2.0, 2.0)];
	[tripLabel setFont:[UIFont boldSystemFontOfSize:40]];
	//[tripLabel setText:[NSString stringWithFormat:@" %4.1fm ",128.2]];
	[tripLabel setTextAlignment:UITextAlignmentRight];
    [_baseView addSubview:tripLabel];
}
@end
