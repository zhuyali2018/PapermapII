//
//  GPSTrackPOIBoard.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"
#import "Node.h"
#import "Track.h"
#import "TapDetectView.h"
#import "LineProperty.h"

@implementation GPSTrackPOIBoard

@synthesize tapDetectView;
@synthesize ptrToTracksArray;
@synthesize maplevel;
@synthesize drawingBoard;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        drawingBoard=[[DrawingBoard alloc]initWithFrame:frame];	//version 4.0
		[drawingBoard setBackgroundColor:[UIColor clearColor]];	//version 4.0
		[self addSubview:drawingBoard];							//version 4.0
    }
    return self;
}
-(CGPoint)ConvertPoint:(Node *)node{
	//First, convert the point coordinates to current maplevel
	int delta=maplevel-node.r;
	float zoomFactor = pow(2, delta * -1);
	CGPoint p;
	p.x=node.x/zoomFactor;
	p.y=node.y/zoomFactor;
	//Second, convert the point's coordinates to the coordinates on DrawingBoard which is significantly smaller, only covers window area
	CGPoint p2=[tapDetectView convertPoint:p toView:self];
	return p2;
}
#define COLOR track.lineProperty
-(void)drawTrack:(Track *)track context:(CGContextRef)context{
    if(!track) return;
    if(nil==track.nodes)
        return;
    int count=[track.nodes count];
    if(count<2) return;
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:COLOR.red green:COLOR.green blue:COLOR.blue alpha:COLOR.alpha].CGColor);
	CGContextSetLineWidth(context, COLOR.lineWidth);
	CGContextSetLineCap(context, kCGLineCapRound);  //version 4.0
	
	Node * startNode=[track.nodes objectAtIndex:0];
    CGPoint pStart=[self ConvertPoint:startNode];
	CGContextMoveToPoint(context, pStart.x, pStart.y);
	for (int i=1; i<count; i++) {
		Node * tmpN=[track.nodes objectAtIndex:i];
        CGPoint tmpP=[self ConvertPoint:tmpN];
		CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
	}
	CGContextStrokePath(context);
}
-(void)tapDrawTrack:(Track *)track context:(CGContextRef)context{
    if(!track) return;
    if(nil==track.nodes)
        return;
    int count=[track.nodes count];
    if(count<2) return;
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:COLOR.red green:COLOR.green blue:COLOR.blue alpha:COLOR.alpha].CGColor);
	CGContextSetLineWidth(context, COLOR.lineWidth);
	CGContextSetLineCap(context, kCGLineCapRound);  //version 4.0
	
	Node * startNode=[track.nodes objectAtIndex:0];
    CGPoint pStart=[self ConvertPoint:startNode];
	CGContextMoveToPoint(context, pStart.x, pStart.y);
	for (int i=1; i<count; i++) {
		Node * tmpN=[track.nodes objectAtIndex:i];
        CGPoint tmpP=[self ConvertPoint:tmpN];
		CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
	}
	CGContextStrokePath(context);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!ptrToTracksArray) {  //if not initialized
        return;
    }
    if ([ptrToTracksArray count]==0) {  // if 0 element
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);   //make line smoother ?
    
    for (int i=0; i<[ptrToTracksArray count]; i++) {     //loop through each track arrays of track arrays
        for (int j=0;j<[ptrToTracksArray[i] count]; j++) {  //loop through each track arry for each track array
            for (int k=0;k<[ptrToTracksArray[i][j] count]; k++) {  //loop through each track for each track array
                Track * track=ptrToTracksArray[i][j][k];
                [self tapDrawTrack:track context:context];
            }
        }
    }
    
    NSLOG4(@"Line Redrawn!");
}


@end
