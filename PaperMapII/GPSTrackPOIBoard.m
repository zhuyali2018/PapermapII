//
//  GPSTrackPOIBoard.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"

@implementation GPSTrackPOIBoard
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
