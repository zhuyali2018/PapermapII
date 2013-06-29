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
@class GPSNode;
@class TapDetectView;

@interface GPSTrackPOIBoard : UIView

@property (nonatomic) BOOL * pMode;
@property (nonatomic,weak) TapDetectView * tapDetectView;
@property (nonatomic,weak) NSMutableArray * ptrToTrackArray;   //pointer to an array of tracks
@property (nonatomic,weak) NSMutableArray * ptrToGpsTrackArray;   //pointer to an array of tracks
@property (nonatomic,weak) GPSNode * ptrToLastGpsNode;
@property int maplevel;

@property (nonatomic) DrawingBoard * drawingBoard;          //freeDrawingBoard in PM1
@property (nonatomic, strong) UIImageView * arrow;

-(int)ModeAdjust:(int)x res:(int)r;
-(void) showArrow;
-(void) hideArrow;
@end
