//
//  DrawingBoard.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "DrawingBoard.h"

@implementation DrawingBoard
@synthesize ptrToTracksArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);   //make line smoother ?
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.1 green:0.1 blue:1.0 alpha:0.9].CGColor);
	CGContextSetLineWidth(context, 3);
	CGContextSetLineCap(context, kCGLineCapRound);  //version 4.0
    
    CGContextMoveToPoint(context, 0,0);
    CGContextAddLineToPoint(context, 500, 500);
    CGContextStrokePath(context);
    NSLOG1(@"Line Redrawn!");
}


//-(void)registTrack:(Track*)track{
//    if (!self.tracks) {
//        self.tracks=[[NSArray alloc]initWithObjects:track,nil];
//    }else{
//        self.tracks=[self.tracks arrayByAddingObject:track];
//    }
//}
@end
