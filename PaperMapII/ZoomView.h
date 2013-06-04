//
//  ZoomView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/17/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileContainer.h"
#import "PM2Protocols.h"
@class GPSTrackPOIBoard;
@interface ZoomView : UIView 

@property (nonatomic, strong)TileContainer *tileContainer;
@property (nonatomic, strong)TileContainer *basicMapLayer;
@property (nonatomic, strong)GPSTrackPOIBoard *gpsTrackPOIBoard;
@end
