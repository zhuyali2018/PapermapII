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
#import "GPSNode.h"
#import "Track.h"
#import "TapDetectView.h"
#import "LineProperty.h"
#import "Recorder.h"
#import "MainQ.h"

@implementation GPSTrackPOIBoard

@synthesize tapDetectView;
@synthesize ptrToTrackArray,ptrToGpsTrackArray;
@synthesize maplevel;
@synthesize drawingBoard;
@synthesize ptrToLastGpsNode;
@synthesize GPSRunning;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        drawingBoard=[[DrawingBoard alloc]initWithFrame:frame];	
		[drawingBoard setBackgroundColor:[UIColor clearColor]];	
		[self addSubview:drawingBoard];
     }
    return self;
}
-(int)ModeAdjust:(int)x res:(int)r{
    if(*self.pMode)
        return x;
    int H=TSIZE*pow(2,r-1);
    if(x<H)
        return x+H;
    return x-H;
}
-(CGPoint)ConvertPoint:(Node *)node{
    //Mode Adjust node.x:
    int nodeX=[self ModeAdjust:node.x res:node.r];
	//First, convert the point coordinates to current maplevel
	int delta=maplevel-node.r;
	float zoomFactor = pow(2, delta * -1);
	CGPoint p;
	p.x=nodeX/zoomFactor;
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
	
	Node * startNode;
    int i=0;
    for (i=0;i<count;i++){
        startNode=[track.nodes objectAtIndex:i];
        if(startNode.y!=0)          //y==0 means it is a terminating node
            break;
    }
    CGPoint pStart=[self ConvertPoint:startNode];
	CGContextMoveToPoint(context, pStart.x, pStart.y);
	for (int j=i; j<count; j++) {
		Node * tmpN=[track.nodes objectAtIndex:j];
        bool terNodeFound=false;
        while (tmpN.y==0) {
            terNodeFound=true;
            j++;
            tmpN=[track.nodes objectAtIndex:j];
        }
        CGPoint tmpP=[self ConvertPoint:tmpN];
        if(terNodeFound){
            CGContextMoveToPoint(context, tmpP.x, tmpP.y);
            terNodeFound=false;
        }else
            CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
	}
	CGContextStrokePath(context);
}
-(void)gpsDrawTrack:(Track *)track context:(CGContextRef)context{
    if(!track) return;
    if(nil==track.nodes)
        return;
    int count=[track.nodes count];
    if(count<2) return;
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:COLOR.red green:COLOR.green blue:COLOR.blue alpha:COLOR.alpha].CGColor);
	CGContextSetLineWidth(context, COLOR.lineWidth);
	CGContextSetLineCap(context, kCGLineCapRound);  //version 4.0
	
	GPSNode * startNode=[track.nodes objectAtIndex:0];
    CGPoint pStart=[self ConvertPoint:startNode];
	CGContextMoveToPoint(context, pStart.x, pStart.y);
	for (int i=1; i<count; i++) {
		GPSNode * tmpN=[track.nodes objectAtIndex:i];
        CGPoint tmpP=[self ConvertPoint:tmpN];
		CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
	}
    //draw to the lastGPSNode if it is not 0
//    if ((ptrToLastGpsNode.x>0) &&(ptrToLastGpsNode.y>0)){
//        CGPoint tmpP=[self ConvertPoint:ptrToLastGpsNode];
//        CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
//    }
	CGContextStrokePath(context);
}
-(void)drawLines:(CGContextRef)context{
    if (maplevel<2) {
        return;         //no drawing on maplevel 1 and 0
    }
    // Drawing code
    if (!ptrToTrackArray) {  //if not initialized
        ptrToTrackArray=((Recorder *)[Recorder sharedRecorder]).trackArray;
    }
    if ([ptrToTrackArray count]==0) {  // if 0 element
        return;
    }
    
    CGContextSetShouldAntialias(context, YES);   //make line smoother ?
    
    //Drawing lines
    for (int i=0; i<[ptrToTrackArray count]; i++) {     //loop through each track in track array
        [self tapDrawTrack:ptrToTrackArray[i] context:context];
    }
}
-(void)drawGpsTracks:(CGContextRef)context{
    if (maplevel<2) {
        return;         //no drawing on maplevel 1 and 0
    }
    // Drawing code
    if (!ptrToGpsTrackArray) {  //if not initialized
        ptrToGpsTrackArray=((Recorder *)[Recorder sharedRecorder]).gpsTrackArray;
    }
    if ([ptrToGpsTrackArray count]==0) {  // if 0 element
        return;
    }
    if (!ptrToLastGpsNode) {  //if not initialized
        ptrToLastGpsNode=((Recorder *)[Recorder sharedRecorder]).lastGpsNode;
    }
    CGContextSetShouldAntialias(context, YES);   //make line smoother ?
    
    //Drawing lines
    for (int i=0; i<[ptrToGpsTrackArray count]; i++) {     //loop through each track arrays of track arrays
        [self gpsDrawTrack:ptrToGpsTrackArray[i] context:context];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLines:context];
    [self drawGpsTracks:context];
}

@end
