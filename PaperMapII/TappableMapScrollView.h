//
//  TappableMapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "PM2Protocols.h"
#import "MapScrollView.h"
#import "TapDetectView.h"
@interface TappableMapScrollView : MapScrollView <PM2MapTapHandleDelegate,PM2SingleTapHandleDelegate>
@property int lastMaplevel;   //TODO: Remove this unused
@property bool mapPined;
@property bool freeDraw;        
@property (nonatomic,strong)TapDetectView * tapDetectView;
@property (nonatomic) id<PM2RecordingDelegate> recordingDelegate;
@property bool bDrawing;  //if the map is in drawing mode
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint;
@end
