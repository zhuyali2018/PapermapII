//
//  TappableMapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define SIZE 256
#define ZOOM_STEP 2.0

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
 }
- (void)tapDetectView:(TapDetectView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    float newScale = [self zoomScale] / ZOOM_STEP;
    //NSLog(@"[tapDetectView.gotTwoFingerTapAtPoint] newScale=%6.2f",newScale );
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self zoomToRect:zoomRect animated:YES];
    //[NSTimer scheduledTimerWithTimeInterval:0.99 target:imageScrollView selector:@selector(restoreOffset) userInfo:nil repeats: NO];
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
            CGPoint tapPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];
            if((tapPoint.x==0)&&(tapPoint.y==0)){       //if tapPoint is (0,0), it is a signal to start a new track
                [FREEDrawBoard clearAll];               //clear all points and call setNeedsDisplay
                [self.zoomView.gpsTrackPOIBoard setNeedsDisplay];   //refresh our track board too
            }else{
                [FREEDrawBoard addNode:tapPt];               //add a point and call setNeedsDisplay
            }
            if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
                [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];       //if tapPoint is (0,0), it is a signal for starting a new track
                NSLOG5(@"Node added:(%.2f,%.2f)",tapPoint.x,tapPoint.y);
                return;
            }
        }else{ //is drawing, mapPined but not freeDraw. got to be drawing with predrawingline
            if (tapPoint.x==0) {  //if touch up happened
                if (FREEDrawBoard.firstPt.x!=0) {   //means predrawing is going
                    FREEDrawBoard.firstPt=CGPointMake(0,0);      //reset the state for next segment predrawing
                    CGPoint lastTapPoint=[FREEDrawBoard convertPoint:FREEDrawBoard.lastPt  toView:view];
                    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
                        [recordingDelegate mapLevel:_lastMaplevel singleTapAtPoint:lastTapPoint];
                        NSLOG5(@"NON Free Draw Node added:(%.2f,%.2f)",lastTapPoint.x,lastTapPoint.y);
                        [self.zoomView.gpsTrackPOIBoard.drawingBoard clearAll];
                        [self.zoomView.gpsTrackPOIBoard.drawingBoard setNeedsDisplay];
                        [self.zoomView.gpsTrackPOIBoard setNeedsDisplay];
                        return;
                    }
                }
                return;     //no handle of this situation(touch up if no drawing was going on), just return;
            }
            //normal tap line segment drawing:
            if (FREEDrawBoard.firstPt.x==0) {                                             //if first point not set, set it and start next segment of drawing
                if (FREEDrawBoard.lastPt.x!=0) {                                                //if the last point set, but first not set,move last to first, but do not save
                    FREEDrawBoard.firstPt=FREEDrawBoard.lastPt;
                }else{                                                                          //if firsst point and last point are both 0, 
                    FREEDrawBoard.firstPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];   //first point of rubberband drawing has to be set.
                    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){      //save the point and move on
                        [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];
                    }
                }
            }
            FREEDrawBoard.lastPt=[view convertPoint:tapPoint  toView:FREEDrawBoard];      //always set last point and refresh the display for predrawing of the line
            _lastMaplevel=maplevel;
            
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
