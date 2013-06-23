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
@end
