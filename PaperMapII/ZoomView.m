//
//  ZoomView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/17/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "ZoomView.h"
#import "GPSTrackPOIBoard.h"
@implementation ZoomView
@synthesize tileContainer;
@synthesize basicMapLayer;
@synthesize gpsTrackPOIBoard;

extern const int bz;        //bezel width, should be set to 0 eventually
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        basicMapLayer=[[TileContainer alloc] initWithFrame:CGRectMake(bz,bz,1000, 1000)];
        [basicMapLayer setBackgroundColor:[UIColor clearColor]];
        [self addSubview:basicMapLayer];
        
        tileContainer=[[TileContainer alloc] initWithFrame:CGRectMake(bz,bz,1000, 1000)];
        [tileContainer setBackgroundColor:[UIColor cyanColor]];
        [self addSubview:tileContainer];
        
        gpsTrackPOIBoard = [[GPSTrackPOIBoard alloc] initWithFrame:CGRectMake(100,100,frame.size.width-200,frame.size.height-200)];
		[self addSubview:gpsTrackPOIBoard];
        //[gpsTrackPOIBoard setBackgroundColor:[UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.5]];
        [gpsTrackPOIBoard setBackgroundColor:[UIColor clearColor]];    //without this line, map view will be blocked black
        //[drawingBoard setBackgroundColor:[UIColor clearColor]];
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
