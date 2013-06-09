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
        self.bDrawing=true;
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
    [self.zoomView.gpsTrackPOIBoard.drawingBoard clearAll];
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
}
#pragma mark -----------------HandleSingleTap Delegate method------
#define FREEDrawBoard self.zoomView.gpsTrackPOIBoard.drawingBoard
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint{
    NSLOG3(@"singleTapAtPoint - need to call external handler here 2");
    if (!self.bDrawing) {
        return;
    }
    if (self.mapPined) {
        CGPoint tapPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];	//version 4.0
        //if(self.freeDraw)
            [FREEDrawBoard addNode:tapPt];	 //version 4.0
        [FREEDrawBoard setNeedsDisplay]; //version 4.0
    }
    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
        [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];
        if(!self.mapPined)  //in free draw mode, do not refresh every time for performance
            [self.zoomView.gpsTrackPOIBoard setNeedsDisplay];
        
    }else {
        NSLOG3(@"[recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)] returns false");
    }
}
@end
