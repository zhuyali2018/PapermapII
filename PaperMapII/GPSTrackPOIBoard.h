//
//  GPSTrackPOIBoard.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
//equivelant to DrawingBoard in old code

#import <UIKit/UIKit.h>
@class DrawingBoard;    //equivlant to FreeDrawBoard in old code
@class Track;
@class TapDetectView;

@interface GPSTrackPOIBoard : UIView

@property (nonatomic) BOOL * pMode;
@property (nonatomic,weak) TapDetectView * tapDetectView;
@property (nonatomic,strong) NSMutableArray * ptrToTracksArray;   //array of pointers to tracks which is also an array of tracks
@property int maplevel;

@property (nonatomic) DrawingBoard * drawingBoard;          //freeDrawingBoard in PM1

-(int)ModeAdjust:(int)x res:(int)r;

@end
