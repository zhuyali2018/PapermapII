//
//  DrawingBoard.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "DrawingBoard.h"
#import "LineProperty.h"
#import "Recorder.h"
#import "Track.h"
#import "MainQ.h"
@implementation DrawingBoard


@synthesize ptList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.preDraw=false;
        self.lastPt=self.firstPt=CGPointMake(0,0);
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//#define LP ((LineProperty *)[LineProperty sharedDrawingLineProperty])
#define LP [Recorder sharedRecorder].track.lineProperty
- (void)drawRect:(CGRect)rect
{
    if (self.preDraw) {
        if (self.firstPt.x==0) {
            return;
        }
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, YES);   //make line smoother ?
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:LP.red green:LP.green blue:LP.blue alpha:LP.alpha].CGColor);
        CGContextSetLineWidth(context, LP.lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);  //version 4.0
        CGPoint pStart=self.firstPt;
        CGContextMoveToPoint(context, pStart.x, pStart.y);
        CGPoint tmpP=self.lastPt;
        CGContextAddLineToPoint(context, tmpP.x, tmpP.y);
        CGContextStrokePath(context);
        return;
    }
    if (ptList==nil) {
        return;
    }
    int count=(int)[ptList count];
    if(count<2) return;
    //NSLog(@"entered free drawing board's drawRect...: %.0f,%.0f,%.0f,%.0f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    // Drawing code.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);   //make line smoother ?
    
    //NSLog(@"start draw on free drawing board's drawRect.... bluevalue:%.2f",LNPROP.blue);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:LP.red green:LP.green blue:LP.blue alpha:LP.alpha].CGColor);
    CGContextSetLineWidth(context, LP.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);  //version 4.0
    
    CGPoint pStart=[[ptList objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, pStart.x, pStart.y);
    for (int i=1; i<count; i++) {
        CGPoint tmpP=[[ptList objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, tmpP.x, tmpP.y);	
    }
    CGContextStrokePath(context);

}


-(void) addNode:(CGPoint) pt{
	if (ptList==nil) {
		ptList=[[NSArray alloc]initWithObjects:[NSValue valueWithCGPoint:pt],nil];
	}else {
        NSLOG5(@"pt added to freeDrawView: %.2f,%.2f",pt.x,pt.y);
		ptList=[ptList arrayByAddingObject:[NSValue valueWithCGPoint:pt]];
	}
    [self setNeedsDisplay];
}
-(void) clearAll{
	if (ptList==nil) {
		return;
	}
	NSMutableArray * temp=[[NSMutableArray alloc] initWithArray:ptList];
	[temp removeAllObjects];
	ptList=temp;
	ptList=nil;
	[self setNeedsDisplay];
}

@end
