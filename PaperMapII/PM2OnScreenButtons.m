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

@implementation PM2OnScreenButtons
@synthesize drawButton,fdrawButton;
@synthesize mapScrollView;
@synthesize resLabel;

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
}
-(void)addMapCenterIndicator:(UIView*)vc{
    int screenW=[vc bounds].size.width;
	int screenH=[vc bounds].size.height;
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
    [drawButton1 setFrame:CGRectMake([_baseView bounds].size.width-150, 150, 100, 30)];
    [drawButton1 setTitle:@"Undo" forState:UIControlStateNormal];
    [drawButton1 addTarget:self action:@selector(undoDrawing:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:drawButton1];
}
-(void)addFreeDrawButton{
    fdrawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [fdrawButton setFrame:CGRectMake([_baseView bounds].size.width-150, 100, 100, 30)];
    [fdrawButton setTitle:@"Free Draw" forState:UIControlStateNormal];
    [fdrawButton addTarget:self action:@selector(switchToFreeDraw:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:fdrawButton];
    //[fdrawButton setEnabled:FALSE];
    [fdrawButton setHidden:TRUE];
}
-(void)addDrawButton{
    drawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [drawButton setFrame:CGRectMake([_baseView bounds].size.width-150, 50, 100, 30)];
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
