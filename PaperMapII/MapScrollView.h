//
//  MapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZoomView.h"
#import "GPSTrackPOIBoard.h"
#import "PM2Protocols.h"

@interface MapScrollView : UIScrollView <UIScrollViewDelegate>{
    NSMutableSet    *reusableTiles;					//<======= recycled tiles holder
    BOOL            Mode;                           //<====TRUE: Western, FALSE:Eastern
    int             maplevel,minMapLevel,maxMapLevel,lastLevel;
    CGPoint			posErr,posErr1;

//@private int mapLevel;
}
//@property int maplevel;
-(int)maplevel;
-(void)setMaplevel:(int)maplevel;

//@property int maplevel;
@property (nonatomic, strong) ZoomView *zoomView;
@property (nonatomic, strong) GPSTrackPOIBoard *gpsTrackPOIBoard;
@property (nonatomic, strong) DrawingBoard * drawingBoard;          //freeDrawingBoard in PM1

@property (nonatomic) id<PM2MapSourceDelegate> mapsourceDelegate;
- (UIView *)dequeueReusableTile;
- (void)saveMapState;
- (void)restoreMapState;
- (void)reloadData;
- (bool)getMode;
@end
