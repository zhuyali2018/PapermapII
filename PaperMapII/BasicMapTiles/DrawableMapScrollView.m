//
//  DrawableMapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "DrawableMapScrollView.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"

@implementation DrawableMapScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#define DRAWINGBOARD self.zoomView.gpsTrackPOIBoard
-(void)registTracksToBeDrawn:(NSArray*)tracks1{
    if (!DRAWINGBOARD.ptrToTracksArray) {
        DRAWINGBOARD.ptrToTracksArray=[[NSMutableArray alloc]initWithCapacity:3];
    }
    [DRAWINGBOARD.ptrToTracksArray addObject:tracks1];
}
@end
