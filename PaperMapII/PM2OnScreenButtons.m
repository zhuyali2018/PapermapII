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

@implementation PM2OnScreenButtons
@synthesize drawButton,fdrawButton;
@synthesize mapScrollView;
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
