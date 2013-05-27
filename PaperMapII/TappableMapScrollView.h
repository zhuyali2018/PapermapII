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
@interface TappableMapScrollView : MapScrollView <PM2MapTapHandleDelegate>
@property (nonatomic,strong)TapDetectView * tapDetectView;
@property (nonatomic) id<PM2SingleTapHandleDelegate> singleTapHandleDelegate;
@end
