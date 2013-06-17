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

#pragma mark Singleton Methods
+ (id)sharedMap {
    static DrawableMapScrollView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#define DRAWINGBOARD self.zoomView.gpsTrackPOIBoard
-(void)registTracksToBeDrawn1:(NSMutableArray*)tracks1{
    if (!DRAWINGBOARD.ptrToTracksArray) {
        DRAWINGBOARD.ptrToTracksArray=[[NSMutableArray alloc]initWithCapacity:3];
    }
    [DRAWINGBOARD.ptrToTracksArray addObject:tracks1];
}
-(void)registTracksToBeDrawn:(NSMutableArray*)tracks1{
    DRAWINGBOARD.ptrToTracksArray=tracks1;
}
@end
