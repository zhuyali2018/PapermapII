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
@public
    CGPoint			posErr,posErr1;               //posErr for current map tile position error, posErr1 is for the current adjusting session error
    int	            posErrResolution;             //for current map error resolution
    
    CGPoint	mapMapErr;                           //for storing the map map error
    CGPoint	satMapErr;                           //for storing the sat map error
    int mapErrResolution;                        //for storing the map Error Resolution
    int satErrResolution;                        //for storing the sat Error Resolution
}
-(int)maplevel;
-(void)setMaplevel:(int)maplevel;

//@property int maplevel;
@property (nonatomic, strong) ZoomView *zoomView;
@property (nonatomic, strong) GPSTrackPOIBoard *gpsTrackPOIBoard;
@property (nonatomic, strong) DrawingBoard * drawingBoard;          //freeDrawingBoard in PM1

-(void)refreshTilePositions;

@property (nonatomic) id<PM2MapSourceDelegate> mapsourceDelegate;
- (UIView *)dequeueReusableTile;
- (void)saveMapState;
- (void)restoreMapState;
- (void)reloadData;
- (bool)getMode;
-(CGPoint) adJustErrForResolution:(CGPoint)e res:(int) res;
@end
