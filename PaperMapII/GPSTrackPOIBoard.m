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
#import "GPSTrack.h"
#import "DrawableMapScrollView.h"
#import "MenuNode.h"
#import "POI.h"
#import "TextInput.h"

#define MAPMODE [[DrawableMapScrollView sharedMap] getMode]

@implementation GPSTrackPOIBoard

@synthesize tapDetectView;
@synthesize ptrToTrackArray,ptrToGpsTrackArray,ptrToPoiArray;
@synthesize maplevel;

//@synthesize ptrToLastGpsNode;
//@synthesize GPSRunning;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(int)ModeAdjust:(int)x res:(int)r{
    if(MAPMODE)
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
    if (track.folder) {  //very important, or it will crash for ever, deadloop
        return;
    }
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
-(void)gpsDrawTrack:(Track *)track context:(CGContextRef)context lastTrack:(BOOL)lastTrack{
    if(!track) return;
    if (track.folder) {
        return;
    }
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
    GPSNode * lastGpsNode=[Recorder sharedRecorder].lastGpsNode;
    if ((lastGpsNode.x>0) &&(lastGpsNode.y>0)&&lastTrack){
        CGPoint tmpP=[self ConvertPoint:lastGpsNode];
        CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
        //NSLOG10(@"Draw To lastGpsNode=(%d,%d) LastTrack?%d",lastGpsNode.x,lastGpsNode.y,lastTrack);
    }
    //NSLOG10(@"==>Draw To lastGpsNode=(%d,%d) LastTrack?%d",lastGpsNode.x,lastGpsNode.y,lastTrack);

	CGContextStrokePath(context);
    //NSLOG10(@"lastGpsNode=(%d,%d)",ptrToLastGpsNode.x,ptrToLastGpsNode.y);
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
        if (((MenuNode *)ptrToTrackArray[i]).selected)
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
    CGContextSetShouldAntialias(context, YES);   //make line smoother ?
    
    //Drawing lines
    for (int i=0; i<[ptrToGpsTrackArray count]; i++) {     //loop through each track arrays of track arrays
        if (((MenuNode *)ptrToGpsTrackArray[i]).selected) {
            [self gpsDrawTrack:ptrToGpsTrackArray[i] context:context lastTrack:((i+1)==[ptrToGpsTrackArray count])];
        }
    }
}
-(void)addInputLabel:(POI *)poi At:(CGPoint)pt{
	if((poi.title==nil)||(poi.title.length==0)){  //input label
		CGRect inputRect=CGRectMake(pt.x-15, pt.y, 128, 25);
		CGRect cvtedRect=[self convertRect:inputRect toView:tapDetectView];
        
		TextInput *label = [[TextInput alloc] initWithFrame:cvtedRect];
		[label setTextAlignment:UITextAlignmentLeft];
		[label setBackgroundColor:[UIColor redColor]];
		[label setTextColor:[UIColor yellowColor]];
		//[label setShadowColor:[UIColor blackColor]];
		//[label setShadowOffset:CGSizeMake(1.5, 2.0)];
		[label setFont:[UIFont systemFontOfSize:16]];
		
		//[label setText:[NSString stringWithFormat:@"%@", title]];
		label.delegate=self;
		label.poi=poi;
		[tapDetectView addSubview:label];
		return;
	}
	//UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pt.x-15, pt.y, 128, 25)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pt.x-15, pt.y, 200, 25)]; //1029
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pt.x-15, pt.y-10, 200, 25)]; //version 5.05
	[label setTextAlignment:UITextAlignmentLeft];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor yellowColor]];
	[label setShadowColor:[UIColor blackColor]];
	//[label setShadowOffset:CGSizeMake(1.5, 2.0)];
    [label setShadowOffset:CGSizeMake(1.0, 1.0)];   //version 5.05
	//[label setFont:[UIFont systemFontOfSize:16]];
	[label setFont:[UIFont systemFontOfSize:12]];   //1029
	[label setText:[NSString stringWithFormat:@"%@", poi.title]];
	[self addSubview:label];
}
-(CGPoint)ConvertPoint1:(POI *)node{
    //Mode Adjust node.x:
    int nodeX=[self ModeAdjust:node.x res:node.res];
    int delta=maplevel-node.res;
	float zoomFactor = pow(2, delta * -1);
	CGPoint p;
	p.x=nodeX/zoomFactor;
	p.y=node.y/zoomFactor;    //map node position to current maplevel with point p
	CGPoint p2=[tapDetectView convertPoint:p toView:self];  //map the point p to gpsTrackPoiBoard view
	return p2;
}
-(void)drawPOIs{
    //remove subviews first, even count ==0
    for (UIView *view in [self subviews]) {
            [view removeFromSuperview];
    }
    [self addSubview:[DrawableMapScrollView sharedMap].drawingBoard];  //version 4.0
    
    NSArray * flagNameArray=[NSArray arrayWithObjects:@"Blue_flag.png",@"Purple_flag.png",@"Green_flag.png",@"Yellow_flag.png",@"Orange_flag.png",@"Red_flag.png",nil];
    // Drawing code
    if (!ptrToPoiArray) {  //if not initialized
        ptrToPoiArray=((Recorder *)[Recorder sharedRecorder]).poiArray;
    }
    if ([ptrToPoiArray count]==0) {  // if 0 element
        return;
    }
    for (POI *poi in ptrToPoiArray) {
        if (poi.folder) {  //folder can not be drawn or showing on map !
            continue;
        }
        if (!poi.selected) {
            continue;
        }
		NSString * flagName=[[NSString alloc]initWithString:(NSString *)[flagNameArray objectAtIndex:(int)poi.nType]];
		UIImageView * imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:flagName]];
		[imgv setFrame:CGRectMake(0, 0, 26, 26)];   //reset flag size smaller from 40x40
		CGPoint ctr=[self ConvertPoint1:poi];
		CGPoint rt=CGPointMake(ctr.x+imgv.frame.size.width/2-5, ctr.y-imgv.frame.size.height/2);
		imgv.center=rt;
		[self addSubview:imgv];
		
		CGPoint lbPt=CGPointMake(rt.x, rt.y-imgv.frame.size.height);
		[self addInputLabel:poi At:lbPt];
	}

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawPOIs];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLines:context];
    [self drawGpsTracks:context];
}
#pragma mark UITextField Delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField{
	((TextInput *)(textField)).poi.title=[textField.text copy];
    [((TextInput *)(textField)).poi updateAppearance];
	[textField removeFromSuperview];
	[self setNeedsDisplay];
}
//hide keyboard when return is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}
@end
