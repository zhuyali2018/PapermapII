//
//  PM2OnScreenButtons.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"
#import "DrawableMapScrollView.h"
#import "LinePropertyViewController.h"

@class GPSReceiver;

@interface PM2OnScreenButtons : NSObject
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) UIButton *fdrawButton;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) UIButton *stopGpsButton;
@property (nonatomic, strong) UIButton *cleanupButton;
@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *mapTypeButton;
@property (nonatomic, strong) UIButton *unloadDrawingButton;
@property (nonatomic, strong) UIButton *unloadGPSTrackButton;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) Recorder * routRecorder;
@property (nonatomic, strong) DrawableMapScrollView * mapScrollView;
@property (nonatomic, strong) UILabel * resLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) GPSReceiver * gpsReceiver;
@property (strong, nonatomic) UIPopoverController* colorPickPopover;
@property (strong, nonatomic) LinePropertyViewController * linePropertyViewCtrlr;
+ (id)sharedBnManager;
-(void)addButtons:(UIView *)vc;
-(void)updateMapLevel;
-(void)repositionButtonsFromX:(int)x Y:(int)y;
@end
