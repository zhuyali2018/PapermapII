//
//  PM2OnScreenButtons.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "PM2OnScreenButtons.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"
#import "ScaleRuler.h"
#import "MapCenterIndicator.h"
#import "GPSReceiver.h"
#import "Track.h"


@implementation PM2OnScreenButtons
@synthesize drawButton,fdrawButton,colorButton;
@synthesize mapScrollView;
@synthesize resLabel;
@synthesize messageLabel;
@synthesize gpsReceiver;
@synthesize colorPickPopover;
@synthesize linePropertyViewCtrlr;

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
}
-(void) addColorButton{
    colorButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [colorButton setFrame:CGRectMake([_baseView bounds].size.height-150, 350, 100, 30)];
    [colorButton setTitle:@"Pick Color" forState:UIControlStateNormal];
    [colorButton addTarget:self action:@selector(colorPicker) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:colorButton];
}
-(void) addTrackCleanupButton{
    UIButton * gpsButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [gpsButton setFrame:CGRectMake([_baseView bounds].size.height-150, 300, 100, 30)];
    [gpsButton setTitle:@"Clean up" forState:UIControlStateNormal];
    [gpsButton addTarget:self action:@selector(cleanUpTrack) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:gpsButton];
}
-(void) addGPSButton{
    UIButton * gpsButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [gpsButton setFrame:CGRectMake([_baseView bounds].size.height-150, 200, 100, 30)];
    [gpsButton setTitle:@"Start GPS" forState:UIControlStateNormal];
    [gpsButton addTarget:self action:@selector(startGPS) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:gpsButton];
}
-(void) addStopGPSButton{
    UIButton * gpsButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [gpsButton setFrame:CGRectMake([_baseView bounds].size.height-150, 250, 100, 30)];
    [gpsButton setTitle:@"Stop GPS" forState:UIControlStateNormal];
    [gpsButton addTarget:self action:@selector(stopGPS) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:gpsButton];
}
-(void) keepFirstOneFrom:(NSMutableArray *)arr{
    int count=[arr count];
    if (count>1) {
        [arr removeObjectsInRange:NSMakeRange(1, count-1)];
    }
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
    UIButton * drawButton1=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [drawButton1 setFrame:CGRectMake([_baseView bounds].size.height-150, 150, 100, 30)];
    [drawButton1 setTitle:@"Undo" forState:UIControlStateNormal];
    [drawButton1 addTarget:self action:@selector(undoDrawing:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:drawButton1];
}
-(void)addFreeDrawButton{
    fdrawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [fdrawButton setFrame:CGRectMake([_baseView bounds].size.height-150, 100, 100, 30)];
    [fdrawButton setTitle:@"Free Draw" forState:UIControlStateNormal];
    [fdrawButton addTarget:self action:@selector(switchToFreeDraw:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:fdrawButton];
    //[fdrawButton setEnabled:FALSE];
    [fdrawButton setHidden:TRUE];
}
-(void)addDrawButton{
    drawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [drawButton setFrame:CGRectMake([_baseView bounds].size.height-150, 50, 100, 30)];
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

@end
