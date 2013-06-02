//
//  TappableMapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define SIZE 256
#define ZOOM_STEP 2.0
#import "TappableMapScrollView.h"

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
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint{
    NSLog(@"singleTapAtPoint - need to call external handler here 2");
    if ([recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)]){
        [recordingDelegate mapLevel:self.maplevel singleTapAtPoint:tapPoint];
    }else {
        NSLog(@"[recordingDelegate respondsToSelector:@selector(mapLevel:singleTapAtPoint:)] returns false");
    }
}
@end
