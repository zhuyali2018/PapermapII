//
//  TappableMapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define SIZE 256
#define ZOOM_STEP 2.0

#import "PM2AppDelegate.h"      //TODO: Remove this line for final release
#import "PM2ViewController.h"   //TODO: Remove this line for final release
#import "Recorder.h"            //TODO: Remove this line for final release

#import "AllImports.h"
#import "TappableMapScrollView.h"
#import "DrawingBoard.h"
#import "GPSTrackPOIBoard.h"

@implementation TappableMapScrollView
@synthesize tapDetectView;
@synthesize recordingDelegate;
//===================================
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    
	zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
	// choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
//===================================
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tapDetectView=[[TapDetectView alloc] initWithFrame:self.zoomView.frame];
        tapDetectView.contentMode=UIViewContentModeRedraw;
        tapDetectView.mapTapHandler=self;    //let zoomView handles the map related taps
        //[tapDetectView setBackgroundColor:[UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.5]];
        //[tapDetectView setBackgroundColor:[UIColor redColor]];
        [tapDetectView setBackgroundColor:[UIColor clearColor]];  //without this line, the map would be black !
        tapDetectView.drawDelegate=self;
        [self.zoomView addSubview:tapDetectView];
        self.zoomView.gpsTrackPOIBoard.tapDetectView=tapDetectView;
        self.bDrawing=false;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    [super scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    //this overwrite and setting works !!!
    float calSide=SIZE*pow(2, maplevel);
    CGRect fr1=CGRectMake(0, 0, calSide, calSide);
    [tapDetectView setFrame:fr1];
}
#pragma mark------------------------------------------
#pragma mark protocal PM2MapTapHandleDelegate methods
- (void)tapDetectView:(TapDetectView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
	float newScale = [self zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self zoomToRect:zoomRect animated:YES];
    
    PM2AppDelegate * dele=[[UIApplication sharedApplication] delegate];     //TODO: Remove this test line
    [dele.viewController.routRecorder stop];                                //TODO: Remove this test line
    NSLOG4(@"Recorder Stopped!");                                           //TODO: Remove this test line
    
    self.mapPined=FALSE;                  //TODO: remove this line for release
    [self setScrollEnabled:YES];          //TODO: remove this free draw test line
    [self.zoomView.gpsTrackPOIBoard.drawingBoard clearAll];                 //TODO: remove this line for release
    self.zoomView.gpsTrackPOIBoard.drawingBoard.firstPt=CGPointMake(0,0);  //TODO: remove this line for release
    self.zoomView.gpsTrackPOIBoard.drawingBoard.lastPt=CGPointMake(0,0);    //TODO: remove this line for release
}
- (void)tapDetectView:(TapDetectView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    float newScale = [self zoomScale] / ZOOM_STEP;
    //NSLog(@"[tapDetectView.gotTwoFingerTapAtPoint] newScale=%6.2f",newScale );
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self zoomToRect:zoomRect animated:YES];
    //[NSTimer scheduledTimerWithTimeInterval:0.99 target:imageScrollView selector:@selector(restoreOffset) userInfo:nil repeats: NO];
    PM2AppDelegate * dele=[[UIApplication sharedApplication] delegate];     //TODO: Remove this test line
    [dele.viewController.routRecorder start:dele.viewController.lineProperty];   //TODO: Remove this test line
    NSLOG4(@"Recorder started!");
    self.mapPined=TRUE;                  //TODO: remove this line for release
    [self setScrollEnabled:NO];          //TODO: remove this free draw test line
    self.freeDraw=false;                 //TODO: remove this line for release
    self.bDrawing=true;                    //TODO: remove this line for release
}
#pragma mark -----------------HandleSingleTap Delegate method------
#define FREEDrawBoard self.zoomView.gpsTrackPOIBoard.drawingBoard
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint{
    NSLOG3(@"singleTapAtPoint - need to call external handler here 2");
    if (!self.bDrawing) {
        return;
    }
    if (self.mapPined) {
        if(self.freeDraw){
            CGPoint tapPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];	//version 4.0
            [FREEDrawBoard addNode:tapPt];	 //version 4.0
            [FREEDrawBoard setNeedsDisplay]; //version 4.0
            if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
                [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];
                return;
            }
        }else{ //is drawing, mapPined but not freeDraw. got to be drawing with predrawingline
            if (tapPoint.x==0) {  //if touch up happened
                if (FREEDrawBoard.firstPt.x!=0) {   //means predrawing is going
                    FREEDrawBoard.firstPt=CGPointMake(0,0);      //reset the state for next segment predrawing
                    CGPoint lastTapPoint=[FREEDrawBoard convertPoint:FREEDrawBoard.lastPt  toView:view];
                    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
                        [recordingDelegate mapLevel:_lastMaplevel singleTapAtPoint:lastTapPoint];
                        [self.zoomView.gpsTrackPOIBoard.drawingBoard clearAll];
                        [self.zoomView.gpsTrackPOIBoard.drawingBoard setNeedsDisplay];
                        [self.zoomView.gpsTrackPOIBoard setNeedsDisplay];
                        return;
                    }
                }
                return;     //no handle of this situation, just return;
            }
            if (FREEDrawBoard.firstPt.x==0) {                                             //if first point not set, set it and start next segment of drawing
                if (FREEDrawBoard.lastPt.x!=0) {
                    FREEDrawBoard.firstPt=FREEDrawBoard.lastPt;
                }else{
                    FREEDrawBoard.firstPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];
                    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){      //first point of rubberband drawing has to be set.
                        [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];
                    }
                }
            }
            FREEDrawBoard.lastPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];      //always set last point and refresh the display for predrawing of the line
            _lastMaplevel=maplevel;
            FREEDrawBoard.preDraw=true;
            [FREEDrawBoard setNeedsDisplay];
        }
        return;
    }
    if(tapPoint.x==0)return;  //no handle of touchup
    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
        [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];
        [self.zoomView.gpsTrackPOIBoard setNeedsDisplay];
        
    }else {
        NSLOG3(@"[recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)] returns false");
    }
}
@end
