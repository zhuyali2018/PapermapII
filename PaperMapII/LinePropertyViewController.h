//
//  LinePropertyViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinePropStorageViewController.h"

typedef enum{DrawingLineProperty,GPSTrackProperty} TrackProperty;

@class PropertyButton;

@interface LinePropertyViewController : UIViewController

@property (nonatomic,strong) LinePropStorageViewController * linePSVCtrl;
@property (nonatomic,strong) PropertyButton * bnGPSTrack;
@property (nonatomic,strong) PropertyButton * bnDrawingLine;
@property (nonatomic,strong) UILabel * gpsTrackLabel;
@property (nonatomic,strong) UILabel * drawingLineLabel;
@property TrackProperty trackProperty;     //used to remember which property user has selected to set
@end
