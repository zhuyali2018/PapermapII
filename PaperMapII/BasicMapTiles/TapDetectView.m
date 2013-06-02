//
//  TapDetectView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define DOUBLE_TAP_DELAY 0.35

#import "TapDetectView.h"
#import "PM2Protocols.h"

@implementation TapDetectView

@synthesize mapTapHandler,drawDelegate;
//====================================================
CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}
//====================================================
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
		//NSLog(@"TapDetectView.initWithFrame:Initialized");
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
#define NEEDNSLOG
#pragma mark overriding UIResponder Methods-----------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//this means cancel calling the handleSingleTap if the calling command hasn't be executed because of the delayed call setup
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTwoFingerTap) object:nil];
    NSLog(@"<======================================[touchesBegan]======================================>");
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
    if ([[event touchesForView:self] count] == 1)
        twoFingerTapIsPossible = YES;
#ifdef NEEDNSLOG
    NSLog(@"[touchesBegan] number of fingers used:%d ",[[event touchesForView:self] count]);
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
	// single touch processing
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY]; //this means call handleSingleTap after 0.35 seconds
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
#ifdef NEEDNSLOG
		NSLog(@"[touchesEnded]Single touch, number of taps:%d",[touch tapCount]);
#endif
    }
    
    // check for 2-finger tap if we've seen multiple touches and haven't yet ruled out that possibility
	// 2 finger touch processing
    else if (multipleTouches && twoFingerTapIsPossible) {
        // case 1: this is the end of both touches at once
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0;
            int tapCounts[2]; CGPoint tapLocations[2];
            for (UITouch *touch in touches) {
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) { // it's a two-finger single taps
                tapLocation = midpointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];   //two finger touch at the same timing
				//[self performSelector:@selector(handleTwoFingerTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY]; //this means call handleSingleTap after 0.35 seconds				
#ifdef NEEDNSLOG
				NSLog(@"[touchesEnded] 2 touches at the same time");
#endif
            }
        }
        // case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if touch is a single tap, store its location so we can average it with the second touch location
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        }
		
        // case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = midpointBetweenPoints(tapLocation, [touch locationInView:self]);
                [self handleTwoFingerTap];    //two finger touch in a sequence, not at exactly the same time
#ifdef NEEDNSLOG
				NSLog(@"[touchesEnded] 2 touches Not at the same time");
#endif				
            }
        }
    }
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
#ifdef NEEDNSLOG
	NSLog(@"[touchesEnded] exits ...");
#endif
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
#ifdef NEEDNSLOG
	NSLog(@"[touchesCancelled] gets called ...");
#endif
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
#ifdef NEEDNSLOG
	NSLog(@"--->[touchesMoved] gets called ...");
#endif
	//rootView.CenterCurrentLocation=FALSE;   //when finger moved on screen, gps should unhook the center location
	//[self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
	UITouch *touch = [touches anyObject];
	tapLocation = [touch locationInView:self];
	[self handleSingleTap];
}
#pragma mark Touch Handling methods of the class------
- (void)handleSingleTap{
	NSLog(@"handleSingleTap - need to call external handler here");
	if ([drawDelegate respondsToSelector:@selector(tappedView:singleTapAtPoint:)])
        [drawDelegate tappedView:self singleTapAtPoint:tapLocation];
}
- (void)handleDoubleTap{
	NSLog(@"handleDoubleTap - means map zoom in one level and center map at tapped point");
	if ([mapTapHandler respondsToSelector:@selector(tapDetectView:gotDoubleTapAtPoint:)])
        [mapTapHandler tapDetectView:self gotDoubleTapAtPoint:tapLocation];
    
}
- (void)handleTwoFingerTap{
	NSLog(@"handleTwoFingerTap - means map zoom out one level and center the map at the mid point of 2 tapped points");
	if ([mapTapHandler respondsToSelector:@selector(tapDetectView:gotTwoFingerTapAtPoint:)])
        [mapTapHandler tapDetectView:self gotTwoFingerTapAtPoint:tapLocation];
    
}

@end
