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

@interface PM2OnScreenButtons : NSObject
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *fdrawButton;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) Recorder * routRecorder;
@property (nonatomic, strong) DrawableMapScrollView * mapScrollView;

+ (id)sharedBnManager;
-(void)addButtons:(UIView *)vc;
@end
