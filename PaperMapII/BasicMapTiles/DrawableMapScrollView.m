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
#import "ZoomView.h"
#import "MainQ.h"
#import "Node.h"

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
+ (DrawableMapScrollView *)sharedMap {
    static DrawableMapScrollView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)refresh{
    [self.gpsTrackPOIBoard setNeedsDisplay];
}
-(void)refreshDrawingBoard{
    [self.drawingBoard setNeedsDisplay];
}
-(void)centerPositionAtX:(int) x Y:(int) y{
    int adjX=[self.gpsTrackPOIBoard ModeAdjust:x res:self.maplevel];
    CGRect  visibleBounds = [self bounds];     //Check this should return a size of 1280x1280 instead of 1024x768 for rotating purpose
	CGFloat zm=[self zoomScale];
	CGPoint offset=CGPointMake(adjX*zm-visibleBounds.size.width/2, y*zm-visibleBounds.size.height/2);
	[self setContentOffset:offset animated:YES];   //this is where it makes map move smoothly
}
-(void)centerMapTo:(Node *)node{
    int mapL=self.gpsTrackPOIBoard.maplevel;
    int x=node.x*pow(2,mapL-node.r);
    int y=node.y*pow(2,mapL-node.r);
    [self centerPositionAtX:x Y:y];
}

@end
